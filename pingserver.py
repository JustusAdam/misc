import time
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
