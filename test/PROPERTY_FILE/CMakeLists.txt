
IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
	CMAKE_MINIMUM_REQUIRED(VERSION 3.16)
	PROJECT(CMUTIL_PROPERTY_FILE_TEST)
ENDIF()

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../")


INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../TEST.cmake")

FIND_PACKAGE(UTIL)

CMUTIL_PROPERTY_FILE_READ("property_file.txt" nem)

IF(NOT nem_version STREQUAL "15")
	MESSAGE(FATAL_ERROR "version is not defined correctly ${nem_version}")
ENDIF()

IF(NOT nem_key STREQUAL "value")
	MESSAGE(FATAL_ERROR "key is not defined correctly ${nem_key}")
ENDIF()

IF(NOT nem_mynice STREQUAL "123.cvvc?/")
	MESSAGE(FATAL_ERROR "mynice is not defined correctly ${nem_mynice}")
ENDIF()
