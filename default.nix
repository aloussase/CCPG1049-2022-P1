{ pkgs ? import <nixpkgs>  {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # C
    gcc clang-tools readline

    # MIPS
    xspim
  ];

  shellHook = ''
   printf "=> nix-shell: setup for C + MIPS Assembly\n"
  '';
}
