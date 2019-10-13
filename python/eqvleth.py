# Generate meshtal file with spectrum uniform in lethargy. The 1/E distribution
# is uniform in lethargy. For a given energy grid structure Ei, the probability
# to hit the -th energy interval is proportional to ln(Ei+1/Ei). In meshtal
# values are not normalized to energy interval, thus, simply put probability.
#
# The 1/E diverges at E->0, thus one needs to define the lower energy boundary
# for the lethargy-uniform distribution. There are two values with this
# repsect: (1) the lowest energy mentioned in the VITAMIN-J structure is 1e-5
# eV and (2) the boundary between the slowing-down 1/E and maxwellian thermal
# spectra is 0.414 eV.

# Problem when comparing: MCNP meshtall always assumems that the 1st entry is
# 0. Therefore, all spectra passed from MCNP to grpconversion has a non-zero
# tail. When passed without grp convert, FISPACT assumes the last group flux as
# in the group from 1e-5 eV. Thus, there should be a requirement to the flux
# spectrum passed to FISPACT: its lowest energy group must be from 0 to 1e-5 eV
# and be zero.
#
# When spectrum is prepared for the grpconvert, one needs to explicitly
# describe the last group from 0 to 1e-5 and set the flux in this grpu to 0.

# As given on Table on p.187 of FISPACT manual, the cross-section weighting
# spectrum is defined on four energy intervals:
#   1e-5  -- 0.414 eV  Maxwellian, T = 0.0253 eV
#   0.414 -- 12.52 eV  1/E
#   12.52 -- 15.68 eV  Velocity exp. fusion peak, Ef=14.07, kTf=0.025 eV
#   15.68 -- 19.64 eV  1/E

import numpy as np
from meshgen import Rect
from vitaminj import vj


def fusion_spectrum(el):
    """
    Probabilities of the energy intervals given by el, that correspond to the
    weighting spectrum used for EAF data in VITAMIN-J.
    """
    b = np.array((-1, 1e-5, 0.414, 12.52, 15.68, 19.64))
    e = np.array(el)
    epart = ()
    for bmin, bmax in zip(b[:-1], b[1:]):
        epart += e[(bmin < e) & (e <= bmax)]



    for i in range(1, b.shape[0]):
        emin = max(

    def maxwell(e1, e2):
        return 0

    def E1(e1, e2):
        return np.log(e2/e1)

    def fuspeak(e1, e2):
        return 0

    def compound(e1, e2):
        assert e1 <= e2
        b = (1e-5, 0.414, 12.52, 15.68, 19.64)
        if e2 < b[0] or e1 > b[-1]:
            return 0
        elif b[0] <= e1 and e2 <= b[1]:
            return maxwell(e1, e2)
        elif


def uleth(el):
    """
    Return list (array) of the interval probabilities for the given energy
    boundaries.
    The 1st entry in el must be 0. The probability of this group is computed
    as if the group boundariws were (1e-11, E1).
    """
    e = np.array(el)
    assert e[0] == 0
    e[0] = 1e-11 if 1e-11 < el[1] else el[1]
    dleth = np.zeros((e.shape[0], 2), dtype=float)
    dleth[:-1, 0] = np.log(e[1:] / e[:-1])
    dleth[-1, 0] = dleth[:-1, 0].sum()
    dleth[:, 1] = 0.1
    dleth[-1, 1] = 0.001
    return dleth


def uerg(el):
    """
    See uleth, but uniform in energy scale.
    """
    e = np.array(el)
    d = np.zeros((e.shape[0], 2), dtype=float)
    d[:-1, 0] = e[1:] - e[:-1]
    d[-1, 0] = d[:-1, 0].sum()
    d[:, 1] = 0.1
    d[-1, 1] = 0.001
    return d


if __name__ == '__main__':
    print('vitamin', tuple(vj))

    eld = {}
    for n in (1, 3, 5, 9, 17, 101, 201, 301, 401, 999):
        k = 'ln{:03d}'.format(n)
        eld[k] = (0, 1e-11, vj[-1]) + tuple(np.logspace(-7, 1, n))

    eld['vj0'] = (0, 1e-11) + tuple(vj)
    eld['vj'] = (0, ) + tuple(vj)

    for n in (1, 3, 5, 9, 17, 101, 201, 301, 401, 999):
        k = 'li{:03d}'.format(n)
        eld[k] = (1e-11, ) + tuple(np.linspace(0, vj[-1], n))

    x = (-1, 1)
    m = Rect(x, x, x)
    m.v[:, :, :, :, :] = (1.0, 1e-4)
    m.savefile('meshtal_fine')
    for i, el in eld.items():
        el = sorted(el)
        print(i, el[:5])
        m = Rect(x, x, x, el)
        m.v[0, 0, 0, :, :] = uleth(el)
        m.savefile('{}.leth'.format(i))
        m.v[0, 0, 0, :, :] = uerg(el)
        m.savefile('{}.linE'.format(i))
