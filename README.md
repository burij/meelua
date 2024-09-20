# Meelua

Meelua is a lightweight Lua framework designed for developers with a functional mindset. It's optimized for use within the NixOS environment but can be adapted for other systems. Meelua provides essential tools and structure to streamline Lua development, making it easier to manage configurations, dependencies, and development workflows.

## Features
- Simple setup and configuration for Lua projects
- Seamless integration with NixOS
- Extensible and modular architecture suitable for various Lua-based projects
- Comprehensive utilities and helper libraries to enhance Lua development
- Functional programming approach with strict separation of app logic, functions, and data

## Requirements

- **NixOS**: (recommended): Meelua is tailored for NixOS.

  OR
  
- **Lua**: Ensure you have Lua installed (version 5.1 or later).

## Installation

Set up the development environment using Nix:

```bash
nix-shell
```
This creates an isolated environment with all necessary dependencies.

## Usage
Clone the repository:

```
git clone https://github.com/your-username/meelua.git
cd milua
```


Enter the Nix shell environment:

```
nix-shell
```

Run the main Lua script:

```
run
```
Or without Nix:
```
lua main.lua
```

This will execute the main logic of the Milua framework.

## Folder Structure
- main.lua: The entry point of the application.
- config.lua: Configuration file for adjusting settings.
- lib.lua: Helper library with useful functions.
- build/: Directory intended for build artifacts or additional build scripts.
- shell.nix: Nix configuration for setting up the development environment.
- draft.lua: A draft script for experimenting with features.

## Configuration
Customize your development environment through the shell.nix file. Define project-specific settings, packages, environment variables, and terminal aliases.

## Development aproach

Meelua follows a functional programming paradigm with clear separation of concerns:
- App logic, functions, and data are strictly separated
- Function calls are centralized in main.lua
- Global functions are aliased with lib. prefix and stored in a metatable
- Impure functions are prefixed with do_
- Static variables are stored in the config table
- Simple type enforcement system available via lib.types

## Warning
When using Meelua on NixOS with nix-shell, lib.lua and external packages will be updated. Breaking changes are possible until the 1.0 release. To prevent updates, comment out shell hooks in shell.nix.

## Contributing
We welcome contributions! To get started:

- Fork the repository.
- Create a new feature branch (git checkout -b feature-branch).
- Make your changes and commit them (git commit -am 'Add new feature').
- Push to the branch (git push origin feature-branch).
- Open a pull request.
- Please ensure your code follows Lua best practices and is compatible with NixOS.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

