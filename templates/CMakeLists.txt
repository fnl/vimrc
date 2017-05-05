CMAKE_MINIMUM_REQUIRED( VERSION 3.6 )
PROJECT( myproject )

SET( myproject_VERSION_MAJOR 1 )
SET( myproject_VERSION_MINOR 0 )
SET( CMAKE_CXX_STANDARD 14 )
SET( SOURCE_FILES main.cpp )
SET( Boost_INCLUDE_DIR /usr/local/Cellar/boost/1.63.0/include )
SET( Boost_LIBRARY_DIR /usr/local/Cellar/boost/1.63.0/lib )

CONFIGURE_FILE (
        "${PROJECT_SOURCE_DIR}/version.hpp.in"
        "${PROJECT_BINARY_DIR}/version.hpp"
)

FIND_PACKAGE(
        Boost 1.63 COMPONENTS
        log log_setup thread date_time system
        filesystem program_options
        REQUIRED
)
INCLUDE_DIRECTORIES(
        ${PROJECT_BINARY_DIR}
        ${Boost_INCLUDE_DIR}
)

ADD_EXECUTABLE( myproject ${SOURCE_FILES} )
ADD_DEFINITIONS( -DBOOST_LOG_DYN_LINK )

TARGET_LINK_LIBRARIES( myproject ${Boost_LIBRARIES} )
