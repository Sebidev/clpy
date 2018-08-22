# ClPy: OpenCL backend for CuPy

*ClPy* is an implementation of [CuPy](https://cupy.chainer.org/)'s OpenCL backend.
In other words, ClPy enables softwares written in CuPy to work also on OpenCL devices, not only on CUDA (NVIDIA) devices.

## Current status

Current ClPy is alpha version, forked from [CuPy v2.1.0](https://github.com/cupy/cupy/releases/tag/v2.1.0).
ClPy is still under development and works on only limited APIs.

* Basic [ndarray](https://docs-cupy.chainer.org/en/stable/reference/ndarray.html) are supported, but not perfectly
* Basic [universal functions](https://docs-cupy.chainer.org/en/stable/reference/ufunc.html) are supported, but not perfectly
* Most of [custom kernels](https://docs-cupy.chainer.org/en/stable/reference/kernel.html) are supported, but some custom kernel codes might be fail to compile and/or run
* Only SGEMM is supported in BLAS library
* Sparse matrix, dnn, rand libraries are not supported
* half and complex are not supported
* Works on only a single device
* No multiple command queue (Stream on CUDA)
* Dockerfile and some other files are just neglected thus don't work well

Original CuPy's tests are not passed perfectly. See current [CuPy's test and example results](https://github.com/fixstars/ClPy/wiki/cupy_test_example_results).

[Chainer](https://chainer.org/) works with limited situation.
Some examples are confirmed to work. See current [Chainer's test and example results](https://github.com/fixstars/ClPy/wiki/chainer_test_example_results).

## Recommended system

We develop and test ClPy in following environments.

* Primary machine
	* OS: Ubuntu 16.04.4 LTS
	* CPU: Core i7-7700
	* GPU: AMD Radeon Vega Frontier Edition (Air Cooled)
	* SDK: amdgpu-pro-18.20
* Secondary machine
	* OS: Ubuntu 16.04.4 LTS
	* CPU: Core i9-7900X
	* GPU: NVIDIA TITAN V
	* SDK: CUDA 9.2

We recommend those environments to all ClPy users. However, reports on other environments are welcome.

## Installation

First, install and setup OpenCL environment.
`cl.h` and OpenCL libs (`libOpenCL.so`) must be able to be included and linked without any special path settings.

For example with AMD APP SDK, you should set following environment variables:

```sh
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:${AMDAPPSDKROOT}/include
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${AMDAPPSDKROOT}/include
export LIBRARY_PATH=${LIBRARY_PATH}:${AMDAPPSDKROOT}/lib/x86_64
```

and add ldconfig on `/etc/ldconf.so.d/` and `$ sudo ldconfig`.

Second, install LLVM/Clang.
Current ClPy requires LLVM/Clang 4.0, 5.0, or 6.0.
We **strongly** recommend that you build LLVM/Clang from the source codes and install it.
However, at least in Ubuntu 16.04, you can use the LLVM/Clang from the Ubuntu official package repository.
In that case, you need to set `PATH` and `CPLUS_INCLUDE_PATH` environment variables like below.

```console
# apt install clang-6.0 libclang-6.0-dev
$ export PATH=/usr/lib/llvm-6.0/bin:$PATH
$ export CPLUS_INCLUDE_PATH=/usr/lib/llvm-6.0/include:$CPLUS_INCLUDE_PATH
```

After OpenCL and LLVM/Clang is successfully installed, install ClPy.

```console
$ pip install cython
$ python setup.py install
```

## How to use

Just replace `cupy` to `clpy` in your python codes and run it (e.g. `import cupy` -> `import clpy`).

You don't need to replace all cuda imports, if you add `import clpy` before `import cupy` in your python codes.
(`import clpy` add import hook. The hook will import clpy when `imoprt cupy` is called.)
If you want to switch clpy and cupy without changing source code,
set `export CLPY_NOT_HOOK_CUPY=1` before execution and disable hook.

Or you don't need to replace any codes, if you run your python code with `-m clpy` option ( e.g. `python -m clpy /path/to/chainer/examples/mnist/train_mnist.py -g0`).


### Woking with Chainer

It's confirmed that ClPy works with [Chainer v3.3.0](https://github.com/chainer/chainer/tree/v3.3.0).

### Tests

```console
$ pip install pytest
$ cd tests/you/want
$ python -m pytest test_you_want.py
```

## Development

1. All source codes (including comments) and commit messages should be written in English.
2. Issues and pull requests are welcome in any languages (recommended in English or Japanese).
3. Detailed coding styles are same as [CuPy's](https://docs-cupy.chainer.org/en/stable/contribution.html#coding-guidelines). Read and follow the guidelines before submitting PRs.

## Future plan

We are developing v0.2.1beta for next release.

* Support Chainer's ImageNet example
* OpenCL version check and auto generated `api.pxd` from `cl.h` in the system
* Map buffer for host memory
* Support all BLAS API
* Improve `cupy` aliasing mechanism
* Update recommended system (Vega and Volta)
* -- and other functions and/or bug fixes that someone develops and/or requests..

We also plan to update CuPy's base version to v4 or v5 after above beta release.

Check github's issues and pull requests to get latest status.

## License

MIT License (see `LICENSE` file).
