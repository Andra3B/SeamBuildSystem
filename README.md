# 🧵 Seam Build System
A lightweight, cross-platform build system for compiling **C software** on **Windows** and **Linux**, featuring **Lua 5.1** scripting for enhanced flexibility.

## 🚀 Features

- **Executable Compilation:** Easily build C source files into executable binaries.  
- **Static Library Compilation:** Seam supports the compilation and linking of static libraries.  
- **Automatic Dependency Management:** Define project dependencies so that required build outputs (e.g. library files) are automatically built in the correct order.  
- **External Project Integration:** Seamlessly include pre-built or externally managed projects in your build process.  
- **File System & Logging:** Built-in support for file system operations such as copying, creating, and deleting files or directories. Includes a logging module for producing well-formatted output messages.  
- **Lua 5.1 Scripting:** Extend and customize build behavior using [Lua 5.1](https://www.lua.org/manual/5.1/) and [LuaJIT](https://luajit.org/).

---

## 🧩 Dependencies

Seam relies on the following tools:

- **[Bash](https://www.gnu.org/software/bash/):** Executes build commands.  
- **[GCC](https://gcc.gnu.org/):** C compiler toolchain.  
- **[LuaJIT](https://luajit.org/):** Interpreter for running Lua 5.1 scripts.

**Note:**  
> - **Linux:** Bash and GCC are typically pre-installed.  
> - **Windows:** You can use [Git Bash](https://git-scm.com/) for Bash and [MinGW-w64](https://www.mingw-w64.org/) (which includes GCC for Windows).

---