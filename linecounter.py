import pathlib
import re

__author__ = 'justusadam'


empty_line = re.compile('^\s*$')


def count_lines(lines):
    line_count = 0
    for line in lines:
        if not re.fullmatch(empty_line, line):
            line_count += 1
    return line_count


def count_file(file):
    with file.open() as file:
        return count_lines(file.readlines())


def count(directory, recursive=True, fileendings={'.py'}):
    directory = pathlib.Path(directory)

    if not directory.is_dir() and directory.suffix in fileendings:
        return count_file(directory)

    line_count = 0

    for file in directory.iterdir():
        if file.is_dir() and recursive:
            line_count += count(file)
        elif file.suffix in fileendings:
            line_count += count_file(file)

    return line_count


if __name__ == '__main__':
    import sys
    print(count(sys.argv[1]))