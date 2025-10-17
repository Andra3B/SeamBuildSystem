local Object = {}

function Object.Create()
    local self = Class.CreateInstance(nil, Object)

    self._Name = nil
	
    return self
end

function Object:GetName()
    return self._Name
end

function Object:SetName(name)
    self._Name = name
end

return Class.CreateClass(Object, "Object")