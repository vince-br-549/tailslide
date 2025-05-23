cmake_minimum_required(VERSION 3.8)
project(Tailslide LANGUAGES CXX)

include(GNUInstallDirs)

if (MSVC)
  # MSVC requires C++20 be enabled to allow designated initializers
  set(CMAKE_CXX_STANDARD 20)
else()
  set(CMAKE_CXX_STANDARD 17)
endif()
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(_IGNORED "${CMAKE_C_COMPILER}")

option(TAILSLIDE_CI_RUN "Are we running in CI" OFF)
option(TAILSLIDE_BUILD_CLI "Build CLI" ON)
option(TAILSLIDE_BUILD_TESTS "Build Tests" ON)
option(TAILSLIDE_BUILD_FUZZER "Build Fuzzer" OFF)
option(TAILSLIDE_SANITIZE "Use ASAN" OFF)
option(TAILSLIDE_FUZZER_INSTRUMENTATION "Add instrumentation for libFuzzer" OFF)
option(TAILSLIDE_COVERAGE "Track coverage data in tests" OFF)

if (MSVC)
  # So?
  add_definitions("-D_CRT_SECURE_NO_WARNINGS=1")
else()
  # Don't whine about using sprintf() in doctest
  add_definitions("-Wall -Wno-deprecated-declarations")
  if (NOT CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_definitions("-Wno-unneeded-internal-declaration")
  endif()
  if (TAILSLIDE_CI_RUN)
    add_definitions("-Werror")
  endif()
endif()


if (TAILSLIDE_BUILD_FUZZER)
  set(TAILSLIDE_SANITIZE ON)
  set(TAILSLIDE_FUZZER_INSTRUMENTATION ON)
endif ()

# On macOS, search Homebrew for keg-only versions of Bison and Flex. Xcode does
# not provide new enough versions for us to use.
if (CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")
  execute_process(
          COMMAND brew --prefix bison
          RESULT_VARIABLE BREW_BISON
          OUTPUT_VARIABLE BREW_BISON_PREFIX
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if (BREW_BISON EQUAL 0 AND EXISTS "${BREW_BISON_PREFIX}")
    message(STATUS "Found Bison keg installed by Homebrew at ${BREW_BISON_PREFIX}")
    set(BISON_EXECUTABLE "${BREW_BISON_PREFIX}/bin/bison")
  endif()

  execute_process(
          COMMAND brew --prefix flex
          RESULT_VARIABLE BREW_FLEX
          OUTPUT_VARIABLE BREW_FLEX_PREFIX
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if (BREW_FLEX EQUAL 0 AND EXISTS "${BREW_FLEX_PREFIX}")
    message(STATUS "Found Flex keg installed by Homebrew at ${BREW_FLEX_PREFIX}")
    set(FLEX_EXECUTABLE "${BREW_FLEX_PREFIX}/bin/flex")
  endif()
endif()

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)
# vince add
# Find Python3
find_package(Python3 REQUIRED)
# end of vince 
set(EXTRA_LIBS "")
if(UNIX AND NOT APPLE)
  set(EXTRA_LIBS "stdc++" "rt" "m")
endif()

if (TAILSLIDE_SANITIZE)
  add_compile_options("-fsanitize=address" "-O1")
  add_link_options("-fsanitize=address")
endif()

if (TAILSLIDE_FUZZER_INSTRUMENTATION)
  add_compile_options("-fsanitize=fuzzer")
  if (NOT TAILSLIDE_SANITIZE)
    add_link_options("-fsanitize=fuzzer-no-link")
  endif()
endif()

if (TAILSLIDE_COVERAGE)
  if ( NOT (CMAKE_CXX_COMPILER_ID MATCHES "Clang") )
    message(FATAL_ERROR "Clang must be used to enable coverage tracking, not ${CMAKE_CXX_COMPILER_ID}")
  endif()
  add_compile_options("-fprofile-instr-generate" "-fcoverage-mapping")
  add_link_options("-fprofile-instr-generate")
endif()

add_library(libtailslide STATIC
        libtailslide/allocator.cc
        libtailslide/ast.cc
	libtailslide/builtins.cc
        libtailslide/logger.cc
        libtailslide/lslmini.cc
        libtailslide/operations.cc
        libtailslide/strings.cc
        libtailslide/symtab.cc
        libtailslide/types.cc
        libtailslide/visitor.cc
        libtailslide/passes/globalexpr_validator.cc
        libtailslide/passes/final_pass.cc
        libtailslide/passes/desugaring.cc
        libtailslide/passes/pretty_print.cc
        libtailslide/passes/symbol_resolution.cc
        libtailslide/passes/type_checking.cc
        libtailslide/passes/tree_print.cc
        libtailslide/passes/tree_simplifier.cc
        libtailslide/passes/values.cc
        libtailslide/passes/lso/bytecode_compiler.cc
        libtailslide/passes/lso/library_funcs.cc
        libtailslide/passes/lso/script_compiler.cc
        libtailslide/passes/lso/resource_collector.cc
        libtailslide/passes/mono/resource_collector.cc
        libtailslide/passes/mono/script_compiler.cc
        libtailslide/tailslide.cc
        )
target_sources(libtailslide PRIVATE
        libtailslide/allocator.hh
	libtailslide/builtins_txt.cc ## vince move from static.
        libtailslide/ast.hh
        libtailslide/bitstream.hh
        libtailslide/loctype.hh
        libtailslide/logger.hh
        libtailslide/lslmini.hh
        libtailslide/operations.hh
        libtailslide/portable_endian.hh
        libtailslide/strings.hh
        libtailslide/symtab.hh
        libtailslide/types.hh
        libtailslide/unordered_cstr_map.hh
        libtailslide/visitor.hh
        libtailslide/passes/globalexpr_validator.hh
        libtailslide/passes/final_pass.hh
        libtailslide/passes/desugaring.hh
        libtailslide/passes/pretty_print.hh
        libtailslide/passes/symbol_resolution.hh
        libtailslide/passes/tree_simplifier.hh
        libtailslide/passes/tree_print.hh
        libtailslide/passes/type_checking.hh
        libtailslide/passes/values.hh
        libtailslide/passes/lso/bytecode_compiler.hh
        libtailslide/passes/lso/bytecode_format.hh
        libtailslide/passes/lso/library_funcs.hh
        libtailslide/passes/lso/script_compiler.hh
        libtailslide/passes/lso/resource_collector.hh
        libtailslide/passes/mono/resource_collector.hh
        libtailslide/passes/mono/script_compiler.hh
        libtailslide/tailslide.hh
)
##  vince from chat gpt
#
#
cmake_minimum_required(VERSION 3.12)
project(Tailslide)

# Find Python3 (ensure Python3 is installed)
find_package(Python3 REQUIRED)

# Path to builtins.txt and script
set(BUILTINS_TXT "${CMAKE_SOURCE_DIR}/builtins.txt")
set(BUILTINS_TXT_CC "${CMAKE_SOURCE_DIR}/libtailslide/builtins_txt.cc")
set(GENERATE_BUILTINS_SCRIPT "${CMAKE_SOURCE_DIR}/generate_builtins_c.py")

# Custom command to generate builtins_txt.cc
add_custom_command(
    OUTPUT ${BUILTINS_TXT_CC}
    COMMAND ${Python3_EXECUTABLE} ${GENERATE_BUILTINS_SCRIPT}
    DEPENDS ${BUILTINS_TXT} ${GENERATE_BUILTINS_SCRIPT}
    COMMENT "Regenerating builtins_txt.cc from builtins.txt"
)

# Custom target for running the custom command
add_custom_target(generate_builtins ALL DEPENDS ${BUILTINS_TXT_CC})

# Define the library or executable target
#add_library(libtailslide STATIC
#
#    # Add other source files here
#)

# Add dependencies to ensure builtins_txt.cc is up-to-date
add_dependencies(libtailslide generate_builtins)

# Define an executable (if applicable)
#add_executable(tailslide_cli
#    tailslide_cli.cpp # Replace with your actual source files
#)

# Ensure the executable depends on the library
#target_link_libraries(tailslide_cli PRIVATE libtailslide)

#
#
#
#
# end vince changes

string(TIMESTAMP BUILD_DATE "%Y-%m-%d")
add_definitions(-DBUILD_DATE="${BUILD_DATE}")
add_definitions(-DVERSION="0.1dev")

# Needed for Bison / Flex
FLEX_TARGET(LSLMiniScanner libtailslide/lslmini.l ${CMAKE_CURRENT_BINARY_DIR}/lslmini.flex.cc)
BISON_TARGET(LSLMiniParser libtailslide/lslmini.y ${CMAKE_CURRENT_BINARY_DIR}/lslmini.tab.cc)
ADD_FLEX_BISON_DEPENDENCY(LSLMiniScanner LSLMiniParser)

target_include_directories(libtailslide PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(libtailslide PUBLIC libtailslide)
target_sources(libtailslide PRIVATE ${FLEX_LSLMiniScanner_OUTPUTS} ${BISON_LSLMiniParser_OUTPUTS})
set_target_properties(libtailslide PROPERTIES OUTPUT_NAME tailslide)
if (NOT WIN32 AND NOT TAILSLIDE_FUZZER_INSTRUMENTATION)
  add_definitions("-fPIC")
endif()


install(TARGETS libtailslide DESTINATION lib)
install(DIRECTORY libtailslide/ DESTINATION include/tailslide FILES_MATCHING PATTERN "*.hh")


if (TAILSLIDE_BUILD_CLI)
  add_executable(tailslide_cli tailslide_cli/main.cc)
  target_sources(tailslide_cli PRIVATE
          extern/cxxopt.hh
  )
  target_include_directories(tailslide_cli PUBLIC ${CMAKE_CURRENT_BINARY_DIR} libtailslide extern)
  target_link_libraries(tailslide_cli PUBLIC ${EXTRA_LIBS} libtailslide)
  set_target_properties(tailslide_cli PROPERTIES OUTPUT_NAME tailslide)
endif()


if (TAILSLIDE_BUILD_TESTS)
  add_executable(tailslide_test
          tests/conformance.cc
          tests/ast_rewriting.cc
          tests/lso_compilation.cc
          tests/cil_compilation.cc
          tests/testutils.cc
          tests/main.cc
          tests/unit_tests.cc
  )
  target_sources(tailslide_test PRIVATE
    extern/doctest.hh
    tests/testutils.hh
  )
  target_include_directories(tailslide_test PUBLIC ${CMAKE_CURRENT_BINARY_DIR} libtailslide extern)
  target_link_libraries(tailslide_test PUBLIC ${EXTRA_LIBS} libtailslide)
  set_target_properties(tailslide_test PROPERTIES OUTPUT_NAME tailslide-test)
endif()
if (TAILSLIDE_BUILD_FUZZER)
  if ( NOT (${CMAKE_SYSTEM_NAME} STREQUAL "Linux") )
    message(FATAL_ERROR "The libFuzzer harness is only supported under Linux!")
  endif()
  if ( NOT (CMAKE_CXX_COMPILER_ID MATCHES "Clang") )
    message(FATAL_ERROR "The libFuzzer harness is only supported under Clang, not ${CMAKE_CXX_COMPILER_ID}")
  endif()

  add_executable(tailslide_fuzzer
    fuzz/fuzz.cc
  )
  target_sources(tailslide_fuzzer PRIVATE
  )
  target_include_directories(tailslide_fuzzer PUBLIC ${CMAKE_CURRENT_BINARY_DIR} libtailslide)
  target_link_libraries(tailslide_fuzzer PUBLIC ${EXTRA_LIBS} libtailslide "-fsanitize=fuzzer,address")
  set_target_properties(tailslide_fuzzer PROPERTIES OUTPUT_NAME tailslide-fuzzer)
endif()
