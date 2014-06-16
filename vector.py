__author__ = 'justusadam'


def add(vec1,vec2):
    return [vec1[i] + vec2[i] for i in range(len(vec1))]

def scale(skalar,vector):
    '''
    Gibt skalierten Vektor vector mit skalar zurueck
    '''
    return [vector[i] * skalar for i in range(len(vector))]