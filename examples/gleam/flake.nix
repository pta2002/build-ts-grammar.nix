{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ts-build.url = "../../";
  inputs.gleam.url = "github:gleam-lang/tree-sitter-gleam";
  inputs.gleam.flake = false;

  outputs = { self, nixpkgs, flake-utils, ts-build, gleam }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = ts-build.lib.buildGrammar pkgs {
        language = "gleam";
        version = "0.25.0";
        source = gleam;
      };
    });
}
