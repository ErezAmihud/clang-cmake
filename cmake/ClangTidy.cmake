# Copyright Erez Amihud 2023-2023.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include(${CMAKE_CURRENT_LIST_DIR}/_utils.cmake)


set(CLANGTIDY_TOOL ${CMAKE_CURRENT_LIST_DIR}/run-clang-tidy.py)
function(prefix_clangtidy_setup prefix)
	find_program(PYTHON_EXECUTABLE python)

	foreach(clangtidy_source ${ARGN})
		get_filename_component(clangtidy_source ${clangtidy_source} ABSOLUTE)
		list(APPEND clangtidy_sources ${clangtidy_source})
	endforeach()

	add_custom_target(${prefix}-tidy
		COMMAND
		${PYTHON_EXECUTABLE}
		${CLANGTIDY_TOOL}
		-fix
		${clangtidy_sources}
		WORKING_DIRECTORY
		${CMAKE_BINARY_DIR}
		COMMENT
		"Tidy ${prefix} with ${CLANGTIDY_EXECUTABLE} ..."
	)

	add_custom_target(${prefix}-tidy-check
		COMMAND
		${PYTHON_EXECUTABLE}
		${CLANGTIDY_TOOL}
		${clangtidy_sources}
		WORKING_DIRECTORY
		${CMAKE_BINARY_DIR}
		COMMENT
		"check tidy of ${prefix}"
	)

	add_or_create(tidy ${prefix}-tidy)
	add_or_create(check-tidy ${prefix}-tidy-check)
	add_or_create(check check-tidy)
endfunction()

function(clangtidy_setup)
	prefix_clangtidy_setup(${PROJECT_NAME} ${ARGN})
endfunction()

function(target_clangtidy_setup target)
	get_target_property(target_sources ${target} SOURCES)
	prefix_clangtidy_setup(${target} ${target_sources})
endfunction()
