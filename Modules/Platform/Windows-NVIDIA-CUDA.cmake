include(Platform/Windows-MSVC)

set(CMAKE_CUDA_COMPILE_PTX_COMPILATION
  "<CMAKE_CUDA_COMPILER> ${CMAKE_CUDA_HOST_FLAGS} <DEFINES> <INCLUDES> <FLAGS> -x cu -ptx <SOURCE> -o <OBJECT> -Xcompiler=-Fd<TARGET_COMPILE_PDB>,-FS")
set(CMAKE_CUDA_COMPILE_SEPARABLE_COMPILATION
  "<CMAKE_CUDA_COMPILER> ${CMAKE_CUDA_HOST_FLAGS} <DEFINES> <INCLUDES> <FLAGS> -x cu -dc <SOURCE> -o <OBJECT> -Xcompiler=-Fd<TARGET_COMPILE_PDB>,-FS")
set(CMAKE_CUDA_COMPILE_WHOLE_COMPILATION
  "<CMAKE_CUDA_COMPILER> ${CMAKE_CUDA_HOST_FLAGS} <DEFINES> <INCLUDES> <FLAGS> -x cu -c <SOURCE> -o <OBJECT> -Xcompiler=-Fd<TARGET_COMPILE_PDB>,-FS")

set(__IMPLICT_LINKS )
foreach(dir ${CMAKE_CUDA_HOST_IMPLICIT_LINK_DIRECTORIES})
  string(APPEND __IMPLICT_LINKS " -LIBPATH:\"${dir}\"")
endforeach()
foreach(lib ${CMAKE_CUDA_HOST_IMPLICIT_LINK_LIBRARIES})
  string(APPEND __IMPLICT_LINKS " \"${lib}\"")
endforeach()
set(CMAKE_CUDA_LINK_EXECUTABLE
   "<CMAKE_CUDA_HOST_LINK_LAUNCHER> <CMAKE_CUDA_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> /implib:<TARGET_IMPLIB> /pdb:<TARGET_PDB> /version:<TARGET_VERSION_MAJOR>.<TARGET_VERSION_MINOR> <LINK_LIBRARIES>${__IMPLICT_LINKS}")

set(_CMAKE_VS_LINK_DLL "<CMAKE_COMMAND> -E vs_link_dll --intdir=<OBJECT_DIR> --manifests <MANIFESTS> -- ")
set(_CMAKE_VS_LINK_EXE "<CMAKE_COMMAND> -E vs_link_exe --intdir=<OBJECT_DIR> --manifests <MANIFESTS> -- ")
set(CMAKE_CUDA_CREATE_SHARED_LIBRARY
  "${_CMAKE_VS_LINK_DLL}<CMAKE_LINKER> ${CMAKE_CL_NOLOGO} <OBJECTS> ${CMAKE_START_TEMP_FILE} /out:<TARGET> /implib:<TARGET_IMPLIB> /pdb:<TARGET_PDB> /dll /version:<TARGET_VERSION_MAJOR>.<TARGET_VERSION_MINOR>${_PLATFORM_LINK_FLAGS} <LINK_FLAGS> <LINK_LIBRARIES>${__IMPLICT_LINKS} ${CMAKE_END_TEMP_FILE}")

set(CMAKE_CUDA_CREATE_SHARED_MODULE ${CMAKE_CUDA_CREATE_SHARED_LIBRARY})
set(CMAKE_CUDA_CREATE_STATIC_LIBRARY  "<CMAKE_LINKER> /lib ${CMAKE_CL_NOLOGO} <LINK_FLAGS> /out:<TARGET> <OBJECTS> ")
set(CMAKE_CUDA_LINKER_SUPPORTS_PDB ON)
set(CMAKE_CUDA_LINK_EXECUTABLE
  "${_CMAKE_VS_LINK_EXE}<CMAKE_LINKER> ${CMAKE_CL_NOLOGO} <OBJECTS> ${CMAKE_START_TEMP_FILE} /out:<TARGET> /implib:<TARGET_IMPLIB> /pdb:<TARGET_PDB> /version:<TARGET_VERSION_MAJOR>.<TARGET_VERSION_MINOR>${_PLATFORM_LINK_FLAGS} <CMAKE_CUDA_LINK_FLAGS> <LINK_FLAGS> <LINK_LIBRARIES>${__IMPLICT_LINKS} ${CMAKE_END_TEMP_FILE}")
unset(_CMAKE_VS_LINK_EXE)
unset(_CMAKE_VS_LINK_EXE)

set(CMAKE_CUDA_DEVICE_LINK_LIBRARY
  "<CMAKE_CUDA_COMPILER> <CMAKE_CUDA_LINK_FLAGS> <LANGUAGE_COMPILE_FLAGS> -shared -dlink <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -Xcompiler=-Fd<TARGET_COMPILE_PDB>,-FS")
set(CMAKE_CUDA_DEVICE_LINK_EXECUTABLE
  "<CMAKE_CUDA_COMPILER> <CMAKE_CUDA_LINK_FLAGS> -shared -dlink <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -Xcompiler=-Fd<TARGET_COMPILE_PDB>,-FS")

string(APPEND CMAKE_CUDA_FLAGS_INIT " -Xcompiler=-GR,-EHsc")
string(APPEND CMAKE_CUDA_FLAGS_DEBUG_INIT " -Xcompiler=-MDd,-Zi,-RTC1")
string(APPEND CMAKE_CUDA_FLAGS_RELEASE_INIT " -Xcompiler=-MD")
string(APPEND CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT " -Xcompiler=-MD")
string(APPEND CMAKE_CUDA_FLAGS_MINSIZEREL_INIT " -Xcompiler=-MD")
