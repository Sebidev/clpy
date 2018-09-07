cimport clpy.backend.opencl.api as api
import clpy.backend.opencl.env
cimport clpy.backend.opencl.env
import clpy.backend.opencl.types
cimport clpy.backend.opencl.types
from clpy.backend.opencl.types cimport *

cdef CLBlastLayout translate_str_layout(str_layout) except *:
    if (str_layout == 'R'):
        return CLBlastLayoutRowMajor
    elif (str_layout == 'C'):
        return CLBlastLayoutColMajor
    else:
        raise ValueError("layout should be \'R\' or \'c\'")

cdef CLBlastTranspose translate_transpose(trans) except *:
    if (trans == 'n' or trans == 0):
        return CLBlastTransposeNo
    elif (trans == 't' or trans == 1):
        return CLBlastTransposeYes
    else:
        raise ValueError("transpose should be n(0) or t(1)")

cdef void clblast_sgemm(CLBlastLayout layout, CLBlastTranspose a_transpose, CLBlastTranspose b_transpose,
                   size_t m, size_t n, size_t k,
                   float alpha,
                   cl_mem a_buffer, size_t a_offset, size_t a_ld,
                   cl_mem b_buffer, size_t b_offset, size_t b_ld,
                   float beta,
                   cl_mem c_buffer, size_t c_offset, size_t c_ld) except *:
    cdef cl_event event = NULL
    cdef cl_command_queue command_queue=clpy.backend.opencl.env.get_command_queue()

    cdef CLBlastStatusCode status = CLBlastSgemm(
        layout, a_transpose, b_transpose,
        m, n, k,
        alpha,
        a_buffer, a_offset, a_ld,
        b_buffer, b_offset, b_ld,
        beta,
        c_buffer, c_offset, c_ld,
        &command_queue,
        &event
        )
    if (status == CLBlastSuccess):
        api.WaitForEvents(1, &event)
        api.ReleaseEvent(event)
    return

cpdef sgemm(str_layout, transa, transb,
            m, n, k, alpha,
            A, lda,
            B, ldb,
            beta,
	    C, ldc):
    cdef CLBlastLayout layout = translate_str_layout(str_layout)
    cdef CLBlastTranspose a_transpose = translate_transpose(transa)
    cdef CLBlastTranspose b_transpose = translate_transpose(transb)

    cdef size_t a_buffer = A.data.buf.get()
    cdef size_t b_buffer = B.data.buf.get()
    cdef size_t c_buffer = C.data.buf.get()

    clblast_sgemm(
        layout, a_transpose, b_transpose,
        m, n, k, alpha,
        <cl_mem>a_buffer, A.data.cl_mem_offset() // A.itemsize, lda,
        <cl_mem>b_buffer, B.data.cl_mem_offset() // B.itemsize, ldb,
        beta,
        <cl_mem>c_buffer, C.data.cl_mem_offset() // C.itemsize, ldc)




cdef void clblast_dgemm(CLBlastLayout layout, CLBlastTranspose a_transpose, CLBlastTranspose b_transpose,
                   size_t m, size_t n, size_t k,
                   double alpha,
                   cl_mem a_buffer, size_t a_offset, size_t a_ld,
                   cl_mem b_buffer, size_t b_offset, size_t b_ld,
                   double beta,
                   cl_mem c_buffer, size_t c_offset, size_t c_ld) except *:
    cdef cl_event event = NULL
    cdef cl_command_queue command_queue=clpy.backend.opencl.env.get_command_queue()

    cdef CLBlastStatusCode status = CLBlastDgemm(
        layout, a_transpose, b_transpose,
        m, n, k,
        alpha,
        a_buffer, a_offset, a_ld,
        b_buffer, b_offset, b_ld,
        beta,
        c_buffer, c_offset, c_ld,
        &command_queue,
        &event
        )
    if (status == CLBlastSuccess):
        api.WaitForEvents(1, &event)
        api.ReleaseEvent(event)
    return

cpdef dgemm(str_layout, transa, transb,
            m, n, k, alpha,
            A, lda,
            B, ldb,
            beta,
	    C, ldc):
    cdef CLBlastLayout layout = translate_str_layout(str_layout)
    cdef CLBlastTranspose a_transpose = translate_transpose(transa)
    cdef CLBlastTranspose b_transpose = translate_transpose(transb)

    cdef size_t a_buffer = A.data.buf.get()
    cdef size_t b_buffer = B.data.buf.get()
    cdef size_t c_buffer = C.data.buf.get()

    clblast_dgemm(
        layout, a_transpose, b_transpose,
        m, n, k, alpha,
        <cl_mem>a_buffer, A.data.cl_mem_offset() // A.itemsize, lda,
        <cl_mem>b_buffer, B.data.cl_mem_offset() // B.itemsize, ldb,
        beta,
        <cl_mem>c_buffer, C.data.cl_mem_offset() // C.itemsize, ldc)
