vals = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,150,0,0,0,0,0,0,0,0,0,0]

for i in range(len(vals)):
  vals[i] = int(input("Enter Byte in Hex: "), 16)

check = 0
for i in vals:
  check = check + i

check = check + 25
check = 65536 - check
check = check & 255

print(check, hex(check))

input("Press Enter to Exit\n")
