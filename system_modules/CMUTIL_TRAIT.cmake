## Main
#
# Trait is something which has to be true!
# Otherwise FATAL_ERROR occur
#

IF(DEFINED CMUTIL_TRAIT_MODULE)
	RETURN()
ENDIF()
SET(CMUTIL_TRAIT_MODULE 1)

FIND_PACKAGE(CMLIB)



##
# Check if all elements from array VALUES
# can be found in array ${ARRAY}
#
# <function> (
#		ARRAY  <array_name>
#		VALUES <values> M
#		DESCRIPTION <description>
# )
#
FUNCTION(CMUTIL_TRAIT_IN_ARRAY)
	CMLIB_PARSE_ARGUMENTS(
		MULTI_VALUE
			VALUES
			ARRAY
		ONE_VALUE
			DESCRIPTION
		REQUIRED
			DESCRIPTION
			VALUES
			ARRAY
		P_ARGN ${ARGN}
	)
	IF("${__DESCRIPTION}" STREQUAL "")
		MESSAGE(FATAL_ERROR "Description cannot be empty")
	ENDIF()
	FOREACH(element IN LISTS __VALUES)
		LIST(FIND ${__ARRAY} ${element} in_array)
		IF(in_array EQUAL -1)
			LIST(JOIN ${__ARRAY} "," array_join)
			MESSAGE(FATAL_ERROR "${description} - element '${element}' is not in array '${array_join}'")
		ENDIF()
	ENDFOREACH()
ENDFUNCTION()
