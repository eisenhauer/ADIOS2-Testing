cmake_minimum_required(VERSION 3.15)
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
   cmake_policy(SET CMP0135 NEW)
endif()

project(adios2-compatibility-testing C CXX Fortran)

include(ExternalProject)
include(CTest)
set(BUILD_TESTING ON CACHE BOOL "" FORCE)
enable_testing()


find_package(ADIOS2 REQUIRED)
set(ADIOS2_DEP adios2::adios2)
if(MPI_FOUND)
  set(common_deps adios2::cxx11_mpi MPI::MPI_C)
else()
  set(common_deps adios2::cxx11)
endif()

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.16.0.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

ADD_EXECUTABLE(test_file_unique test_file_unique.c)


# Configuration  Engines to create new files with
SET(NewFileEngineList bp4 bp5)



ADD_EXECUTABLE(ReadCommon ReadCommon.cpp)
target_link_libraries(ReadCommon adios2::adios2 MPI::MPI_C   GTest::gtest_main)
ADD_EXECUTABLE(WriteCommon WriteCommon.cpp)
target_link_libraries(WriteCommon adios2::adios2 MPI::MPI_C   GTest::gtest_main)
#ADD_EXECUTABLE(test_file_unique test_file_unique.c)

FILE(GLOB CommonS ${CMAKE_SOURCE_DIR}/zipped_output/Common*.zip)
set (OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/TempOutput")
file(MAKE_DIRECTORY ${OUTPUT_DIRECTORY})
LIST(REMOVE_DUPLICATES CommonS)

foreach	(CommonOUT ${CommonS})
    GET_FILENAME_COMPONENT(NO_ZIP ${CommonOUT} NAME_WLE)
    GET_FILENAME_COMPONENT(DIR ${CommonOUT} DIRECTORY)
    GET_FILENAME_COMPONENT(BASENAME ${NO_ZIP} NAME_WLE)
    GET_FILENAME_COMPONENT(ENGINE_EXT ${NO_ZIP} LAST_EXT)
    STRING(REGEX REPLACE "^\\." "" ENGINE ${ENGINE_EXT})
    set (EXTRACTED_BPFILE "${OUTPUT_DIRECTORY}/${NO_ZIP}")
    file (MAKE_DIRECTORY ${EXTRACTED_BPFILE})
    file(ARCHIVE_EXTRACT INPUT ${CommonOUT} DESTINATION ${EXTRACTED_BPFILE} VERBOSE)
    ADD_TEST(NAME CommonOUT_${ENGINE}_${BASENAME} COMMAND ReadCommon ${EXTRACTED_BPFILE})
endforeach()

foreach	(Engine ${NewFileEngineList})
    MESSAGE (STATUS "output for engine ${Engine}")
    add_custom_target(
	new_Common_${Engine}_OUTPUT ALL
	COMMAND mpirun -n 4 WriteCommon ${Engine} ${CMAKE_BINARY_DIR}/TempOutput/CurrentCommon.${Engine}
	COMMAND ${CMAKE_COMMAND} -DSOURCE_DIR=${CMAKE_BINARY_DIR}/TempOutput/CurrentCommon.${Engine} -DARCHIVE_NAME=${CMAKE_BINARY_DIR}/TempOutput/CurrentCommon.${Engine}.zip -P ${CMAKE_SOURCE_DIR}/create_archive.cmake
	COMMAND test_file_unique ${CMAKE_BINARY_DIR}/TempOutput/CurrentCommon.${Engine}.zip ${CommonS}
	BYPRODUCTS ${CURRENT_BINARY_DIR}/CurrentCommon.${Engine}.zip)
    add_dependencies(new_Common_${Engine}_OUTPUT WriteCommon)
endforeach()

