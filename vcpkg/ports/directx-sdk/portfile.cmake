# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/fesily/DirectX-SDK/releases/download/1.0/DirectX-SDK.zip"
    FILENAME "DirectX-SDK.zip"
    SHA512  1066413cf35c9015010c92a9cd4e4cd6042b325a5123c58ca340f5338425319f6d915c16b5c99da61718fdecfcf2f709f86ab7c1537fe36bacf5769e55d57b1a
)
vcpkg_extract_source_archive(${ARCHIVE})
file(GLOB INCLUDE_LIST LIST_DIRECTORIES false "${SOURCE_PATH}/include/*.*")
file(INSTALL ${INCLUDE_LIST} DESTINATION ${CURRENT_PACKAGES_DIR}/include)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
message(FATAL_ERROR "not suport this target")
endif()
file(GLOB LIB_LIST LIST_DIRECTORIES false "${SOURCE_PATH}/lib/${VCPKG_TARGET_ARCHITECTURE}/*.*")
file(INSTALL 
    ${LIB_LIST} 
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/
    PATTERN "d3dx9.lib" EXCLUDE
    PATTERN "d3dx10.lib" EXCLUDE
    PATTERN "d3dx11.lib" EXCLUDE
    PATTERN "D3DCSX.lib" EXCLUDE
    PATTERN "xapobase.lib" EXCLUDE
)
file(INSTALL 
    ${LIB_LIST} 
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib/
    PATTERN "d3dx9d.lib" EXCLUDE
    PATTERN "d3dx10d.lib" EXCLUDE
    PATTERN "d3dx11d.lib" EXCLUDE
    PATTERN "D3DCSXd.lib" EXCLUDE
    PATTERN "xapobased.lib" EXCLUDE
)
file(INSTALL ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/directx-sdk RENAME copyright)
