local FileSystem = {}

function FileSystem.GetSeparator()
	return Seam.OS == Enum.OS.Windows and "\\" or "/"
end

function FileSystem.GetDetails(path)
	local absolutePath, folder, name, extension, size, lastModificationTime, pathType

	if #path > 0 then
		local program = Seam.Execute(
			[[f=$(realpath -m "]]..path..[["); echo ${f}; dirname "${f}"; basename "${f}"; echo ${f##*.}; [ -e "${f}" ] && echo -e $(stat -c "%s\n%Y" "${f}")]],
			Enum.ExecutionMode.Read
		)
		absolutePath, folder, name, extension, size, lastModificationTime = program:read("*l", "*l", "*l", "*l", "*l" ,"*l")
		program:close()
		name = string.match(name, "(.*)%.?")
		size = tonumber(size)
		lastModificationTime = tonumber(lastModificationTime)
		pathType = absolutePath == extension and Enum.PathType.Folder or Enum.PathType.File
		
		if pathType == Enum.PathType.Folder then
			absolutePath = absolutePath.."/"
			extension = ""
		end
	end

	return {
		AbsolutePath = absolutePath,
		Exists = size ~= nil,
		Type = pathType,
		Folder = folder,
		Name = name,
		Extension = extension,
		Size = size,
		LastModificationTime = lastModificationTime
	}
end

function FileSystem.Format(path)
	return FileSystem.GetDetails(path).AbsolutePath
end

function FileSystem.Create(path)
	local pathDetails = FileSystem.GetDetails(path)

	if pathDetails.Exists then
		return true
	elseif pathDetails.AbsolutePath then
		if pathDetails.Type == Enum.PathType.Folder then
			return Seam.Execute(
				"mkdir -p \""..pathDetails.AbsolutePath.."\"",
				Enum.ExecutionMode.Execute
			) == 0
		else
			return Seam.Execute(
				"mkdir -p \""..pathDetails.Folder.."\" && touch \""..pathDetails.AbsolutePath.."\"",
				Enum.ExecutionMode.Execute
			) == 0
		end
	end

	return false
end

function FileSystem.Destroy(path)
	return Seam.Execute(
		"rm -r -f \""..path.."\"",
		Enum.ExecutionMode.Execute
	) == 0
end

function FileSystem.Copy(from, to, newer)
	return Seam.Execute(
		"cp -P --preserve=all --no-preserve=timestamps -r -f "..(newer and "-u \"" or "\"")..from.."\" \""..to.."\"",
		Enum.ExecutionMode.Execute
	) == 0
end

function FileSystem.GetContents(path, maxDepth, ...)
	local pathDetails = FileSystem.GetDetails(path)
	
	if pathDetails.Exists then
		local contents = {}

		if pathDetails.Type == Enum.PathType.File then
			table.insert(contents, pathDetails.AbsolutePath)
		else
			local wildcardTable = {...}
			local wildcards = ""

			if #wildcardTable > 0 then
				wildcards = " \\( "

				wildcards = wildcards.."-path \""..wildcardTable[1].."\""

				for index = 2, #wildcardTable, 1 do
					wildcards = wildcards.." -o -path \""..wildcardTable[index].."\""
				end

				wildcards = wildcards.." \\)"
			end

			local program = Seam.Execute(
				"find \""..pathDetails.AbsolutePath.."\" -mindepth 1 "..(type(maxDepth) == "number" and "-maxdepth "..tostring(maxDepth) or "")..wildcards.." -print",
				Enum.ExecutionMode.Read
			)

			for line in program:lines() do
				table.insert(contents, line)
			end

			program:close()
		end

		return contents
	end
end

return FileSystem