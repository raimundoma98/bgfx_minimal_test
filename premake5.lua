-- premake5.lua
local BGFX_DIR = "3rdparty/bgfx"
local BIMG_DIR = "3rdparty/bimg"
local BX_DIR = "3rdparty/bx"
local GLFW_DIR = "3rdparty/glfw"

function setBxCompat()
	filter "action:vs*"
		includedirs { path.join(BX_DIR, "include/compat/msvc") }
	filter { "system:windows", "action:gmake" }
		includedirs { path.join(BX_DIR, "include/compat/mingw") }
end

workspace "bgfx_test"
    configurations { "Debug", "Release" }
    platforms { "Win64", "arm64" }
    targetdir "bin/%{cfg.platform}/%{cfg.buildcfg}"
    location "build/%{_ACTION}"
    startproject "HelloWorld"
    filter "platforms:Win64"
        system "windows"
        architecture "x86_64"
    filter "platforms:arm64"
        system "linux"
        architecture "ARM64"
		toolset "gcc"
		defines { "BGFX_CONFIG_RENDERER_DIRECT3D11=0" }
    filter "configurations:Debug"
        defines { "DEBUG", "BX_CONFIG_DEBUG=1" }
        symbols "On"
    filter "configurations:Release"
        defines { "NDEBUG", "BX_CONFIG_DEBUG=0" }
        optimize "Full"
	filter "action:vs*"
    	buildoptions {
        "/Zc:__cplusplus",
        "/Zc:preprocessor"
    	}
	--filter { "platforms:arm64", "action:gmake", "system:linux" }
	--	buildoptions { "-march=armv8-a", "-mtune=cortex-a53", "--sysroot=/user/aarch64-linux-gnu" }
	--	linkoptions { "--sysroot=/usr/aarch64-linux-gnu" }

project "HelloWorld"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++20"
    files { "include/**.h", "src/**.cpp" }
    includedirs {
        "include/",
        path.join(BGFX_DIR, "include"),
		path.join(BX_DIR, "include"),
		path.join(GLFW_DIR, "include")
    }
    links { "bgfx", "bimg", "bx", "glfw" }
    filter "system:windows"
		links { "gdi32", "kernel32", "psapi" }
	filter "system:linux"
		links { "dl", "GL", "pthread", "X11" }
	setBxCompat()

project "bgfx"
    kind "StaticLib"
    language "C++"
	cppdialect "C++20"
    exceptionhandling "Off"
	rtti "Off"
	defines "__STDC_FORMAT_MACROS"
	files {
		path.join(BGFX_DIR, "include/bgfx/**.h"),
		path.join(BGFX_DIR, "src/*.cpp"),
		path.join(BGFX_DIR, "src/*.h"),
	}
	excludes {
		path.join(BGFX_DIR, "src/amalgamated.cpp"),
	}
	includedirs {
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include"),
		path.join(BGFX_DIR, "include"),
		path.join(BGFX_DIR, "3rdparty"),
		path.join(BGFX_DIR, "3rdparty/dxsdk/include"),
		path.join(BGFX_DIR, "3rdparty/khronos")
	}
	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"
		excludes {
			path.join(BGFX_DIR, "src/glcontext_glx.cpp"),
			path.join(BGFX_DIR, "src/glcontext_egl.cpp")
		}
	filter "system:windows"
		includedirs {
			path.join(BGFX_DIR, "3rdparty/directx-headers/include/directx"),
		}
	filter "system:linux"
		includedirs {
			path.join(BGFX_DIR, "3rdparty/directx-headers/include/directx"),
			path.join(BGFX_DIR, "3rdparty/directx-headers/include"),
			path.join(BGFX_DIR, "3rdparty/directx-headers/include/wsl/stubs"),
		}
	setBxCompat()

project "bimg"
	kind "StaticLib"
	language "C++"
	cppdialect "C++20"
	exceptionhandling "Off"
	rtti "Off"
	files {
		path.join(BIMG_DIR, "include/bimg/*.h"),
		path.join(BIMG_DIR, "src/image.cpp"),
		path.join(BIMG_DIR, "src/image_gnf.cpp"),
		path.join(BIMG_DIR, "src/*.h"),
		path.join(BIMG_DIR, "3rdparty/astc-encoder/source/*.cpp"),
		path.join(BIMG_DIR, "3rdparty/astc-encoder/source/*.h")
	}
	includedirs {
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include"),
		path.join(BIMG_DIR, "3rdparty/astc-encoder"),
		path.join(BIMG_DIR, "3rdparty/astc-encoder/include"),
	}
	setBxCompat()

project "bx"
	kind "StaticLib"
	language "C++"
	cppdialect "C++20"
	exceptionhandling "Off"
	rtti "Off"
	defines "__STDC_FORMAT_MACROS"
	files {
		path.join(BX_DIR, "include/bx/*.h"),
		path.join(BX_DIR, "include/bx/inline/*.inl"),
		path.join(BX_DIR, "src/*.cpp")
	}
	excludes {
		path.join(BX_DIR, "src/amalgamated.cpp"),
		path.join(BX_DIR, "src/crtnone.cpp")
	}
    includedirs {
		path.join(BX_DIR, "3rdparty"),
		path.join(BX_DIR, "include")
	}
	filter "configurations:Release"
		defines "BX_CONFIG_DEBUG=0"
	filter "configurations:Debug"
		defines "BX_CONFIG_DEBUG=1"
	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"
	setBxCompat()

project "glfw"
	kind "StaticLib"
	language "C"
	files {
		path.join(GLFW_DIR, "include/GLFW/*.h"),
		path.join(GLFW_DIR, "src/context.c"),
		path.join(GLFW_DIR, "src/egl_context.*"),
		path.join(GLFW_DIR, "src/init.c"),
		path.join(GLFW_DIR, "src/input.c"),
		path.join(GLFW_DIR, "src/internal.h"),
		path.join(GLFW_DIR, "src/monitor.c"),
		path.join(GLFW_DIR, "src/null*.*"),
		path.join(GLFW_DIR, "src/osmesa_context.*"),
		path.join(GLFW_DIR, "src/platform.c"),
		path.join(GLFW_DIR, "src/vulkan.c"),
		path.join(GLFW_DIR, "src/window.c"),
	}
	includedirs { path.join(GLFW_DIR, "include") }
	filter "system:windows"
		defines "_GLFW_WIN32"
		files {
			path.join(GLFW_DIR, "src/win32_*.*"),
			path.join(GLFW_DIR, "src/wgl_context.*")
		}
	filter "system:linux"
		defines "_GLFW_X11"
		files {
			path.join(GLFW_DIR, "src/glx_context.*"),
			path.join(GLFW_DIR, "src/linux*.*"),
			path.join(GLFW_DIR, "src/posix*.*"),
			path.join(GLFW_DIR, "src/x11*.*"),
			path.join(GLFW_DIR, "src/xkb*.*")
		}
	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"