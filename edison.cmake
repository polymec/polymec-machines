# ------------
# NERSC Edison
# ------------
# 
# Make sure the following modules are loaded:
#   cmake 
#   cray-hdf5-parallel
# 
# and then type
# 
# make config mpi=1 machine=edison prefix=/prefix/for/polymec
# 
# adding any additional desired flags. Then:
# 
# make mpi=1 machine=edison install
#
# To run the unit tests, change to build/edison* and type
#
# salloc [options] ctest
#
# where you can specify options for your account, etc.

# Edison likes Intel's compilers
# (but Intel's compilers don't do C11.).
set(CMAKE_C_COMPILER cc)
set(CMAKE_CXX_COMPILER CC)
set(CMAKE_Fortran_COMPILER ftn)

# We are cared for mathematically.
set(NEED_LAPACK FALSE)

# We expect the following libraries to be available.
set(Z_LIBRARY /usr/lib64/libz.a)
set(Z_INCLUDE_DIR /usr/include)
get_filename_component(Z_LIBRARY_DIR ${Z_LIBRARY} DIRECTORY)

# Set up HDF5.
if (HAVE_MPI EQUAL 0)
  message(FATAL_ERROR "Serial configurations are not supported on NERSC Edison. Please configure with mpi=1.")
else()
  set(HDF5_LOC $ENV{HDF5_DIR})
  if (NOT HDF5_LOC)
    message(FATAL_ERROR "HDF5_DIR not found. Please load the cray-hdf5-parallel module.")
  endif()
  include_directories(${HDF5_LOC}/include)
  link_directories(${HDF5_LOC}/lib)
  set(HDF5_LIBRARY ${HDF5_LOC}/lib/libhdf5_parallel.a)
  set(HDF5_HL_LIBRARY ${HDF5_LOC}/lib/libhdf5_hl_parallel.a)
  set(HDF5_LIBRARIES hdf5_hl_parallel;hdf5_parallel)
  set(HDF5_INCLUDE_DIR ${HDF5_LOC}/include)
endif()

set(BATCH_SYSTEM "slurm")
set(PROCS_PER_NODE 32)
