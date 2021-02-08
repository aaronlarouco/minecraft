import boto3

class API(object):
    def __init__(self):
        self.session = boto3.session.Session(region_name=os.environ.get('REGION', 'us-east-1'))
        self.ec2 = self.session.client('ec2')

    def start_instance():
        instance = self.get_instance_status()
        status = instance['State']['Name']
        if status == 'stopped':
            print('already stopped')
        elif status == 'running':
            self.ec2.stop_instances(
                InstanceIds=[
                    instance['InstanceId'],
                ]
            )
        else:
            print('instance in transient state')

    def stop_instance():
        instance = self.get_instance_status()
        status = instance['State']['Name']
        if status == 'running':
            print('already running')
        elif status == 'stopped':
            self.ec2.start_instances(
                InstanceIds=[
                    instance['InstanceId'],
                ]
            )
        else:
            print('instance in transient state')

    def check_for_players():
        pass

    def get_instance_status():
        response = self.ec2.describe_instances(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values': ['Minecrap']
                }
            ]
        )
        eligible = []
        rsvp = response['Reservations']
        if rsvp:
            for reservation in rsvp:
                instances = reservation['Instances']
                if instances:
                    for instance in instances:
                        eligible.append(instance)
        latest_launch = max([d['LaunchTime'] for d in eligible])
        latest = None
        for instance in eligible:
            if latest_launch == instance['LaunchTime']:
                latest = instance
        if latest:
            return latest
        else:
            print('no instances found?')


def lambda_handler(event, context):
    api = API()
