__author__ = 'justusadam'

from ecgvectorfunctions import scal
import vector


def step(points,t):
    return [vector.add(scal(1 - t, points[i]), scal(t, points[i + 1])) for i in range(len(points) - 1)]

    
def full(points,t):
    for i in range(len(points)-1):
        points = step(points,t)
        print(points)
    return points

def main():
    points = [(1,1),(2,0),(3,-1),(4,3),(5,2)]
    t = 0.3


    full(points,t)

if __name__ == '__main__':
    main();