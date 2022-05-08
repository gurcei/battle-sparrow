import os

x = 0
y = 21
w = 4
h = 3

skip = x + 80*y

print("chars")
for r in range(h):
    os.system("hexdump -v --skip {} --length {} -e '\"$%04_ax: \"' -e '{}/1 \"%d, \"' -e '\"\\n\"' draft.bin'".format(skip, w, w))
    skip = skip + 80

skip = x + 80*y

print("colour")
for r in range(h):
    os.system("hexdump -v --skip {} --length {} -e '\"$%04_ax: \"' -e '{}/1 \"%d, \"' -e '\"\\n\"' draft.clr'".format(skip, w, w))
    skip = skip + 80
