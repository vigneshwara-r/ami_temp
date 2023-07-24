import boto3

client = boto3.client('s3')
response = client.create_bucket(
            ACL='private',
            Bucket='cyrusdaredevil007',
            CreateBucketConfiguration={
                'LocationConstraint': 'us-west-1'
                                    },
            ObjectLockEnabledForBucket=False,
            ObjectOwnership='BucketOwnerPreferred'
                                                )
