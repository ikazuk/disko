{ pkgs ? import <nixpkgs> { }
, diskoLib ? pkgs.callPackage ../lib { }
}:
diskoLib.testLib.makeDiskoTest {
  inherit pkgs;
  name = "simple-efi-skip-format";
  disko-config = ../example/simple-efi-skip-format.nix;
  # TODO: add pre-disko hook
  # TODO: add pre-disko script
  

  preDisko = let
    inherit (pkgs) lib;
    inherit (diskoLib) testLib;
    testConfigInstall = testLib.prepareDiskoConfig (import ../example/simple-efi.nix) (lib.tail testLib.devices);
    tsp-generator = pkgs.callPackage ../. { };
    tsp-disko = (tsp-generator.diskoScript testConfigInstall) pkgs;
  in ''
    # run the simple efi without `skipFormat = true;`
    machine.succeed("${tsp-disko}")
  '';
  # TODO: check if the content is preserved
  extraTestScript = ''
    machine.succeed("mountpoint /");
  '';
}
