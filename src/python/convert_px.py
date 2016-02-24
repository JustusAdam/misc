from math import ceil
from sys import argv
import re

def px_to_percent(value,base):
    return ceil(float(value)/base * 100)

def search_and_replace(a):
    while(1):
        m = re.search('(width|left|right)(\s*:\s*)(\d\d+)(\s*px)',a)
        if m == None:
            break
        print(m.group(0))
        a = a.replace(m.group(0), (m.group(1) + m.group(2) + str(px_to_percent(int(m.group(3)),805)) + '%'))
    while(1):
        m = re.search('(height|top|bottom)(\s*:\s*)(\d\d+)(\s*px)',a)
        if m == None:
            return a
        print(m.group(0))
        a = a.replace(m.group(0), (m.group(1) + m.group(2) + str(px_to_percent(int(m.group(3)),341)) + '%'))

def main(filename):
    file_wrapper = open(filename,'r+')
    file_content_string = file_wrapper.read()
    file_wrapper = open(filename,'w')
    file_wrapper.write(search_and_replace(file_content_string))

if __name__ == '__main__':
    main(argv[1])