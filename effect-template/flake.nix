{
  description = "Effect-TS project development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          isLinux = pkgs.stdenv.isLinux;
          isDarwin = pkgs.stdenv.isDarwin;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_22
              corepack_22
              pnpm
              bun
              jq
              curl

              # For native module compilation (node-gyp)
              python3
              gnumake
              gcc
            ];

            env = {
              npm_config_nodedir = "${pkgs.nodejs_22}";
            };

            shellHook = ''
              ${if isLinux then ''
                export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
              '' else ""}
              echo "Effect-TS dev environment"
              echo "Node $(node --version) | pnpm $(pnpm --version)"
            '';
          } // pkgs.lib.optionalAttrs isDarwin {
            __darwinAllowLocalNetworking = true;
          };
        });

      formatter = forAllSystems (system: (pkgsFor system).alejandra);
    };
}
