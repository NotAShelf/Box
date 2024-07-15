let
  inherit ((builtins.getFlake ("git+file://" + toString ../.))) inputs;
in
  {
    nixpkgs ? inputs.nixpkgs,
    nixpak ? inputs.nixpak,
    pkgs ? import nixpkgs {config = {};},
  }:
    pkgs.mkShell {
      name = "sandbox";

      packages = with pkgs; let
        mkNixPak = nixpak.lib.nixpak {
          inherit pkgs;
          inherit (nixpkgs) lib;
        };
      in [
        (mkNixPak {
          config = _: {
            app.package = bash;

            dbus.enable = false;
            etc.sslCertificates.enable = true;

            bubblewrap.bind = {
              ro = ["/tmp/sandbox/ro"];
              rw = ["/tmp/sandbox/rw"];
            };
          };
        })
        .config
        .script

        croc
        curl
        git
        strace
        which
      ];

      shellHook = "exec bash";
    }
