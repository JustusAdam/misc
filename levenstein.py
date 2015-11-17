#!/usr/bin/env python3

def lev(a, b):
    matrix = [
        [ax+bx for bx in range(len(b)+1)]
        for ax in range(len(a)+1)
    ]

    for row in range(1,len(matrix)):
        for col in range(1,len(matrix[row])):
            if a[row-1] == b[col-1]:
                matrix[row][col] = matrix[row-1][col-1]
            else:
                matrix[row][col] = min(matrix[row][col-1], matrix[row-1][col], matrix[row-1][col-1]) + 1

    # for row in matrix:
    #     print(row)

    return matrix[-1][-1]


if __name__ == "__main__":
    import sys
    _, a, b = sys.argv
    print(lev(a,b))
