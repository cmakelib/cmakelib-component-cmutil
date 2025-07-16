IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
	CMAKE_MINIMUM_REQUIRED(VERSION 3.18)
	PROJECT(CMUTIL_NORMALIZE_GIT_URI_TEST)
ENDIF()

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../")

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../TEST.cmake")

FIND_PACKAGE(CMUTIL)



FUNCTION(TEST_SSH_TARGET_TYPE)
	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://github.com/username/repository.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@github.com:username/repository.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://gitlab.com/user/repo.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@gitlab.com:user/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "http://example.com/path/to/repo.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@example.com:path/to/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@github.com:user/repo.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@github.com:user/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://gitlab.example.com/group/subgroup/project.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@gitlab.example.com:group/subgroup/project.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://github.com/user/repo"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@github.com:user/repo")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://git.example.com:8080/user/repo.git"
		TARGET_TYPE "SSH"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "git@git.example.com:8080:user/repo.git")
ENDFUNCTION()



FUNCTION(TEST_HTTP_TARGET_TYPE)
	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@github.com:username/repository.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://github.com/username/repository.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@gitlab.com:user/repo.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://gitlab.com/user/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@example.com:path/to/repo.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://example.com/path/to/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "https://github.com/user/repo.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://github.com/user/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "http://example.com/user/repo.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "http://example.com/user/repo.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@gitlab.example.com:group/subgroup/project.git"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://gitlab.example.com/group/subgroup/project.git")

	CMUTIL_NORMALIZE_GIT_URI(
		URI "git@github.com:user/repo"
		TARGET_TYPE "HTTP"
		OUTPUT_VAR result
	)
	TEST_VAR_EQUALS_LITERAL(result "https://github.com/user/repo")
ENDFUNCTION()

TEST_SSH_TARGET_TYPE()
TEST_HTTP_TARGET_TYPE()

TEST_RUN("fail/")
