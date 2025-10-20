-- So require can find Seam.lua
package.path = package.path..";../../?.lua"
-- Setup the build system
require("Seam")

-- Creates the application project
local MainApplication = Application.Create("Main")

-- Creates the static library project
local MathLibrary = Library.Create("Maths")

-- Add the sources files that make up the application project
MainApplication:AddSource("Application/App.c")

-- Add the sources files that make up the library project
MathLibrary:AddSource("Maths/Sources/", nil, "*.c")
MathLibrary:AddHeader("Maths/Headers/", false)

-- Add MathLibrary as a dependency of MainApplication
MainApplication:AddDependency(MathLibrary)

-- Some additional compiler options used when the project is built
MainApplication.AdditionalCompilerOptions = "-Wall -std=c11 -O2"
MathLibrary.AdditionalCompilerOptions = "-Wall -std=c11 -O2"

-- Build the executable
MainApplication:Build()