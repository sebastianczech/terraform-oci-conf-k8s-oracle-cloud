import sys
import json

input = sys.stdin.read()
input_json = json.loads(input)

output = {
    "public_ip_of_joined_node": input_json["worker_public_ip"] if "worker_public_ip" in input_json else "undefined"
}
output_json = json.dumps(output,indent=2)
print(output_json)
