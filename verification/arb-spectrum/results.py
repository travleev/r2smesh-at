# Compare cgi files on the heat map.

# Reference calculation no.vj. Cycle over all other solutions and
# generate heat maps in the system (gamma energy group, time).

import numpy as np
import matplotlib.pyplot as plt


def get_cgi(fname):
    """
    Read cgi file into a numpy file
    """
    r = np.loadtxt(fname, comments='_')  # , usecols=(4, 5, 6, 7, 8))
    return r[:, 4:]


if __name__ == '__main__':
    from sys import argv
    ref = get_cgi(argv[1])
    r2 = (ref**2).sum()
    print(ref.shape)
    for cgi in argv[2:]:
        r = get_cgi(cgi)
        d = r - ref
        f, a = plt.subplots(ncols=1, nrows=1)
        img = a.imshow(d, aspect=1, interpolation='none')
        f.colorbar(img)  # add colorbar to the pic
        pdfname = cgi.split('/')[0].replace('.', '_') + '.pdf'
        f.savefig(pdfname)

        print('{:40s}{:13.5e}'.format(cgi, (d**2).sum() / r2))
