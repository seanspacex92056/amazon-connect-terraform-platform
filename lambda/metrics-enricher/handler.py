import json

def lambda_handler(event, context):
    print(json.dumps({"eventType": "CONNECT_EVENT", "payload": event}))
    return {"status": "accepted"}
