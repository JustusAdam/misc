__author__ = 'justusadam'

import vector


class Matrix:
    def __init__(self, matrix=None):
        self.matrix = matrix

    def __getitem__(self, item):
        return self.matrix[item]


def cols(matrix, end, start=0):
    return [i[start:end] for i in matrix]


class Gauss:
    _matrix = None

    l_matrix = None
    r_matrix = None

    inversion_remainder = None
    inverted = None

    def __init__(self, matrix=None):
        if matrix:
            self._matrix = matrix
            self.create_lr_matrix()
            self.invert_lr_matrices()

    def matrix(self, matrix):
        self._matrix = matrix
        self.create_lr_matrix()
        self.invert_lr_matrices()

    def lr_matrix(self, matrix):
        self._matrix = matrix
        self.create_lr_matrix()

    def lr_set_matrices(self, r_matrix, l_matrix):
        self.l_matrix = l_matrix
        self.r_matrix = r_matrix
        self.invert_lr_matrices()

    def create_lr_matrix(self):
        """
    create the left and right gaussian matrix
        :param input_matrix: list of rows (lists of numbers)
        :return: dictionary with the keys "l_matrix" and "r_matrix" and the matrices (list of rows) as values
        """
        input_matrix = self._matrix
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

        self.l_matrix = l_matrix
        self.r_matrix = input_matrix

    def invert_lr_matrices(self):
        """
    Second part of the gaussian l-r-matrix inversion
        :param l_matrix: list of lists of numerical values
        :param r_matrix: list of lists of numerical values
        """
        if not self.l_matrix or not self.r_matrix:
            self.create_lr_matrix()

        r_matrix = self.r_matrix
        l_matrix = self.l_matrix

        for i in range(len(r_matrix) - 1, -1, -1):
            print(i)
            for remaining_rows in range(i):
                l_matrix[remaining_rows][i] -= r_matrix[remaining_rows][i]
                r_matrix[remaining_rows][i] = 0

        self.inverted = l_matrix
        self.inversion_remainder = r_matrix


def rows_to_columns(input_matrix):
    """
Turn matrix row into columns
    :param input_matrix: list of lists of numerical values of consistent length
    :return:
    """
    return [[input_matrix[p][i] for p in range(len(input_matrix))] for i in range(len(input_matrix[0]))]


def create_standard(i):
    """
create a standard matrix where all entries except the diagonal are 0, diagonals are 1
    :param i: number of rows and columns
    :return: list of lists of numerical values
    """
    output_matrix = [[0 for j in range(i)] for b in range(i)]
    for a in range(i):
        output_matrix[a][a] = 1
    return output_matrix


def print_matrix(matrix):
    for i in matrix:
        print(i)


def main():
    matrix = [
        (1, 0, 0),
        (-10, 2, 0),
        (3, 4, 3)
    ]
    # gauss = Gauss(matrix)
    # print(gauss.inverted)
    # print(gauss.r_matrix)
    # print(gauss.l_matrix)
    # print(gauss.inversion_remainder)
    gauss2 = Gauss(matrix)

    print_matrix(gauss2.inverted)
    print('\n')
    print_matrix(gauss2.inversion_remainder)


if __name__ == '__main__':
    main()