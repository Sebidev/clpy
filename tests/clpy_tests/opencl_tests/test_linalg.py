# -*- coding: utf-8 -*-

import unittest

import clpy
import numpy


class TestProduct(unittest.TestCase):
    """test class of linalg"""

    def test_vdot(self):
        npA = numpy.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]], dtype='float32')
        npB = numpy.array([[1, 2, 3], [7, 8, 9], [4, 5, 6]], dtype='float32')
        expectedC = numpy.vdot(npA, npB)

        clpA = clpy.array(npA)
        clpB = clpy.array(npB)
        actualC = clpy.vdot(clpA, clpB)

        self.assertTrue(numpy.allclose(expectedC, actualC.get()))

    def test_dot(self):
        npA = numpy.array([1, 2, 3], dtype='float32')
        npB = numpy.array([1, 2, 3], dtype='float32')
        expectedC = numpy.dot(npA, npB)

        clpA = clpy.array(npA)
        clpB = clpy.array(npB)
        actualC = clpy.dot(clpA, clpB)

        self.assertTrue(numpy.allclose(expectedC, actualC.get()))

    def test_tensordot(self):
        npA = numpy.array([[[1, 2, 3], [4, 5, 6], [7, 8, 9]],
                           [[10, 11, 12], [13, 14, 15], [16, 17, 18]],
                           [[19, 20, 21], [22, 23, 24], [25, 26, 27]]], dtype='float32')
        npB = numpy.array([[[1, 2, 3], [4, 5, 6], [7, 8, 9]],
                           [[10, 11, 12], [13, 14, 15], [16, 17, 18]],
                           [[19, 20, 21], [22, 23, 24], [25, 26, 27]]], dtype='float32')
        expectedC = numpy.tensordot(npA, npB)

        clpA = clpy.array(npA)
        clpB = clpy.array(npB)
        actualC = clpy.tensordot(clpA, clpB)

        self.assertTrue(numpy.allclose(expectedC, actualC.get()))


if __name__ == "__main__":
    unittest.main()
