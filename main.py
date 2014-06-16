p = [-0.5, 0.2, 0.1]
q = [0.9, -0.3, 0]
r = [0.7, 0.4, -0.1]
x = [0.48, 0.29, -0.05]
u = 0.2
v = 0.5

from ecgvectorfunctions import *
import math


def main():
    for i in [(p, q), (q, r), (r, p)]:
        print(betr(side(proj(x, side(i[1], i[0])), scal(-1, i[0]))))
    s = [math.cos(u) * (v ** 3), (u - v) ** 2, 20 ** (-((u ** 2) + (v ** 2) / 9))]
    print(s)

if __name__ == '__main__':
    main();