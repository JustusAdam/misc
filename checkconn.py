#!/usr/bin/env python3

import subprocess
import io


def main():
    # iolog = io.BytesIO()
    for action, status, message in perform_requests():
        print(
            '%-40s    %-10s    %-30s ' % (action, status, message)
        )


def perform_requests():
    for address, action, error_message in (
        ('localhost', 'Computer internal networking',  'Your computer does not exist?'),
        ('192.168.0.1', 'Router reachability', 'Perhaps it is offline'),
        ('141.30.202.1', 'Wundtstraße switch',
        'The house switch is not reachable, your buildings internet is offline'),
        ('141.30.228.39', 'Primary Wundtstraße DNS','DNS server unreachable'),
        ('141.30.228.4', 'Secondary Wundtstraße DNS', 'DNS server unreachable'),
        ('wh2.tu-dresden.de', 'WH2 DNS resolving', 'DNS resolving is screwed'),
        ('141.30.235.81', 'Weberplatz connection', 'Our gate to the world is closed.'),
        ('8.8.8.8', 'Google\'s DNS', 'ALL THE INTERNET IS GONE FOREVER.'),
        ('google.com', 'Google.com website', 'Big internet DNS resolving does not work')
    ):
        code = perform_request(address)
        if code == 0:
            yield action, 'working', ''
        else:
            yield action, 'error', error_message + '  code: %s' % code

def perform_request(address):
    return subprocess.call(
        ('ping', '-c', '3', address), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )


if __name__ == '__main__':
    main()
