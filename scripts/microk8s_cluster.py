import sys
import json
import os

input = sys.stdin.read()
input_json = json.loads(input)

os.system('echo \"{}\" > key.pem'.format(input_json["private_key"]))
os.system('chmod 600 key.pem')
result = os.popen('ssh -o \"StrictHostKeyChecking=no\" -i key.pem ubuntu@{} microk8s config'.format(input_json["master_public_ip"])).read()
os.system('rm key.pem')

output = {
    "configuration": result
}
output_json = json.dumps(output,indent=2)
print(output_json)
