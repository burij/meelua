# Milua

Milua is a lightweight Lua framework designed for developers with functional mindset. Milua can be best (but not exclusivly) used within the NixOS environment. It provides essential tools and structure to streamline Lua development, making it easier to manage configurations, dependencies, and the development workflow.

## Features
- Simple setup and configuration for Lua projects.
- Compatible with NixOS.
- Extensible and modular, making it suitable for various Lua-based projects.
- Contains utilities and helper libraries to enhance Lua development.

## Requirements

- **NixOS**: This project is tailored for NixOS. If you're on a different OS, you can run the `shell.nix` from the project folder to set up an isolated Nix environment.

  OR
  
- **Lua**: Ensure you have Lua installed (version 5.1 or later).

## Installation

To set up the development environment using Nix, simply run:

```bash
nix-shell
```
This will create an isolated environment with all necessary dependencies.

## Usage
Clone the repository:

```
git clone https://github.com/your-username/milua.git
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
or if you're not using nix:
```
lua main.lua
```

This will execute the main logic of the Milua framework.

## Configuration
You can customize the framework through the config.lua file. This configuration file allows you to define your project-specific settings, such as paths, environment variables, and other Lua-based configurations.

## Folder Structure
- main.lua: The entry point of the application.
- config.lua: Configuration file for adjusting settings.
- lib.lua: Helper library with useful functions.
- build/: Directory intended for build artifacts or additional build scripts.
- shell.nix: Nix configuration for setting up the development environment.
- draft.lua: A draft script for experimenting with features.

## Warning
If you are using Milua on NixOS and entering the development envirement via `nix-shell` you're lib.lua and external packages will be updated. Breaking changes are possible until 1.0 release. If you want to avoid it, comment out shell hooks inside shell.nix.

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

