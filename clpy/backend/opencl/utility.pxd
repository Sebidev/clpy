include "common_decl.pxi"

###############################################################################
# helpers
cdef cl_uint GetDeviceMemBaseAddrAlign(cl_device_id device)
cdef GetDeviceAddressBits(cl_device_id device)

###############################################################################
# utility
cdef void SetKernelArgLocalMemory(cl_kernel kernel, arg_index, size_t size)
cdef is_valid_kernel_name(name)
cdef cl_program CreateProgram(sources, cl_context context, num_devices,
                              cl_device_id* devices_ptrs,
                              options=*) except *
cdef GetProgramBuildLog(cl_program program)
