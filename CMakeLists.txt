cmake_minimum_required(VERSION 3.16...3.22)
project(pydaa)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

add_subdirectory(pybind11)
add_subdirectory(daa)
