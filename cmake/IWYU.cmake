# Copyright Erez Amihud 2023-2023.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include(${CMAKE_CURRENT_LIST_DIR}/_utils.cmake)

set(IWYU_TOOL ${CMAKE_CURRENT_LIST_DIR}/iwyu_tool.py)
set(IWYU_FIX_INCLUDES ${CMAKE_CURRENT_LIST_DIR}/fix_includes.py)
function(prefix_iwyu_setup prefix)
	find_program(PYTHON_EXECUTABLE python)

	add_custom_target(${prefix}-iwyu
		COMMAND
		${PYTHON_EXECUTABLE}
		${IWYU_FIX_INCLUDES}
		-p ${CMAKE_BINARY_DIR}
		WORKING_DIRECTORY
		${CMAKE_SOURCE_DIR}
		COMMENT
		"IWYU ${prefix}..."
	)

	add_custom_target(${prefix}-iwyu-check
		COMMAND
		${PYTHON_EXECUTABLE}
		${IWYU_TOOL}
		-p ${CMAKE_BINARY_DIR}
		WORKING_DIRECTORY
		${CMAKE_SOURCE_DIR}
		COMMENT
		"check iwyu of ${prefix}"
	)

	add_or_create(iwyu ${prefix}-iwyu)
	add_or_create(check-iwyu ${prefix}-iwyu-check)
	add_or_create(check check-iwyu)
endfunction()

function(iwyu_setup)
	prefix_iwyu_setup(${PROJECT_NAME} ${ARGN})
endfunction()

function(target_iwyu_setup target)
	get_target_property(target_sources ${target} SOURCES)
	prefix_iwyu_setup(${target} ${target_sources})
endfunction()
