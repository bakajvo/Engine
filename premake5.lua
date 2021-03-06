workspace "Engine"
    architecture "x64"
	startproject "Sandbox"

    configurations {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Engine/vendor/GLFW/include"
IncludeDir["Glad"] = "Engine/vendor/Glad/include"
IncludeDir["ImGui"] = "Engine/vendor/imgui"
IncludeDir["glm"] = "Engine/vendor/glm"

group "Dependencies"
	include "Engine/vendor/GLFW"
	include "Engine/vendor/Glad"
	include "Engine/vendor/imgui"

group ""

project "Engine"
    location "Engine"
    kind "StaticLib"
    language "C++"
	cppdialect "C++17"
    staticruntime "On"

    targetdir ("bin/"..outputdir.."/%{prj.name}")
    objdir ("bin-int/"..outputdir.."/%{prj.name}")

	pchheader "engpch.h"
	pchsource "Engine/src/engpch.cpp"

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl"
    }

    includedirs {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
    }

	links {
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}

    filter "system:windows"
        systemversion "latest"

        defines {
            "ENG_PLATFORM_WINDOWS",
            "ENG_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
        }

        postbuildcommands {
            ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
        }
    
    filter "configurations:Debug"
        defines "ENG_DEBUG"
		runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "ENG_RELEASE"
		runtime "Release"
        optimize "On"
    
    filter "configurations:Dist"
        defines "ENG_DIST"
		runtime "Release"
        optimize "On"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
	cppdialect "C++17"
	staticruntime "on"

    targetdir ("bin/"..outputdir.."/%{prj.name}")
    objdir ("bin-int/"..outputdir.."/%{prj.name}")

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "Engine/vendor/spdlog/include",
        "Engine/src",
		"%{IncludeDir.glm}"

    }

    links {
        "Engine"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines {
            "ENG_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "ENG_DEBUG"
		runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "ENG_RELEASE"
		runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "ENG_DIST"
		runtime "Release"
        optimize "On"