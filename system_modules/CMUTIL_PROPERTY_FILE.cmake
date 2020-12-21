## Main
#
# Load and maintain Property file.
#
# [Definition]
# Each line in property file must be in format
#	<key>=<value>
# where key and value must not be empty.
#

IF(DEFINED CMUTIL_PROPERTY_FILE_MODULE)
	RETURN()
ENDIF()
SET(CMUTIL_PROPERTY_FILE_MODULE 1)



##
# Load key value pairs from ${path_to_file} with the given namespace.
# Each entry must follow the format "value=key" where
#	key   = "[^= ]+"
#	value = ".*"
# The result for entry "key=my nice =val" with namespace 'inject'
# is equivalent to SET(inject_key "my nice =val")
#
# <function> (
#		<path_to_file>
#		<namespace>
# )
#
FUNCTION(CMUTIL_PROPERTY_FILE_READ path_to_file namespace)
	FILE(STRINGS ${path_to_file} file_content)
	FOREACH(name_and_value ${file_content})
		STRING(REGEX REPLACE "^[ ]+" "" name_and_value ${name_and_value})
		STRING(REGEX MATCH "^[^=]+" name ${name_and_value})
		STRING(REPLACE "${name}=" "" value ${name_and_value})
		IF(NOT name OR NOT value)
			MESSAGE(WARNING "Ou, invalid key-value entry ${name_and_value} in file ${path_to_file}")
			CONTINUE()
		ENDIF()
		SET(${namespace}_${name} "${value}" PARENT_SCOPE)
	ENDFOREACH()
ENDFUNCTION()

