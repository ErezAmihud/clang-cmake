[![language.badge]][language.url] [![license.badge]][license.url]

# Clang.cmake module

Clang.cmake is a cmake module for clang-format, clang-tidy and include-what-you-use.

## Requirements

The module requires CMake 3.0 or higher and some version of clang-format clang-tidy and iwyu installed.

## Integration

1. Obtain the module and add it into your project's CMake modules path:

   * Submodule approach:

     ```bash
     $ git submodule add https://github.com/erezamihud/clang-cmake
     ```

     ```cmake
     # CMakeLists.txt

     list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/clang-cmake/cmake)
     ```

2. Include the modules:

   ```cmake
   # CMakeLists.txt

   include(ClangFormat)
   include(ClangTidy)
   include(IWYU)
   ```

3. Setup the module:

   ```cmake
   # CMakeLists.txt

   clangformat_setup(
     src/hello.hpp
     src/hello.cpp
   )
   clangtidy_setup(
     src/hello.hpp
     src/hello.cpp
   )
   iwyu_setup(
     src/hello.hpp
     src/hello.cpp
   )
   ```

   or to get the sources from existing targets:

   ```cmake
   # CMakeLists.txt

   target_clangformat_setup(sometarget)
   target_clangtidy_setup(sometarget)
   target_iwyu_setup(sometarget)
   ```

To setup all the things for a specific target:
`target_setup(sometarget)`

## Usage

The module add a few custom commands:
- `check` - run all of the target with warnings as errors (as you would in ci)
Do cmake --build build --target help to look at everything else.
To add iwyu mapping files use the variable IWYU_IMP is a list, that should have all of the [mapping files](https://github.com/include-what-you-use/include-what-you-use/blob/e23a2f9807b1174d95e65b480aeef3e5e65fc539/docs/IWYUMappings.md)


1. Generate the build system:

   ```bash
   $ cmake -S . -Bbuild
   ```

2. Run things:

   ```bash
   $ cmake --build build --target format
   ```

## Extra changes worth noting
- In iwyu python scripts I added code to make sure that when exit code 2 is received the script exit with exit code 0 (code 2 in iwyu states that everything worked well)

## Example

See an example [here](https://github.com/ErezAmihud/cpp-base).

[language.url]:   https://cmake.org/
[language.badge]: https://img.shields.io/badge/language-CMake-blue.svg

[license.url]:    http://www.boost.org/LICENSE_1_0.txt
[license.badge]:  https://img.shields.io/badge/license-Boost%201.0-blue.svg
