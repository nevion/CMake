set(ALL_FILES_GLOB "*.${cpack_archive_extension_}")

function(getPackageContent FILE RESULT_VAR)
  # TODO for some types this only works because libarchive handles it... (not
  #      part of for e.g. gnu tar)
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar -xtf ${FILE}
          OUTPUT_VARIABLE package_content_
          ERROR_QUIET
          OUTPUT_STRIP_TRAILING_WHITESPACE)

  set(${RESULT_VAR} "${package_content_}" PARENT_SCOPE)
endfunction()

function(getPackageNameGlobexpr NAME COMPONENT VERSION REVISION FILE_NO RESULT_VAR)
  if(COMPONENT)
    set(COMPONENT "-${COMPONENT}")
  endif()

  set(${RESULT_VAR}
    "${NAME}-${VERSION}-*${COMPONENT}.${cpack_archive_extension_}" PARENT_SCOPE)
endfunction()

function(getPackageContentList FILE RESULT_VAR)
  getPackageContent("${FILE}" package_content_)

  string(REPLACE "\n" ";" package_content_ "${package_content_}")
  foreach(i_ IN LISTS package_content_)
    string(REGEX REPLACE "/$" "" result_ "${i_}")
    list(APPEND items_ "${result_}")
  endforeach()

  set(${RESULT_VAR} "${items_}" PARENT_SCOPE)
endfunction()

function(toExpectedContentList FILE_NO CONTENT_VAR)
  findExpectedFile("${FILE_NO}" "file_")

  # component and monolithic packages differ for some reason by either having
  # package filename prefix in path or not
  if(PACKAGING_TYPE STREQUAL "MONOLITHIC")
    get_filename_component(prefix_ "${file_}" NAME)
    # NAME_WE removes everything after the dot and dot is in version so replace instead
    string(REPLACE ".${cpack_archive_extension_}" "/" prefix_ "${prefix_}")
  else()
    unset(prefix_)
  endif()

  if(NOT DEFINED TEST_MAIN_INSTALL_PREFIX_PATH)
    set(TEST_MAIN_INSTALL_PREFIX_PATH "/usr")
  endif()

  unset(filtered_)
  foreach(part_ IN LISTS ${CONTENT_VAR})
    string(REGEX REPLACE "^${TEST_MAIN_INSTALL_PREFIX_PATH}(/|$)" "" part_ "${part_}")

    if(part_)
      list(APPEND filtered_ "${prefix_}${part_}")
    endif()
  endforeach()

  set(${CONTENT_VAR} "${filtered_}" PARENT_SCOPE)
endfunction()
