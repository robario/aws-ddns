# NAME

awsddns - Dynamic DNS for AWS

# DESCRIPTION

`awsddns` which is installed as a service upserts specified records into Route53 at startup and deletes it at halt.

# USAGE

## CloudFormation template

```yaml
Resources:
  Bastion:
    Type: AWS::EC2::Instance
    Metadata:
      RecordSetGroups:
        - HostedZoneId: !Ref ExampleComHostedZone
          RecordSets:
            - {Name: bastion.example.com., TTL: 600, Type: A, ResourceRecords: ['$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)']}
    UserData: !Base64 |+
      #cloud-config
      runcmd:
        - curl --silent https://raw.githubusercontent.com/robario/awsddns/master/install.sh | bash -s
```

## Required Policies for the instance

- ec2:DescribeInstances
- route53:ChangeResourceRecordSets

```yaml
Resources:
  AWSDDNSManagedPolicy:
    Type: AWS::IAM::ManagedPolicy
    Properties:
      PolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Action: ec2:DescribeInstances
            Resource: '*'
          - Effect: Allow
            Action: route53:ChangeResourceRecordSets
            Resource:
              - arn:aws:route53:::hostedzone/Z23ABC4XYZL05B # !Ref myHostedZone
  myRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Action: sts:AssumeRole
            Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
      ManagedPolicyArns:
        - !Ref AWSDDNSManagedPolicy
```

# ADVANCED

- `RecordSetGroups` can contain shell script such as Command Substitution, Arithmetic Expansion, and so on.
