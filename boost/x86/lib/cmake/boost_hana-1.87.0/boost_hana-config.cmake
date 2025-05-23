# Generated by BoostInstall.cmake for boost_hana-1.87.0

if(Boost_VERBOSE OR Boost_DEBUG)
  message(STATUS "Found boost_hana ${boost_hana_VERSION} at ${boost_hana_DIR}")
endif()

include(CMakeFindDependencyMacro)

if(NOT boost_config_FOUND)
  find_dependency(boost_config 1.87.0 EXACT HINTS "${CMAKE_CURRENT_LIST_DIR}/..")
endif()
if(NOT boost_core_FOUND)
  find_dependency(boost_core 1.87.0 EXACT HINTS "${CMAKE_CURRENT_LIST_DIR}/..")
endif()
if(NOT boost_fusion_FOUND)
  find_dependency(boost_fusion 1.87.0 EXACT HINTS "${CMAKE_CURRENT_LIST_DIR}/..")
endif()
if(NOT boost_mpl_FOUND)
  find_dependency(boost_mpl 1.87.0 EXACT HINTS "${CMAKE_CURRENT_LIST_DIR}/..")
endif()
if(NOT boost_tuple_FOUND)
  find_dependency(boost_tuple 1.87.0 EXACT HINTS "${CMAKE_CURRENT_LIST_DIR}/..")
endif()

include("${CMAKE_CURRENT_LIST_DIR}/boost_hana-targets.cmake")
