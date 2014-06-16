__author__ = 'justusadam'

import vector


def lr_gaussian_matrix(input_matrix):
    """
create the left and right gaussian matrix
    :param input_matrix: list of rows (lists of numbers)
    :return: dictionary with the keys "l_matrix" and "r_matrix" and the matrices (list of rows) as values
    """
    l_matrix = create_standard(len(input_matrix))
    for i in range(len(input_matrix)):
        divisor = float(1) / input_matrix[i][i]
        input_matrix[i] = [divisor * j for j in input_matrix[i]]
        l_matrix[i][i] *= divisor
        for remaining_rows in range(i + 1, len(input_matrix)):
            scalar = float(input_matrix[remaining_rows][i]) / input_matrix[i][i]
            input_matrix[remaining_rows] = \
                vector.subtract(input_matrix[remaining_rows], vector.scale(scalar, input_matrix[i]))
            l_matrix[remaining_rows][i] -= scalar
    return {"r_matrix": input_matrix, "l_matrix" : l_matrix}


def matrix_rows_to_columns(input_matrix):
    """
Turn matrix row into columns
    :param input_matrix: list of lists of consistent length
    :return:
    """
    return [[input_matrix[p][i] for p in range(len(input_matrix))] for i in range(len(input_matrix[0]))]


def create_standard(i):
    """
create a standard matrix where all entries except the diagonal are 0, diagonals are 1
    :param i: number of rows and columns
    :return: list of lists
    """
    output_matrix = [[0 for j in range(i)] for b in range(i)]
    for a in range(i):
        output_matrix[a][a] = 1
    return output_matrix


def main():
    matrix = [
        (1, 5, 7),
        (3, 4, 2),
        (7, 3, 1)
    ]
    matrices = lr_gaussian_matrix(matrix)
    print(matrices.get("r_matrix"))
    print(matrices.get("l_matrix"))


if __name__ == '__main__':
    main();