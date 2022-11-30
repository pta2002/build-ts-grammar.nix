# Build tree-sitter grammars with Nix

This is just a simple flake to help you build custom tree-sitter grammars on
Nix, for usage with, for example, neovim.

## Example usage:
```nix
{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ts-build.url = "github:pta2002/build-ts-grammar.nix";
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
```
