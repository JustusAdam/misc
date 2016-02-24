import time
import sys
import threading
from datetime import datetime
from urllib import request
from urllib.error import URLError

def ping(url, timeout=30):
    searching = True
    while(searching):
        try:
            document = request.urlopen(url)
            print('server returned', document.read().decode())
            searching = False
        except URLError as error:
            print('still waiting', error)
            time.sleep(timeout)


def test(page, n, l=100):
    a = []
    for i in range(n):
        b = datetime.now()
        for s in range(l):
            request.urlopen(page)
        a.append(datetime.now() - b)
        print(a[-1])
    return sum(q.total_seconds() for q in a) / len(a)


def main():
    if len(sys.argv) == 2:
        url, timeout = sys.argv[1], 30
    elif len(sys.argv) == 3:
        url, timeout = sys.argv[1:3]
        timeout = int(timeout)
    else:
        print(len(sys.argv))
        print(sys.argv)
        raise ValueError('Wrong number of command line arguments')

    t1 = threading.Thread(target=ping, args=(url, timeout))

    t1.start()


if __name__ == '__main__':
    main()
