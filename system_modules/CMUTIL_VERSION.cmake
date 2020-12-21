# Main
#
# Validate version and version file.
#
# Version file is a file where the first line is in form
# version=<version>
#

IF(DEFINED CMUTIL_VERSION_MODULE)
	RETURN()
ENDIF()
SET(CMUTIL_VERSION_MODULE 1)

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/CMUTIL_PROPERTY_FILE.cmake)



##
# Check if the version specified by <version_string>
# is valid.
# If not throws an error.
# 
# <function>(
#		<version_string>
# )
#
FUNCTION(CMUTIL_VERSION_CHECK version_string)
	SET(version_regex "([0-9]+)\.([0-9]+)(\.([0-9]+))?")
	STRING(REPLACE "." ";" version_list ${version_string})
	LIST(LENGTH version_list version_list_length)

	STRING(REGEX MATCHALL "${version_regex}"
		version_match "${version_string}"
	)
	IF(NOT version_match)
		MESSAGE(FATAL_ERROR "Version '${version_string}' is not in valid format!")
	ENDIF()
	IF(version_list_length LESS 2)
		MESSAGE(FATAL_ERROR "Missing version parts in '${version_string}'. The format is ${version_regex}")
	ENDIF()
ENDFUNCTION()



##
# Get latest tag of the repository.
# Tag must be valid version tag.
#
# If the tag is not valid version tag the error occures
#
# <function> (
#		<output_var>
# )
#
FUNCTION(CMUTIL_VERSION_LATEST_TAG output_var)
	EXECUTE_PROCESS(
		COMMAND ${CMLIB_REQUIRED_ENV_GIT_EXECUTABLE}  describe --tags --abbrev=0
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		OUTPUT_VARIABLE process_output
	)
	IF(NOT process_output)
		MESSAGE(FATAL_ERROR "Cannot get last version tag!")
	ENDIF()
	STRING(SUBSTRING ${process_output} 0 1 first_char)
	IF(NOT first_char STREQUAL "v")
		MESSAGE(FATAL_ERROR "Version tag has to always start with 'v'")
	ENDIF()

	STRING(LENGTH ${process_output} version_length)
	MATH(EXPR version_length_arg ${version_length}-2)
	STRING(SUBSTRING ${process_output} 1 ${version_length_arg} version_string)
	CMUTIL_VERSION_CHECK(${version_string})
	SET(${output_var} ${version_string} PARENT_SCOPE)

	CMUTIL_VERSION_SPLIT(v "${version_string}")
	SET(${output_var}_0 ${v_0} PARENT_SCOPE)
	SET(${output_var}_1 ${v_1} PARENT_SCOPE)
	SET(${output_var}_2 ${v_2} PARENT_SCOPE)
ENDFUNCTION()



##
#
# Split given 'version' into three parts called
#  - MAJOR, stored to <output_var>_MAJOR
#  - MINOR, stored to <output_var>_MINOR
#  - PATCH, stored_to <output_var>_PATCH
#
# <function> (
#		<output_var>
#		<version>
# )
#
FUNCTION(CMUTIL_VERSION_SPLIT output_var version)
	CMUTIL_VERSION_CHECK(${version})
	STRING(REPLACE "." ";" version_list ${version})
	LIST(GET version_list 0 _major)
	LIST(GET version_list 1 _minor)
	LIST(GET version_list 2 _patch)
	SET(${output_var}_MAJOR ${_major} PARENT_SCOPE)
	SET(${output_var}_MINOR ${_minor} PARENT_SCOPE)
	SET(${output_var}_PATCH ${_patch} PARENT_SCOPE)
	SET(${output_var} ${version_list} PARENT_SCOPE)
ENDFUNCTION()



##
#
# Locate ${CMAKE_CURRENT_LIST_DIR}/version.txt,
# read the first line and compare version stored in version.txt
# with ${version}.
#
# If versions does not match error occurres.
#
# <function>(
#		<version>
# )
#
FUNCTION(CMUTIL_VERSION_VALIDATE_VERSION_FILE_FOR version)
	SET(version_file ${ARGN})
	IF("${version_file}" STREQUAL "")
		SET(version_file "${CMAKE_CURRENT_SOURCE_DIR}/version.txt")
	ENDIF()

	CMUTIL_PROPERTY_FILE_READ("${version_file}" inject)
	IF(NOT inject_version)
		MESSAGE(FATAL_ERROR "${version_file} is not valid")
	ENDIF()
	CMUTIL_VERSION_CHECK(${inject_version})
	IF(NOT version STREQUAL inject_version)
		MESSAGE(FATAL_ERROR "${version_file} is not in sync with current branch (${version} vs. ${inject_version})")
	ENDIF()
ENDFUNCTION()



##
#
# Normalize version in the format of x.y.z to 00x00y00z (number of leading zeroes may vary)
#
# <function>(
#		OUT_VARIABLE	-	output variable
#		PROJECT_VERSION	-	input in the format of x.y.z
# 	)
#
FUNCTION(CMUTIL_VERSION_NORMALIZE OUT_VARIABLE _PROJECT_VERSION)
	CMUTIL_VERSION_CHECK(${_PROJECT_VERSION})
	CMUTIL_VERSION_SPLIT(version_list ${_PROJECT_VERSION})

	LIST(LENGTH version_list length)
	LIST(GET version_list 0 version_major)
	LIST(GET version_list 1 version_minor)
	LIST(GET version_list 2 version_patch)
	_CMUTIL_VERSION_ADD_PADDING(version_major_normalized 3 "0" "${version_major}")
	_CMUTIL_VERSION_ADD_PADDING(version_minor_normalized 3 "0" "${version_minor}")
	_CMUTIL_VERSION_ADD_PADDING(version_patch_normalized 3 "0" "${version_patch}")

	SET(project_version_normalized "${version_major_normalized}${version_minor_normalized}${version_patch_normalized}")
	SET(${OUT_VARIABLE} "${project_version_normalized}" PARENT_SCOPE)
ENDFUNCTION()



##
#
# <function> (
#		<out_var>
#		<repeat_count>
#		<char>
#		<version_part>
# )
#
FUNCTION(_CMUTIL_VERSION_ADD_PADDING out_var repeat_count char version_part)
	STRING(LENGTH "${version_part}" version_length)
	MATH(EXPR required_pads "${repeat_count} - ${version_length}")
	IF(required_pads LESS 0)
		MESSAGE(FATAL_ERROR "Cannot be padded")
	ENDIF()

	SET(pad ${version_part})
	MATH(EXPR required_minus_one "${required_pads} - 1")
	FOREACH(var RANGE ${required_minus_one})
		SET(pad "${char}${pad}")
	ENDFOREACH()
	SET(${out_var} "${pad}" PARENT_SCOPE)
ENDFUNCTION()
