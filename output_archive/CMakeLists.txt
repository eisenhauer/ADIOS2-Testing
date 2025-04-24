cmake_minimum_required(VERSION 3.15)
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
   cmake_policy(SET CMP0135 NEW)
endif()

project(adios2-compatibility-testing C CXX)

include(ExternalProject)
include(CTest)
set(BUILD_TESTING ON CACHE BOOL "" FORCE)
enable_testing()

#
# For each test set <S>, we expect to find Write<S>.cpp and Read<S>.cpp as programs to be built.
# We also expect in the zipped_output directory that all zip files with the prefix <S> are the compressed contents of bpfiles that can be read with Read<S>
# Write<S>.cpp is expected to be use MPI and we'll try to create new files with mpirun -n 4 Write<S>
# Read<S>.cpp should not require MPI, but should be GTest enabled, and we'll generate CTest entries for each zipped file.
#
SET (TestSets Attribute Common)

find_package(ADIOS2 REQUIRED)
set(ADIOS2_DEP adios2::adios2)
if(MPI_FOUND)
  set(common_deps adios2::cxx11_mpi MPI::MPI_C)
else()
  set(common_deps adios2::cxx11)
endif()

find_package(GTest 1.16)
if( NOT GTest_FOUND )
  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.16.0.zip
  )
  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
 
  FetchContent_MakeAvailable(googletest)
endif()

find_package(MPI)

ADD_EXECUTABLE(test_file_unique test_file_unique.c)

foreach (TestSet ${TestSets})

    ADD_EXECUTABLE(Read${TestSet} Read${TestSet}.cpp)
target_link_libraries(Read${TestSet} adios2::adios2 GTest::gtest_main)
ADD_EXECUTABLE(Write${TestSet} Write${TestSet}.cpp)
target_link_libraries(Write${TestSet} adios2::adios2 MPI::MPI_CXX   GTest::gtest_main)


FILE(GLOB ${TestSet}S ${CMAKE_SOURCE_DIR}/zipped_output/${TestSet}*.zip)
set (OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/TempOutput")
file(MAKE_DIRECTORY ${OUTPUT_DIRECTORY})
LIST(REMOVE_DUPLICATES ${TestSet}S)

foreach	(${TestSet}OUT ${${TestSet}S})
    GET_FILENAME_COMPONENT(NO_ZIP ${${TestSet}OUT} NAME_WLE)
    GET_FILENAME_COMPONENT(DIR ${${TestSet}OUT} DIRECTORY)
    GET_FILENAME_COMPONENT(UNIQNAME ${NO_ZIP} NAME)
    GET_FILENAME_COMPONENT(BASENAME ${NO_ZIP} NAME_WLE)
    GET_FILENAME_COMPONENT(ENGINE_EXT ${NO_ZIP} LAST_EXT)
    STRING(REGEX REPLACE "^\\." "" ENGINE ${ENGINE_EXT})
    set (EXTRACTED_BPFILE "${OUTPUT_DIRECTORY}/${NO_ZIP}")
    file (MAKE_DIRECTORY ${EXTRACTED_BPFILE})
    MESSAGE (STATUS "Setting up read test for file ${EXTRACTED_BPFILE}")
    file(ARCHIVE_EXTRACT INPUT ${${TestSet}OUT} DESTINATION ${EXTRACTED_BPFILE})
    ADD_TEST(NAME Reading${UNIQNAME} COMMAND Read${TestSet} ${EXTRACTED_BPFILE})
endforeach()


# Configuration  Engines to create new files with
SET(NewFileEngineList bp5)

foreach	(Engine ${NewFileEngineList})
    MESSAGE (STATUS "output for engine ${Engine} and test set ${TestSet}")
    add_custom_target(
	new_${TestSet}_${Engine}_OUTPUT ALL
	COMMAND mpirun -n 4 Write${TestSet} ${Engine} ${CMAKE_BINARY_DIR}/TempOutput/Current${TestSet}.${Engine}
	COMMAND ${CMAKE_COMMAND} -DSOURCE_DIR=${CMAKE_BINARY_DIR}/TempOutput/Current${TestSet}.${Engine} -DARCHIVE_NAME=${CMAKE_BINARY_DIR}/TempOutput/Current${TestSet}.${Engine}.zip -P ${CMAKE_SOURCE_DIR}/create_archive.cmake
	COMMAND test_file_unique ${CMAKE_BINARY_DIR}/TempOutput/Current${TestSet}.${Engine}.zip ${${TestSet}S}
	BYPRODUCTS ${CURRENT_BINARY_DIR}/Current${TestSet}.${Engine}.zip)
    add_dependencies(new_${TestSet}_${Engine}_OUTPUT Write${TestSet})
endforeach()
endforeach()  # over testsets

