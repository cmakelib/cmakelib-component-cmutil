## Main
#
# Normalize Git URI to HTTP or SSH format compatible with
# all major Git hosting services like Github, Gitlab, Bitbucket, etc.
#
# [Definition]
# Git URIs can be in two main formats:
#   SSH format:   git@hostname:path/to/repo.git
#   HTTP format:  https://hostname/path/to/repo.git
#
# This module provides functionality to convert between these formats
# while preserving all path information and handling edge cases like
# port numbers and repositories without .git extension.
#

IF(DEFINED CMUTIL_NORMALIZE_GIT_URI_MODULE)
	RETURN()
ENDIF()
SET(CMUTIL_NORMALIZE_GIT_URI_MODULE 1)

FIND_PACKAGE(CMLIB)



##
# Normalize Git URI to specified target format (SSH or HTTP).
#
# Converts Git URIs between SSH and HTTP formats:
#   SSH format:   git@hostname:path/to/repo.git
#   HTTP format:  https://hostname/path/to/repo.git
#
# If the input URI is already in the target format, it is returned unchanged.
# Supports complex paths, custom domains, port numbers, and repositories
# without .git extension.
#
# <function>(
#		URI <git_uri>
#		TARGET_TYPE <SSH|HTTP>
#		OUTPUT_VAR <output_variable>
# )
FUNCTION(CMUTIL_NORMALIZE_GIT_URI)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            URI
            TARGET_TYPE
            OUTPUT_VAR
        REQUIRED
            URI
            TARGET_TYPE
            OUTPUT_VAR
        P_ARGN ${ARGN}
    )

    SET(output_value)
    IF(__TARGET_TYPE STREQUAL "SSH")
        _CMUTIL_NORMALIZE_GIT_URI_SSH(
            URI        "${__URI}"
            OUTPUT_VAR _var
        )
        SET(output_value "${_var}")
    ELSEIF(__TARGET_TYPE STREQUAL "HTTP")
        _CMUTIL_NORMALIZE_GIT_URI_HTTP(
            URI        "${__URI}"
            OUTPUT_VAR _var
        )
        SET(output_value "${_var}")
    ELSE()
        MESSAGE(FATAL_ERROR "Invalid TARGET_TYPE '${__TARGET_TYPE}'")
    ENDIF()

    SET(${__OUTPUT_VAR} "${output_value}" PARENT_SCOPE)
ENDFUNCTION()



## Helper
#
# Converts HTTP(S) Git URIs to SSH format.
# If URI is already in SSH format, returns it unchanged.
#
# Transformation examples:
#   https://github.com/user/repo.git --> git@github.com:user/repo.git
#   https://gitlab.com/user/repo.git --> git@gitlab.com:user/repo.git
#   git@gitlab.com:user/repo.git     --> git@gitlab.com:user/repo.git (unchanged)
#
# <function>(
#		URI <uri>
#		OUTPUT_VAR <output_variable>
# )
#
FUNCTION(_CMUTIL_NORMALIZE_GIT_URI_SSH)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            URI
            OUTPUT_VAR
        REQUIRED
            URI
            OUTPUT_VAR
        P_ARGN ${ARGN}
    )

    SET(uri "${__URI}")

    STRING(REGEX MATCH "^git@.*" git_ssh_uri "${uri}")
    IF(git_ssh_uri)
        SET(${__OUTPUT_VAR} "${uri}" PARENT_SCOPE)
        RETURN()
    ENDIF()

    STRING(REGEX MATCH "^https?://" git_http_uri "${uri}")
    IF(NOT git_http_uri)
        MESSAGE(FATAL_ERROR "URI '${uri}' is not a valid HTTP(S) or git@ Git URI")
    ENDIF()

    STRING(REGEX MATCH "^https?://([^/]+)/(.+)$" http_match "${uri}")
    IF(NOT http_match)
        MESSAGE(FATAL_ERROR "URI '${uri}' is not a valid HTTP(S) or git@ Git URI")
    ENDIF()

    STRING(REGEX REPLACE "^https?://([^/]+)/(.+)$" "\\1" hostname "${uri}")
    STRING(REGEX REPLACE "^https?://([^/]+)/(.+)$" "\\2" path "${uri}")

    SET(ssh_uri "git@${hostname}:${path}")
    SET(${__OUTPUT_VAR} "${ssh_uri}" PARENT_SCOPE)
ENDFUNCTION()



## Helper
#
# Converts SSH Git URIs to HTTPS format.
# If URI is already in HTTP(S) format, returns it unchanged.
#
# Transformation examples:
#   git@github.com:user/repo.git     --> https://github.com/user/repo.git
#   git@gitlab.com:user/repo.git     --> https://gitlab.com/user/repo.git
#   https://github.com/user/repo.git --> https://github.com/user/repo.git (unchanged)
#
# <function>(
#		URI <uri>
#		OUTPUT_VAR <output_variable>
# )
#
FUNCTION(_CMUTIL_NORMALIZE_GIT_URI_HTTP)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            URI
            OUTPUT_VAR
        REQUIRED
            URI
            OUTPUT_VAR
        P_ARGN ${ARGN}
    )

    SET(uri "${__URI}")

    STRING(REGEX MATCH "^https?://" git_http_uri "${uri}")
    IF(git_http_uri)
        SET(${__OUTPUT_VAR} "${uri}" PARENT_SCOPE)
        RETURN()
    ENDIF()

    STRING(REGEX MATCH "^git@.*" git_ssh_uri "${uri}")
    IF(NOT git_ssh_uri)
        MESSAGE(FATAL_ERROR "URI '${uri}' is not a valid git@ or HTTP(S) Git URI")
    ENDIF()

    STRING(REGEX MATCH "^git@([^:]+):(.+)$" ssh_match "${uri}")
    IF(NOT ssh_match)
        MESSAGE(FATAL_ERROR "URI '${uri}' is not a valid git@ or HTTP(S) Git URI")
    ENDIF()

    STRING(REGEX REPLACE "^git@([^:]+):(.+)$" "\\1" hostname "${uri}")
    STRING(REGEX REPLACE "^git@([^:]+):(.+)$" "\\2" path "${uri}")

    SET(https_uri "https://${hostname}/${path}")
    SET(${__OUTPUT_VAR} "${https_uri}" PARENT_SCOPE)
ENDFUNCTION()

