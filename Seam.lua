Class = require("Utilities.Class")

Enum = require("Utilities.Enum")
require("Other.Enums")

Log = require("Utilities.Log")
FileSystem = require("Utilities.FileSystem")

Object = require("Objects.Object")

Project = require("Objects.Project")
CProject = require("Objects.CProject")

Application = require("Objects.Application")
Library = require("Objects.Library")

Seam = {}

Seam.Options = {
	gcc = {
		DataType = Enum.OptionDataType.String,
		Default = "gcc"
	},

	ar = {
		DataType = Enum.OptionDataType.String,
		Default = "ar"
	},

	bash = {
		DataType = Enum.OptionDataType.String,
		Default = "bash"
	}
}

function Seam.Assert(condition, errorCode, ...)
    if not condition then
        Log.Critical(...)
        os.exit(errorCode, true)
    end
end

function Seam.GetScriptFolder()
	return FileSystem.Format(string.match(string.sub(debug.getinfo(2, "S").source, 2), "^(.+[\\/])"))
end

function Seam.UpdateOptions(arguments)
	for _, argument in ipairs(arguments) do
		if string.sub(argument, 1, 2) == "--" then
			local equalIndex = string.find(argument, "=", 1, true)
			local configuration
			local valueString

			if equalIndex then
				configuration = Seam.Options[string.sub(argument, 3, equalIndex - 1)]
				valueString = string.sub(argument, equalIndex + 1)
			else
				configuration = Seam.Options[string.sub(argument, 3)]
			end
			
			if configuration then
				local dataType = configuration.DataType

				if dataType == Enum.OptionDataType.String then
					configuration.Value = valueString
				elseif dataType == Enum.OptionDataType.Boolean then
					configuration.Value = true
				elseif dataType == Enum.OptionDataType.Number then
					configuration.Value = tonumber(valueString)
				elseif dataType == Enum.OptionDataType.Enum then
					configuration.Value = configuration.Enum[valueString]
				elseif dataType == Enum.OptionDataType.Path then
					configuration.Value = FileSystem.Format(valueString)
				end
			end
		end
	end

	for name, configuration in pairs(Seam.Options) do
		if configuration.Value == nil then
			if configuration.DataType ~= Enum.OptionDataType.Boolean then
				Seam.Assert(
					not configuration.Required,
					Enum.ErrorCode.MissingRequiredOption,
					Enum.LogCategory.Option,
					"Missing required option \"%s\"!",
					name
				)
			end
			
			configuration.Value = configuration.Default
		end
	end
end

function Seam.Execute(command, mode)
	local finalCommand = Seam.Options.bash.Value.." -c \""..string.gsub(command, "\"", "\\\"").."\""

	if mode == Enum.ExecutionMode.Execute then
		return os.execute(finalCommand)
	else
		return io.popen(finalCommand, mode)
	end
end

if jit.arch == "x86" then
    Seam.Architecture = Enum.Architecture.x86
elseif jit.arch == "x64" then
    Seam.Architecture = Enum.Architecture.x64
elseif jit.arch == "arm" then
    Seam.Architecture = Enum.Architecture.Arm
elseif jit.arch == "arm64" then
    Seam.Architecture = Enum.Architecture.Arm64
else
    Seam.Architecture = Enum.Architecture.Unknown
end

if jit.os == "Windows" then
    Seam.OS = Enum.OS.Windows
elseif jit.os == "Linux" then
    Seam.OS = Enum.OS.Linux
else
    Seam.OS = Enum.OS.Unknown
end

Seam.UpdateOptions(arg)

Log.Info(Enum.LogCategory.Seam, "Seam initialised")

return Seam