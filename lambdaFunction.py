import json

def lambda_handler(event,context):
    print(event)
    text='Hello from Lambda!'
    print(text)
    return_message= {
        'statusCode': 200,
        'body': json.dumps(text)
    }

    return return_message