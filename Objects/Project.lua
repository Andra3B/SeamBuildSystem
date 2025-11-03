local Object = require("Seam.Objects.Object")
local Project = {}

local projects = setmetatable({}, {__mode = "v"})

function Project.Create(name)
	for _, project in ipairs(projects) do
		Seam.Assert(
			project._Name ~= name,
			Enum.ErrorCode.DuplicateProjectName,
			Enum.LogCategory.Project,
			"A project already has the name \"%s\"",
			name
		)
	end

    local self = Class.CreateInstance(Object.Create(), Project)

	self._Name = name
	
	self._Dependencies = {}

	table.insert(projects, self)
    return self
end

function Project:SetName(name)
end

function Project:GetDependencyTraversalOrder()
	local traversalOrder = {}
	local dependencyQueue = {self}

	while #dependencyQueue > 0 do
		local rootDependency = table.remove(dependencyQueue, 1)
		local traversed = false

		for _, traversedDependency in ipairs(traversalOrder) do
			if rootDependency == traversedDependency then
				traversed = true

				break
			end
		end

		if not traversed then
			table.insert(traversalOrder, rootDependency)

			for _, dependency in pairs(rootDependency._Dependencies) do
				table.insert(dependencyQueue, dependency)
			end
		end
	end

	table.remove(traversalOrder, 1)
	return traversalOrder
end

function Project:GetDependencies()
	return self._Dependencies
end

function Project:AddDependency(project)
	if Class.IsA(project, "Project") and project ~= self and project._Name and not self._Dependencies[project._Name] then
		self._Dependencies[project._Name] = project

		return true
	end

	return false
end

function Project:RemoveDependency(name)
	local project = self._Dependencies[name]
	self._Dependencies[name] = nil

	return project
end

return Class.CreateClass(Project, "Project", Object)