-- So require can find Seam.lua
package.path = package.path..";../../?.lua"
-- Setup the build system
require("Seam")

-- Creates a simple application project
local MainApplication = Application.Create("Main")

-- Add the sources files that make up the project
MainApplication:AddSource("Sources/", nil, "*.c")

-- Add any include folders needed by the project
MainApplication:AddHeader("Headers/", true)

-- Some additional compiler options used when the project is built
MainApplication.AdditionalCompilerOptions = "-Wall -std=c11 -O2"

-- Build the executable
MainApplication:Build()