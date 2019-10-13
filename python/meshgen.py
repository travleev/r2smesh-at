# Meshtal generator. To provide example meshtals for verification calculaitons

# What is needed first:
# (1) Meshtal for arbitrary spectrum. A mesh with single spatial element, with
# arbitrary energy group structure and with 1/E flux distribution (to provide
# constant probability per lethargy).
#
# (2) Meshtal for different spatial nodalization that describe the same spatial
# flux intensity distribution. This is to check that arbitrary spatial
# nodalization works properly.


import numpy as np


meshtalheader = """Mesh Tally Number         4
 This is a neutron mesh tally.

 Tally bin boundaries:
    X direction:{}
    Y direction:{}
    Z direction:{}
    Energy bin boundaries:{}

{}
"""
valheader1 = '        X         Y         Z     Result     Rel Error'
valheader2 = '   Energy         X         Y         Z     Result     Rel Error'


class Rect(object):

    def __init__(self, xlst, ylst, zlst, elst=(0, 1e36), number=4):
        """
        Rectangular mesh.
        """
        self.__x = np.array(xlst)
        self.__y = np.array(ylst)
        self.__z = np.array(zlst)
        self.__e = np.array(elst)
        self.number = number

        self.v = np.zeros((self.__x.shape[0] - 1,
                           self.__y.shape[0] - 1,
                           self.__z.shape[0] - 1,
                           self.__e.shape[0], 2), dtype=float)
        return

    def _xyztab(self, ie):
        """
        Yield lines "x, y, z v, e" for the given energy index ie.
        """
        for ix in range(self.v.shape[0]):
            x = self.__x[ix:ix+2].mean()
            xs = ' {:10.3f}'.format(x)
            for iy in range(self.v.shape[1]):
                y = self.__y[iy:iy + 2].mean()
                ys = '{:10.3f}'.format(y)
                for iz in range(self.v.shape[2]):
                    z = self.__z[iz:iz + 2].mean()
                    zs = '{:10.3f}'.format(z)
                    zs += '{:12.5e}'.format(self.v[ix, iy, iz, ie, 0])
                    zs += '{:12.5e}'.format(self.v[ix, iy, iz, ie, 1])
                    yield xs + ys + zs + '\n'

    def savefile(self, fname):
        """
        Save mesh tally to the meshtal MCNP format.
        """
        f = open(fname, 'w')
        xl = map('{:10.2f}'.format, self.__x)
        yl = map('{:10.2f}'.format, self.__y)
        zl = map('{:10.2f}'.format, self.__z)
        el = map('{:13.5E}'.format, self.__e)
        xl = ''.join(xl)
        yl = ''.join(yl)
        zl = ''.join(zl)
        el = ''.join(el)

        if self.__e.shape[0] > 2:
            vh = valheader2
        else:
            vh = valheader1
        h = meshtalheader.format(xl, yl, zl, el, vh)
        f.write(h)

        if self.__e.shape[0] == 2:
            for l in self._xyztab(0):
                f.write(l)
        else:
            for ie in range(1, self.__e.shape[0]):
                s = '{:11.3e}'.format(self.__e[ie])
                for l in self._xyztab(ie - 1):
                    f.write(s + l)
            s = '   Total   '
            for l in self._xyztab(-1):
                f.write(s + l)
        f.close()
        return


if __name__ == '__main__':
    xb = np.linspace(-15.0, 15.0, 21)
    yb = np.linspace(-15.0, 15.0, 11)
    zb = np.linspace(-15.0, 15.0, 11)
    m = Rect(xb, yb, zb)
    m.number = 4
    m.savefile('zero.meshtal')

    eb = np.array((0, 1e-7, 1e-5, 1, 20))
    m = Rect(xb, yb, zb, eb)
    m.number = 4
    m.savefile('zero.meshtal.egrid')
