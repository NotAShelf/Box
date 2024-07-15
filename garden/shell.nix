let
  inherit (builtins) getFlake concatLists attrValues;
  inherit ((getFlake ("git+file://" + toString ../.))) inputs;
in
  {
    nixpkgs ? inputs.nixpkgs,
    nixpak ? inputs.nixpak,
    pkgs ? import nixpkgs {config = {};},
  }:
    pkgs.mkShell {
      name = "Walled Garden";
      meta.description = ''
        A sandboxed environment for running or investigating untrusted code
      '';

      packages = let
        mkNixPak = nixpak.lib.nixpak {
          inherit pkgs;
          inherit (nixpkgs) lib;
        };

        sandbox = mkNixPak {
          config = _: {
            app.package = pkgs.bashInteractive;

            dbus.enable = false;
            etc.sslCertificates.enable = true;

            bubblewrap = {
              network = true; # makes our life a tad easier
              bind = {
                ro = ["/tmp/sandbox/ro"];
                rw = ["/tmp/sandbox/rw"];
              };
            };
          };
        };
      in
        concatLists [
          (attrValues {inherit (pkgs) curl strace which hexxy gitMinimal;})
          [sandbox.config.script]
        ];

      shellHook = "exec bash";
    }
