local Enum = require("Utilities.Enum")

Enum.LogCategory = Enum.Create({
    Workspace = 1,
    Application = 2,
	Option = 3,
	Library = 4,
	Global = 5
})

Enum.LogPriority = Enum.Create({
    Trace = 1,
    Verbose = 2,
    Debug = 3,
    Info = 4,
    Warn = 5,
    Error = 6,
    Critical = 7
})

Enum.OS = Enum.Create({
    Windows = 1,
    Linux = 2,
    Unknown = 3
})

Enum.Architecture = Enum.Create({
    x86 = 1,
    x64 = 2,
    Arm = 3,
    Arm64 = 4,
    Unknown = 5
})

Enum.PathType = Enum.Create({
    File = 1,
    Folder = 2
})

Enum.ErrorCode = Enum.Create({
	InvalidObject = -1,
	Success = 0,
	MissingRequiredOption = 1,
	DuplicateProjectName = 2
})

Enum.OptionDataType = Enum.Create({
	String = 1,
	Boolean = 2,
	Number = 3,
	FileSystem = 4,
	Enum = 5
})

Enum.ProjectState = Enum.Create({
	Built = 1
})

Enum.ExecutionMode = Enum.Create({
	Read = "r",
	Write = "w",
	Execute = "e"
})