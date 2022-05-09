import os

x = 24
y = 4
w = 33
h = 17
fl = "sparrow"

skip = x + 80*y

print("chars")
for r in range(h):
    os.system("hexdump -v --skip {} --length {} -e '\"data \"' -e '{}/1 \"%d,\"' -e '\"\\n\"' {}.bin'".format(skip, w, w, fl))
    skip = skip + 80

skip = x + 80*y

print("colour")
for r in range(h):
    os.system("hexdump -v --skip {} --length {} -e '\"data \"' -e '{}/1 \"%d,\"' -e '\"\\n\"' {}.clr'".format(skip, w, w, fl))
    skip = skip + 80
