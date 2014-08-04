w_in = (-0.901, -0.357, 0.25)
l_in = (0.61, 0.8, 0.28)
w_out = (0.267, 0.251, 0.93)
n = (-0.531, 0.172, 0.83)
r_diff = (0.56, 0.46, 0.53)
r_spec = (0.44, 0.54, 0.47)
m = 68
d = (0.8, -1.2, -3.2)

from vector import *


def main():

    print(scale(float(2) / length([0.8, -1.2]), d))

    if dot_product(w_in, n) > 0:
        v = 1
    else:
        v = 0

    w_refl = [w_in[i] - scale(2.0 * dot_product(n, w_in), n)[i] for i in range(len(w_in))]

    w_half = scale(float(1) / dot_product(add(w_in, w_out)), add(w_in, w_out))

    for kind in [dot_product(w_out, w_refl) ** m, dot_product(w_half, n) ** m]:
        print(add([r_diff[i] * scale(dot_product(w_in, n), l_in)[i] for i in range(len(r_diff))],
                  scale(v, [r_spec[i] * scale(kind, l_in)[i] for i in range(len(r_spec))])))


if __name__ == '__main__':
    main()