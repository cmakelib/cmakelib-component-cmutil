
# CMake-lib utils component

Linux: ![buildbadge_github], Windows: ![buildbadge_github], Mac OS: ![buildbadge_github]

Provide mixed functionality for other CMake-lib components

List of functionality

- [CMUTIL_NORMALIZE_GIT_URI.cmake] - normalize Git URIs between SSH and HTTP formats
- [CMUTIL_PROPERTY_FILE.cmake] - read properties in form "<key>=<value>" from a file
- [CMUTIL_TRAIT.cmake] - ensure that the given traits are met
- [CMUTIL_VERSION.cmake] - version manipulation

## Requirements

CMUTIL is intended to be used thru [CMLIB].

CMUTIL is not supposed to be used separately.

To use the component install [CMLIB] and call `FIND_PACKAGE(CMLIB COMPONENTS CMUTIL)`.

## License

Project is licensed under [MIT](LICENSE)



[CMUTIL_NORMALIZE_GIT_URI.cmake]: ./system_modules/CMUTIL_NORMALIZE_GIT_URI.cmake
[CMUTIL_PROPERTY_FILE.cmake]:     ./system_modules/CMUTIL_PROPERTY_FILE.cmake
[CMUTIL_VERSION.cmake]:           ./system_modules/CMUTIL_VERSION.cmake
[CMUTIL_TRAIT.cmake]:             ./system_modules/CMUTIL_TRAIT.cmake
[CMLIB]:                          https://github.com/cmakelib/cmakelib
[buildbadge_github]:              https://github.com/cmakelib/cmakelib-component-util/workflows/Tests/badge.svg
