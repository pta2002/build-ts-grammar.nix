{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: {
    lib = {
      buildGrammar = pkgs:
        { language
        , version
        , source
        , generate ? false
        , location ? null
        , ...
        }: with pkgs;stdenv.mkDerivation {
          pname = "${language}-grammar";
          name = "${language}-grammar";
          src = source;

          nativeBuildInputs = lib.optionals generate [ nodejs tree-sitter ];

          CFLAGS = [ "-Isrc" "-O2" ];
          CXXFLAGS = [ "-Isrc" "-O2" ];

          stripDebugList = [ "parser" ];

          configurePhase = lib.optionalString generate ''
            tree-sitter generate
          '' + lib.optionalString (location != null) ''
            cd ${location}
          '';

          buildPhase = ''
            runHook preBuild
            if [[ -e src/scanner.cc ]]; then
              $CXX -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
            elif [[ -e src/scanner.c ]]; then
              $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
            fi

            $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
            $CXX -shared -o parser *.o

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir $out
            mv parser $out/
            if [[ -d queries ]]; then
              cp -r queries $out
            fi

            runHook postInstall
          '';
        };
    };
  };
}
