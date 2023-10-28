import yaml
import json

with open('openapi.json') as file:
    obj = json.load(file)
    ym = yaml.dump(obj, Dumper=yaml.CDumper)
    print(ym)
