#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "intl" for configuration "Release"
set_property(TARGET intl APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(intl PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libintl.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS intl )
list(APPEND _IMPORT_CHECK_FILES_FOR_intl "${_IMPORT_PREFIX}/lib/libintl.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
