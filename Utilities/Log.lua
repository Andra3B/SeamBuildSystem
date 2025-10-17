local Log = {}

local priorities = {}

function Log.GetCategoryPriority(category)
	return priorities[category]
end

function Log.SetCategoryPriority(category, priority)
	priorities[category] = priority
end

function Log.Format(category, priority, time, message, ...)
	local categoryString = Enum.LogCategory[category] or "Unknown"
	local priorityString = ""

	local _priorityString = Enum.LogPriority[priority]
	if _priorityString then
		priorityString = _priorityString
	end

	return string.format("[%s:%s] [%s] "..message.."\n", categoryString, _priorityString, os.date("%H:%M:%S", time), ...)
end

function Log.NewLine()
	io.stdout:write("\n")
end

function Log.Log(category, priority, message, ...)
	if not priorities[category] or priority >= priorities[category] then
		io.stdout:write(Log.Format(category, priority, nil, message, ...))
	end
end

function Log.Trace(category, message, ...) Log.Log(category, Enum.LogPriority.Trace, message, ...) end
function Log.Verbose(category, message, ...) Log.Log(category, Enum.LogPriority.Verbose, message, ...) end
function Log.Debug(category, message, ...) Log.Log(category, Enum.LogPriority.Debug, message, ...) end
function Log.Info(category, message, ...) Log.Log(category, Enum.LogPriority.Info, message, ...) end
function Log.Warn(category, message, ...) Log.Log(category, Enum.LogPriority.Warn, message, ...) end
function Log.Error(category, message, ...) Log.Log(category, Enum.LogPriority.Error, message, ...) end
function Log.Critical(category, message, ...) Log.Log(category, Enum.LogPriority.Critical, message, ...) end

return Log