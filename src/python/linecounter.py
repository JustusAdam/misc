"""
Command line tool and library for counting non-empty lines in text files.

If invoked with a directory name, will recursively scan subdirectories and scan all files contained within.
"""


import pathlib
import re


__author__ = 'Justus Adam'
__version__ = '0.1'


empty_line = re.compile('^\s*$')


def count_lines(lines):
    line_count = 0
    for line in lines:
        if not re.match(empty_line, line):
            line_count += 1
    return line_count


def count_file(file):
    with file.open() as file:
        return count_lines(file.readlines())


def count(directory, recursive=True, file_endings={'.py'}):
    directory = pathlib.Path(directory)

    if not directory.is_dir() and directory.suffix in file_endings:
        return count_file(directory)

    line_count = 0

    for file in directory.iterdir():
        if file.is_dir() and recursive:
            line_count += count(file, fileendings=file_endings, recursive=True)
        elif file.suffix in file_endings:
            line_count += count_file(file)

    return line_count


def count_with_highest(directory, recursive=True, file_endings={'.py'}, skip=set()):
    if not isinstance(directory, pathlib.Path):
        directory = pathlib.Path(directory)

    if not directory.is_dir() and directory.suffix in file_endings:
        a = count_file(directory)
        return a, a

    def check_skipped(file):
        for skipped in skip:
            if skipped in str(file):
                return False
        else:
            return True

    filecount = 0

    line_count = 0

    highest = (0, None)

    dir_count = 0

    for file in directory.iterdir():
        if not check_skipped(file):
            continue
        elif file.is_dir() and recursive:
            fline_count, file_highest, sfile_count, fdir_count = count_with_highest(file, recursive, file_endings, skip)
            line_count += fline_count
            filecount += sfile_count
            dir_count += 1 + fdir_count
            if file_highest[0] > highest[0]:
                highest = file_highest
        elif file.suffix in file_endings:
            b = count_file(file)
            filecount += 1
            line_count += b
            if b > highest[0]:
                highest = (b, str(file))

    return line_count, highest, filecount, dir_count


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('scanpath', type=str)
    parser.add_argument('--fileendings', type=str, default='.py')
    parser.add_argument('--recursive', type=bool, default=True)
    parser.add_argument('--skip_dir', type=str, default=None)

    args = parser.parse_args()

    fileendings = set(args.fileendings.split(','))
    skip_dir = set(args.skip_dir.split(',')) if args.skip_dir else set()

    s = """
showing lines for files ending with {fileendings}

accumulative count:
{lines} non-empty lines
in {files} files
in {directories} directories

most lines in single file: {highest}
found in file {largest_file}
"""
    count, highest, filecount, dir_count = count_with_highest(
        args.scanpath, args.recursive, fileendings, skip_dir)

    print(s.format(
        fileendings=fileendings,
        lines=count,
        files=filecount,
        directories=dir_count,
        highest=highest[0],
        largest_file=highest[1])
        )
