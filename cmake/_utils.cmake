function (add_or_create to from)
	if(TARGET ${to})
		add_dependencies(${to} ${from})
	else()
		add_custom_target(${to} DEPENDS ${from})
	endif()
endfunction()
