#ndk : I had to "module load cray-hdf5 silo" 
#ndk  make config debug=1 mpi=1 prefix=$SCRATCH/polymec
# (Intel's compilers don't do C11.).
set(CMAKE_C_COMPILER cc)
set(CMAKE_CXX_COMPILER CC)
set(CMAKE_Fortran_COMPILER ftn)

# We are cared for mathematically.
set(NEED_LAPACK FALSE)

# We expect the following libraries to be available.
set(Z_LIBRARY /usr/lib64/libz.a)
set(Z_INCLUDE_DIR /usr/include)
get_filename_component(Z_LIBRARY_DIR ${Z_LIBRARY} DIRECTORY)

# Note that we use the hdf5 module and not cray-hdf5, since the silo 
# module (below) is linked against hdf5 and not cray-hdf5.
# FIXME: Use hdf5-parallel for parallel builds.
# Set up HDF5.
if (HAVE_MPI EQUAL 0)
  message(FATAL_ERROR "Serial configurations are not supported on NERSC Cori. Please configure with mpi=1.")
else()
  set(HDF5_LOC $ENV{HDF5_DIR})
  if (NOT HDF5_LOC)
    message(FATAL_ERROR "HDF5_DIR not found. Please load the hdf5-parallel module.")
  endif()
  include_directories(${HDF5_LOC}/include)
  link_directories(${HDF5_LOC}/lib)
  set(HDF5_LIBRARY ${HDF5_LOC}/lib/libhdf5_parallel.a)
  set(HDF5_HL_LIBRARY ${HDF5_LOC}/lib/libhdf5_hl_parallel.a)
  set(HDF5_LIBRARIES hdf5_hl_parallel;hdf5_parallel)
  set(HDF5_INCLUDE_DIR ${HDF5_LOC}/include)
endif()

set(SILO_LOC $ENV{SILO_DIR})
if (NOT SILO_LOC)
  message(FATAL_ERROR "SILO_DIR not found. Please load the silo module.")
endif()

if (EXISTS ${SILO_LOC}/lib/libsiloh5.a)
  include_directories(${SILO_LOC}/include)
  link_directories(${SILO_LOC}/lib)
  list(APPEND EXTRA_LINK_DIRECTORIES ${SILO_LOC}/lib)
  set(SILO_LIBRARY ${SILO_LOC}/lib/libsiloh5.a)
  set(SILO_LIBRARIES siloh5)
endif()

