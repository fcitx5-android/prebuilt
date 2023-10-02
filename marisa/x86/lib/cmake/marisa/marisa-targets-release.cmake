#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "marisa" for configuration "Release"
set_property(TARGET marisa APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(marisa PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmarisa.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS marisa )
list(APPEND _IMPORT_CHECK_FILES_FOR_marisa "${_IMPORT_PREFIX}/lib/libmarisa.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
