## Main
#
# Platform string maintenance
#

IF(DEFINED CMUTIL_PLATFORM_STRING_MODULE)
	RETURN()
ENDIF()
SET(CMUTIL_PROPERTY_FILE_MODULE_MODULE 1)





##
#
# Function constructs a Platfrom string
#
# <function>(
#   MACHINE           <machine>
#   DISTRO_NAME_ID    <distro_name_id>
#   DISTRO_VERSION_ID <distro_version_id>
# )
#
FUNCTION(CMUTIL_PLATFORM_STRING_CONSTRUCT)
	CMLIB_PARSE_ARGUMENTS(
		ONE_VALUE
			MACHINE
            DISTRO_VERSION_ID
            DISTRO_NAME_ID
            OUTPUT_VAR
		REQUIRED
			MACHINE
            DISTRO_VERSION_ID
            DISTRO_NAME_ID
            OUTPUT_VAR
		P_ARGN ${ARGN}
	)

    STRING(REGEX MATCH "^([0-9a-z-])+$" machine_ok "${__MACHINE}")
    IF(NOT machine_ok)
        MESSAGE(FATAL_ERROR "Invalid machine: ${__MACHINE}")
    ENDIF()
    SET(${__OUTPUT_VAR} "${__MACHINE}-${__DISTRO_NAME_ID}-${__DISTRO_VERSION_ID}" PARENT_SCOPE)
ENDFUNCTION()