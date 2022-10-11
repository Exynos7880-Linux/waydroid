#!/usr/bin/env python3
import json
import sys

img = sys.argv[1]
arch = sys.argv[2]

if (img == "system"):

    with open('waydroid_OTA/system/lineage/waydroid_%s/VANILLA.json' % arch) as json_file:
        data = json.load(json_file)

        for p in data['response']:
            last=p
            break

        print(last["url"])

elif (img == "vendor"):

    if (arch == 'x86_64'):
        halium_ver = "MAINLINE"
    else:
        halium_ver = sys.argv[3]

    with open('waydroid_OTA/vendor/waydroid_%s/%s.json' % (arch, halium_ver)) as json_file:
        data = json.load(json_file)

        for p in data['response']:
            last=p
            break

        print(last["url"])
