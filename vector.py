__author__ = 'justusadam'


def add(vec1,vec2):
    return [vec1[i] + vec2[i] for i in range(len(vec1))]


def scale(scalar, vector):
    '''
    Gibt skalierten Vektor vector mit skalar zurueck
    '''
    return [vector[i] * scalar for i in range(len(vector))]


def length(vector):
    '''
    Laenge des Vektors vector
    '''
    from math import sqrt
    return sqrt(dot_product(vector))


def norm(vector):
    return scale(1 / length(vector), vector)


def dot_product(v1, v2=0):
    """
Calculate dot product of two vectors
    :param v1: List of numerical values
    :param v2: List of numerical values
    :return:
    """
    if v2 == 0:
        v2 = v1
    result = 0
    for i in range(len(v1)):
        result += v1[i] * v2[i]
    return result


def cartesian_product(vectors):
    '''
    Berechnet das kartesische Produkt fuer beliebig dimensionierte Vektoren.
    Der Input (vectors) ist eine Liste von Vektoren [v1,v2,v3 ...]
    '''
    from ecgvectorfunctions import determinant
    from matrix import rows_to_columns


    vectors = rows_to_columns(vectors)
    return [determinant(vectors[:i] + vectors[i + 1:]) for i in range(len(vectors))]


def subtract(vec1, vec2):
    return add(vec1, scale(-1, vec2))


def triple_product(v1, v2, v3):
    """
Calculate the triple product of three vectors
    :param v1: vector 1
    :param v2: vector 2
    :param v3: vector 3
    :return: product
    """
    return dot_product(v1, cartesian_product(v2, v3))


def project(vector1, vector2):
    norm_v = norm(vector2)
    return scale(dot_product(vector1, norm_v), norm_v)