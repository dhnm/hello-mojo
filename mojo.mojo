from python import Python

def main():
  json = Python.import_module("json")
  data = json.loads(r'{"name": "Mojo", "version": 1.0}')

  print(data["name"])
  print(data["version"])
