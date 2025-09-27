################################################################################
# CMake setup
################################################################################
cmake_minimum_required(VERSION 3.16)

include(FetchContent)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(Common)

#message("+++++ CMAKE_SOURCE_DIR = ${CMAKE_SOURCE_DIR}") # test_ci_cd
#message("+++++ CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}") # test_ci_cd/builds/XXX-Debug

################################################################################
# Project setup
################################################################################

# Get project version from version.txt
file(READ "version.txt" VERSION_FULL)
string(REPLACE "." ";" VERSION_LIST ${VERSION_FULL})
list(GET VERSION_LIST 0 VERSION_MAJOR)
list(GET VERSION_LIST 1 VERSION_MINOR)
list(GET VERSION_LIST 2 VERSION_PATCH)
string(STRIP ${VERSION_FULL} VERSION_FULL) # strip leading/trailing whitespaces
# message("+++++ VERSION_FULL = ${VERSION_FULL}")
# message("+++++ version: ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

project(test_ci_cd
    VERSION ${VERSION_FULL}
    LANGUAGES CXX)

message(STATUS "Project version (from version.txt): ${VERSION_FULL}")

# Overwrite project version with version from git tag if possible
include(GitVersion)
get_version_from_git()

# Generate version.h
configure_file(
    ${CMAKE_SOURCE_DIR}/src/version.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.h
)

message(STATUS "Project version (overwritten by git tag): ${PROJECT_VERSION}")

# enable_testing() # automatically invoked when the CTest module is included
include(CTest)

################################################################################
# Compilation/link settings
################################################################################

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # generates compile_commands.json

################################################################################
# Dependencies
################################################################################

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets)

# Catch2: unit tests framework (headers only)
FetchContent_Declare(
  libcatch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v2.13.10
)
FetchContent_MakeAvailable(libcatch2)
include_directories(SYSTEM "${libcatch2_SOURCE_DIR}/single_include")
list(APPEND CMAKE_MODULE_PATH "${libcatch2_SOURCE_DIR}/contrib")
include(Catch)

################################################################################
# Sources setup
################################################################################

set(PROJECT_SOURCES
        src/main.cpp
        src/mainwindow.cpp
        src/mainwindow.h
)

################################################################################
# Target setup
################################################################################

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(${PROJECT_NAME} SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(${PROJECT_NAME}
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.${PROJECT_NAME})
endif()
set_target_properties(${PROJECT_NAME} PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Include generated files (i.e. version.h)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/generated)

# Coverage (generate .gcda/.gcno along object files)
target_compile_options(${PROJECT_NAME} PRIVATE -coverage)
target_link_options(${PROJECT_NAME} PRIVATE -coverage)

################################################################################
# Unit tests
################################################################################

set(TESTS_EXE_NAME ${PROJECT_NAME}_tests)
find_sources_recursive("tests/unit_tests" "TEST_FILES")

# include_directories(SYSTEM "${libpugixml_SOURCE_DIR}/src")
add_executable(${TESTS_EXE_NAME} ${TEST_FILES})
target_include_directories(${TESTS_EXE_NAME} PRIVATE src)
# target_link_libraries(${TESTS_EXE_NAME} PRIVATE ${PROJECT_NAME} Catch2::Catch2 ${LINKED_LIBRARIES})
catch_discover_tests(${TESTS_EXE_NAME})

# Run tests as post build command
# add_custom_command(
#      TARGET ${TESTS_EXE_NAME}
#      COMMENT "Run tests"
#      POST_BUILD
#      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#      COMMAND ${CMAKE_CTEST_COMMAND} -C $<CONFIGURATION> -R "^${TESTS_EXE_NAME}$"
# )

################################################################################
# Install
################################################################################

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(${PROJECT_NAME})
endif()
