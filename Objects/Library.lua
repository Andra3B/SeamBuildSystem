local CProject = require("Objects.CProject")
local Library = {}

function Library.Create(name)
    local self = Class.CreateInstance(CProject.Create(name), Library)

	self._BuildOutput = self._BuildFolder..name..".a"

    return self
end

function Library:Build()
	if self._Built then return true end

	Log.Info(Enum.LogCategory.Library, "Building %s", self._Name)
	local success = FileSystem.Create(self._BuildFolder) and self:PreBuild()

	if success then
		local includeOptions = ""

		for _, header in ipairs(self._PrivateHeaders) do
			includeOptions = includeOptions.." -I \""..header.."\""
		end

		for _, header in ipairs(self._PublicHeaders) do
			includeOptions = includeOptions.." -I \""..header.."\""
		end

		for _, dependency in ipairs(self:GetDependencyTraversalOrder()) do
			success = dependency:Build()

			if success then
				for _, header in ipairs(dependency._PublicHeaders) do
					includeOptions = includeOptions.." -I \""..header.."\""
				end
			else
				break
			end
		end

		if success then
			local objectFileTable = {}
			local objectFiles = ""
			
			for _, source in ipairs(self._Sources) do
				local object = string.match(source, "(.*)%.")..".o"
				table.insert(objectFileTable, object)
				object = " \""..object.."\""
				objectFiles = objectFiles..object


				if Seam.Execute(
					Seam.Options.gcc.Value.." -c "..self._AdditionalCompilerOptions..includeOptions.." \""..source.."\" -o"..object,
					Enum.ExecutionMode.Execute
				) ~= 0 then
					success = false

					break
				end
			end

			success = success and Seam.Execute(
				Seam.Options.ar.Value.." rcs \""..self._BuildOutput.."\""..objectFiles,
				Enum.ExecutionMode.Execute
			) == 0

			for _, object in ipairs(objectFileTable) do
				FileSystem.Destroy(object)
			end

			if success then
				self._Built = true
			end
		end
	end

	if success and self:PostBuild() then
		Log.Info(Enum.LogCategory.Library, "Built %s", self._Name)

		return true
	else
		Log.Critical(Enum.LogCategory.Library, "Failed to build %s", self._Name)

		return false
	end
end

return Class.CreateClass(Library, "Library", CProject)