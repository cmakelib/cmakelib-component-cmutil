
IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
	CMAKE_MINIMUM_REQUIRED(VERSION 3.18)
	PROJECT(CMUTIL_VERSION_NOT_VALID_VERSION_TEST)
ENDIF()

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../")

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../TEST.cmake")

FIND_PACKAGE(CMUTIL)

CMUTIL_VERSION_VALIDATE_VERSION_FILE_FOR("1.58.3")
