# Copyright Tomas Zeman 2019-2020.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include(${CMAKE_CURRENT_LIST_DIR}/_utils.cmake)

function(prefix_clangformat_setup prefix)
	find_program(CLANGFORMAT_EXECUTABLE clang-format)

  foreach(clangformat_source ${ARGN})
    get_filename_component(clangformat_source ${clangformat_source} ABSOLUTE)
    list(APPEND clangformat_sources ${clangformat_source})
  endforeach()

  add_custom_target(${prefix}-format
    COMMAND
      ${CLANGFORMAT_EXECUTABLE}
      -style=file
      -i
      ${clangformat_sources}
    WORKING_DIRECTORY
      ${CMAKE_SOURCE_DIR}
    COMMENT
      "Formatting ${prefix} with ${CLANGFORMAT_EXECUTABLE} ..."
  )

  add_custom_target(${prefix}-format-check
	  COMMAND
	  ${CLANGFORMAT_EXECUTABLE}
	  -style=file
	  --Werror
	  -n
	  ${clangformat_sources}
	  WORKING_DIRECTORY
	  ${CMAKE_SOURCE_DIR}
	  COMMENT
	  "check formatting of ${prefix}"
	  )

  add_or_create(format ${prefix}-format )
  add_or_create(check-format ${prefix}-format-check) 
  add_or_create(check check-format)
endfunction()

function(clangformat_setup)
  prefix_clangformat_setup(${PROJECT_NAME} ${ARGN})
endfunction()

function(target_clangformat_setup target)
  get_target_property(target_sources ${target} SOURCES)
  prefix_clangformat_setup(${target} ${target_sources})
endfunction()
