from gpu.host import DeviceContext
from sys import has_accelerator

def main():
  @parameter
  if not has_accelerator():
    print("No compatible GPU found.")
  else:
    ctx = DeviceContext()
    print("GPU found: " + ctx.name())

  print()

  var name: String = input("Who are you? ")
  var greeting: String = "Hi, " + name + "!"
  print(greeting)

