include(${CMAKE_CURRENT_LIST_DIR}/IWYU.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ClangFormat.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ClangTidy.cmake)

function(taget_setup target)
    target_clangformat_setup(${target})
   target_clangtidy_setup(${target})
   target_iwyu_setup(${target})
       
endfunction(taget_setup)
