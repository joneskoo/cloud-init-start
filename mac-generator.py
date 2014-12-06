#!/usr/bin/env python

import json
import os.path
import sys

class JsonDatabase():

    def __init__(self, filename):
        self._filename = filename
        self.data = {}

    def __enter__(self):
        try:
            with open(self._filename, 'rb') as f:
                self.data = json.load(f)
                self.data['sequence'] = self.data.get('sequence', 0)
                self.data['hosts'] = self.data.get('hosts', {})
        except (IOError, ValueError):
            pass
        return self.data

    def __exit__(self, exc_type, exc_value, traceback):
        with open(self._filename, 'wb') as f:
            json.dump(self.data, f)

def main():
    if len(sys.argv) != 2:
        raise SystemExit("Usage: mac-generator hostname")
    hostname = sys.argv[1]
    with JsonDatabase('mac-db.json') as db:
        cached_mac = db['hosts'].get(hostname)
        if cached_mac:
            mac =cached_mac
        else:
            mac = "52:54:00:13:37:{cur:02x}".format(cur=db['sequence']+0x20)
            db['hosts'][hostname] = mac
            db['sequence'] += 1
        print(mac)

if __name__ == '__main__':
    main()

