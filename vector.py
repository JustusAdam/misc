__author__ = 'justusadam'


def add(vector1,vector2):
    """
Calculate the sum of vector1 and vector 2
    :param vector1: list of numerical values
    :param vector2: list of numerical values
    :return:
    """
    return [vector1[i] + vector2[i] for i in range(len(vector1))]


def scale(scalar, vector):
    """
Scale vector by scalar
    :param scalar: numerical value
    :param vector: list of numerical values
    :return:
    """
    return [vector[i] * scalar for i in range(len(vector))]


def length(vector):
    """
Calculate the length of vector
    :param vector: list of numerical values
    :return: numerical value
    """
    from math import sqrt
    return sqrt(dot_product(vector))


def norm(vector):
    """
Norms vector to have length 1
    :param vector: list of numerical values
    :return: list of numerical values
    """
    return scale(1 / length(vector), vector)


def dot_product(v1, v2=None):
    """
Calculate dot product of two vectors
    :param v1: list of numerical values
    :param v2: list of numerical values
    :return:
    """
    if not v2:
        v2 = v1
    result = 0
    for i in range(len(v1)):
        result += v1[i] * v2[i]
    return result


def cartesian_product(vectors):
    """
Calculate the cartesian product of vectors
    :param vectors: list of vectors (lists of numerical values)
    :return: list of numerical values
    """
    from ecgvectorfunctions import determinant
    from matrix import rows_to_columns

    vectors = rows_to_columns(vectors)
    return [determinant(vectors[:i] + vectors[i + 1:]) for i in range(len(vectors))]


def subtract(vector1, vector2):
    """
Subtract vector2 from vector1
    :param vector1: list of numerical values
    :param vector2: list of numerical values
    :return: list of numerical values
    """
    return add(vector1, scale(-1, vector2))


def triple_product(v1, v2, v3):
    """
Calculate the triple product of three vectors
    :param v1: list of numerical values
    :param v2: list of numerical values
    :param v3: list of numerical values
    :return: product
    """
    return dot_product(v1, cartesian_product([v2, v3]))


def project(vector1, vector2):
    """
Calculate projection of vector1 onto vector2
    :param vector1: list of numerical values
    :param vector2: list of numerical values
    :return: list of numerical values
    """
    norm_v = norm(vector2)
    return scale(dot_product(vector1, norm_v), norm_v)