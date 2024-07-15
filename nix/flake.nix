{
  description = ''
    A messy box full of sand. Rough, coarse, and irritating, and it gets everywhere.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = _: {};
}
