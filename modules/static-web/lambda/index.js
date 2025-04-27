// CloudFront Invalidation Lambda
const AWS = require('aws-sdk');
const cloudfront = new AWS.CloudFront();

exports.handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
  
  const distributionId = process.env.DISTRIBUTION_ID;
  if (!distributionId) {
    throw new Error('DISTRIBUTION_ID environment variable not set');
  }
  
  let paths = ['/*']; // デフォルトはすべてのパスを無効化
  
  // S3イベントからパスを抽出
  if (event.Records && event.Records.length > 0 && event.Records[0].s3) {
    paths = event.Records.map(record => {
      const key = record.s3.object.key;
      return `/${key}`;
    });
  }
  
  // イベントから直接パスが指定されている場合
  if (event.paths && Array.isArray(event.paths)) {
    paths = event.paths;
  }
  
  console.log(`Creating invalidation for distribution ${distributionId} with paths: ${paths.join(', ')}`);
  
  const params = {
    DistributionId: distributionId,
    InvalidationBatch: {
      CallerReference: Date.now().toString(),
      Paths: {
        Quantity: paths.length,
        Items: paths
      }
    }
  };
  
  try {
    const result = await cloudfront.createInvalidation(params).promise();
    console.log('Invalidation created:', result);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Invalidation created successfully',
        invalidationId: result.Invalidation.Id
      })
    };
  } catch (error) {
    console.error('Error creating invalidation:', error);
    throw error;
  }
}; 