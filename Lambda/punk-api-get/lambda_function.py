import requests
import boto3

client = boto3.client('kinesis')
apiURL = "https://api.punkapi.com/v2/beers/random"

def lambda_handler(event, context):
    r = requests.get(url=apiURL)
    data = r.text

    client.put_record(
        StreamName='data-stream',
        Data=data,
        PartitionKey='1'
    )

    return {
        'successMessageSent' : data
    }