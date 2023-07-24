import boto3

ec2_resource = boto3.resource('ec2')

instances = ec2_resource.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

# List running instances
for instance in instances:
      print(instance.instance_id)
