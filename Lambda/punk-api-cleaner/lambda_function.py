import json
import base64

print('Loading function')


def lambda_handler(event, context):
    output = []
    finaldata = {'id': ''}
    fields = ['id', 'name', 'tagline', 'first_brewed', 'description']
    print(type(finaldata))

    for record in event['records']:
        print(record['recordId'])
        payload = base64.b64decode(record['data'])
        print('payload:', payload)
        jsondata = json.loads(payload)[0]
        for key, value in jsondata.items():
            for field in fields:
                if key == field:
                    package = {key: value}
                    finaldata.update(package)

        print('Processed data:', finaldata)
        data = str(finaldata).encode('utf-8')

        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': base64.b64encode(data).decode()
        }
        output.append(output_record)

    print('Successfully processed {} records.'.format(len(event['records'])))

    return {'records': output}
