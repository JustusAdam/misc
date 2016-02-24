from os.path import getsize, isfile, isdir
from os import listdir


def sizedir(*paths):
    return sum(_size(path) for path in paths)

def _size(path):
    if isdir(path):
        return getsize(path) + sum(_size(path + '/' + a) for a in listdir(path))
    else:
        return getsize(path)
