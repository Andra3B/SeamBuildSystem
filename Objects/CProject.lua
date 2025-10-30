local CProject = {}

function CProject.Create(name)
	local self = Class.CreateInstance(Project.Create(name), CProject)

	self._Sources = {}

	self._PublicHeaders = {}
	self._PrivateHeaders = {}

	self._Built = false

	self._BuildFolder = FileSystem.Format("Build/"..name)
	self._BuildOutput = self._BuildFolder

	self._AdditionalCompilerOptions = ""

	return self
end

function CProject:IsBuilt()
	return self._Built
end

function CProject:PreBuild()
	return true
end

function CProject:Build()
	if self._Built then return true end

	local success = self:PreBuild()

	self._Built = true
	
	return success and self:PostBuild()
end

function CProject:PostBuild()
	return true
end

function CProject:GetBuildFolder()
	return self._BuildFolder
end

function CProject:SetBuildFolder(folder)
	self._BuildFolder = folder
end

function CProject:GetBuildOutput()
	return self._BuildOutput
end

function CProject:SetBuildOutput(output)
	self._BuildOutput = output
end

function CProject:GetAdditionalCompilerOptions()
	return self._AdditionalCompilerOptions
end

function CProject:SetAdditionalCompilerOptions(options)
	self._AdditionalCompilerOptions = options
end

function CProject:GetSources()
	return self._Sources
end

function CProject:GetPublicHeaders()
    return self._PublicHeaders
end

function CProject:GetPrivateHeaders()
	return self._PrivateHeaders
end

function CProject:AddHeader(path, private)
	local pathDetails = FileSystem.GetDetails(path)

	if pathDetails.Exists and pathDetails.Type == Enum.PathType.Folder then
		local headers = private and self._PrivateHeaders or self._PublicHeaders

		for _, headerPath in pairs(headers) do
			if pathDetails.AbsolutePath == headerPath then
				return true
			end
		end

		table.insert(headers, pathDetails.AbsolutePath)
		return true
	end

	return false
end

function CProject:RemoveHeader(path, private)
	path = FileSystem.Format(path)
	local headers = private and self._PrivateHeaders or self._PublicHeaders

	for index, headerPath in pairs(headers) do
		if path == headerPath then
			return table.remove(headers, index)
		end
	end
end

function CProject:AddSource(path, maxDepth, ...)
    local sourceFiles = FileSystem.GetContents(path, maxDepth, ...)

    if sourceFiles then
		for _, sourcePath in pairs(sourceFiles) do
			local newSource = true
			
			for _, currentSourcePath in pairs(self._Sources) do
				if sourcePath == currentSourcePath then
					newSource = false

					break
				end
			end

			if newSource then
				table.insert(self._Sources, sourcePath)
			end
		end

        return true
    end

    return false
end

function CProject:RemoveSource(path)
	for index, sourcePath in pairs(self._Sources) do
		if path == sourcePath then
			return table.remove(self._Sources, index)
		end
	end
end

return Class.CreateClass(CProject, "CProject", Project)