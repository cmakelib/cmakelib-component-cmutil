## Main
#
# Initialize CMUtil module.
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.18 FATAL_ERROR)

IF(DEFINED CMUTIL_INCLUDED)
	_CMLIB_LIBRARY_DEBUG_MESSAGE("CMUTIL Library already included")
	RETURN()
ENDIF()

# Flag that CMLIB is already included
SET(CMUTIL_INCLUDED "1")

SET(CMUTIL_PACKAGE_NAME "UTIL")

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/system_modules/CMUTIL_TRAIT.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/system_modules/CMUTIL_PROPERTY_FILE.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/system_modules/CMUTIL_VERSION.cmake)

SET(${CMUTIL_PACKAGE_NAME}_FOUND 1)
SET(${CMUTIL_PACKAGE_NAME}_DIR "${CMAKE_CURRENT_LIST_DIR}")
