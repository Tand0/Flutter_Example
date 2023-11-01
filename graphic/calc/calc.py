#!/usr/bin/ptyhon
"""this is LeastSquares sample"""
import numpy as np
import matplotlib.pyplot as plt


class LeastSquares():
    """Calc"""

    b = []

    def do(self, x, y, m):
        """calc least squares"""
        s = []
        for j in range(2 * m + 1):
            w = 0.0
            for i in x:
                w += pow(i, j)
            s.append(w)
        t = []
        for j in range(m + 1):
            w = 0.0
            for i, x_one in enumerate(x):
                w += pow(x_one, j) * y[i]
            t.append(w)
        a = []
        for i, t_one in enumerate(t):
            aa = []
            a.append(aa)
            for j in range(len(t)):
                aa.append(s[i + j])
            aa.append(t_one)
        for k in range(len(t)):
            p = a[k][k]
            for j in range(len(t) + 1):
                a[k][j] /= p
            for i in range(len(t)):
                if (i != k):
                    d = a[i][k]
                    for j in range(k, len(t) + 1):
                        a[i][j] -= d * a[k][j]
        self.b = []
        for k, a_one in enumerate(a):
            self.b.append(a_one[len(a_one) - 1])

    def retrun_x_to_y(self, px):
        """return py"""
        py = 0
        for k, b_one in enumerate(self.b):
            py += b_one * pow(px, k)
        return py


def main():
    """main"""
    x = [-3 + 10, -2 + 10, -1 + 10, 0 + 10, 1 + 10, 2 + 10, 3 + 10]
    y = [5 + 10, -2 + 10, -3 + 10, -1 + 10, 1 + 10, 4 + 10, 5 + 10]
    obj = LeastSquares()
    x_min = x[0]
    x_max = x[len(x) - 1]
    x_step = (x_max - x_min) / 100
    for m in range(1, 5):
        obj.do(x, y, m)
        px = x_min
        x_list = []
        y_list = []
        while (px <= x_max):
            x_list.append(px)
            p = obj.retrun_x_to_y(px)
            y_list.append(p)
            px += x_step
        x_b = np.array(x_list)
        y_b = np.array(y_list)
        plt.plot(x_b, y_b, label="m=" + str(m))
    #
    plt.legend()
    for i, x_one in enumerate(x):
        plt.scatter(x_one, y[i], s=5, marker="o")
    plt.show()


if __name__ == "__main__":
    main()

#
