# Copyright Erez Amihud 2023-2023.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include(${CMAKE_CURRENT_LIST_DIR}/_utils.cmake)

set(IWYU_TOOL ${CMAKE_CURRENT_LIST_DIR}/iwyu_tool.py)
set(IWYU_FIX_INCLUDES ${CMAKE_CURRENT_LIST_DIR}/fix_includes.py)
function(prefix_iwyu_setup prefix)
	find_program(PYTHON_EXECUTABLE python)
	
	foreach(iwyu_source ${ARGN})
		get_filename_component(iwyu_source ${iwyu_source} ABSOLUTE)
		list(APPEND iwyu_sources ${iwyu_source})
	endforeach()

	set(IWYU_IMP_COMMAND "")
	if(IWYU_IMP)
		set(IWYU_IMP_COMMAND "")
		foreach(tmp IN LISTS IWYU_IMP)
			set(IWYU_IMP_COMMAND ${IWYU_IMP_COMMAND} -Xiwyu --mapping_file=${tmp})
		endforeach()
	endif()

	set(IWYU_OUTPUT "${CMAKE_BINARY_DIR}/${prefix}_iwyu.txt")
	set(IWYU_COMMAND ${PYTHON_EXECUTABLE} ${IWYU_TOOL} -p=${CMAKE_BINARY_DIR} -- ${IWYU_IMP_COMMAND})
	add_custom_target(${prefix}-iwyu
		COMMAND ${IWYU_COMMAND} > ${IWYU_OUTPUT} || echo "nothing-print to avoid faliure"
		COMMAND ${PYTHON_EXECUTABLE} ${IWYU_FIX_INCLUDES} < ${IWYU_OUTPUT}
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		COMMENT
		"IWYU ${prefix}..."
	)

	add_custom_target(${prefix}-iwyu-check
		COMMAND ${IWYU_COMMAND}
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
