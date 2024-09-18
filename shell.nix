let
	nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
	pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
	packages = with pkgs; [
		wget
		(lua5_4.withPackages(ps: with ps; [
			luarocks
		]))
	];

	shellHook = ''
		wget -O lib.lua https://raw.githubusercontent.com/burij/milua/main/lib.lua
		alias run='lua main.lua'
		alias test='lua draft.lua'
		luarocks install inspect --tree ./pkgs
    		luarocks install lua-cjson --tree ./pkgs

		export LUA_PATH="./pkgs/share/lua/5.4/?.lua;./share/lua/5.4/?/init.lua;$LUA_PATH"
		export LUA_CPATH="./pkgs/lib/lua/5.4/?.so;$LUA_CPATH"
	'';
}