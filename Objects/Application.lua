local CProject = require("Objects.CProject")
local Application = {}

function Application.Create(name)
    local self = Class.CreateInstance(CProject.Create(name), Application)

	self._BuildOutput = self._BuildFolder..name..(Seam.OS == Enum.OS.Windows and ".exe" or "")

    return self
end

function Application:GetBuildOutput()
	return self:GetBuildOutput()..self._Name..".exe"
end

function Application:Build()
	if self._Built then return true end

	Log.Info(Enum.LogCategory.Application, "Building %s", self._Name)
	local success = FileSystem.Create(self._BuildFolder) and self:PreBuild()

	if success then
		local sourceFiles = ""
		local linkLibraries = ""
		local includeOptions = ""

		for _, source in ipairs(self._Sources) do
			sourceFiles = sourceFiles.." \""..source.."\""
		end

		for _, header in ipairs(self._PrivateHeaders) do
			includeOptions = includeOptions.." -I \""..header.."\""
		end

		for _, header in ipairs(self._PublicHeaders) do
			includeOptions = includeOptions.." -I \""..header.."\""
		end

		for _, dependency in ipairs(self:GetDependencyTraversalOrder()) do
			success = dependency:Build()

			if success then
				if Class.IsA(dependency, "Library") then
					linkLibraries = linkLibraries.." \""..dependency._BuildOutput.."\""
				end

				for _, header in ipairs(dependency._PublicHeaders) do
					includeOptions = includeOptions.." -I \""..header.."\""
				end
			else
				break
			end
		end

		success = success and Seam.Execute(
			Seam.Options.gcc.Value.." "..self._AdditionalCompilerOptions..includeOptions..sourceFiles..linkLibraries.." -o \""..self._BuildOutput.."\"",
			Enum.ExecutionMode.Execute
		) == 0

		if success then
			self._Built = true
		end
	end

	if success and self:PostBuild() then
		Log.Info(Enum.LogCategory.Application, "Built %s", self._Name)

		return true
	else
		Log.Critical(Enum.LogCategory.Application, "Failed to build %s", self._Name)

		return false
	end
end

return Class.CreateClass(Application, "Application", CProject)