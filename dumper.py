import os

x = 30
y = 13
w = 23
h = 1
fl = "text"

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
