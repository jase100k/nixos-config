{ config, pkgs, ... }:

let
  pi-agent-studio = pkgs.vscode-utils.buildVscodeExtension {
    pname = "pi-agent-studio";
    version = "1.3.10";

    src = pkgs.fetchurl {
      url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/johnny-zhao/vsextensions/pi-agent-studio/1.3.10/vspackage";
      sha256 = "06cr9m7wnfsp2jg9ipdz4zdijm9m1v9ybs3jlcayvq41zq8s4zis";
      name = "pi-agent-studio-1.3.10.vsix";
      curlOptsList = [ "--compressed" ];
    };

    vscodeExtUniqueId = "johnny-zhao.pi-agent-studio";
    vscodeExtPublisher = "johnny-zhao";
    vscodeExtName = "pi-agent-studio";

    meta = {
      description = "Pi Agent Studio - pi coding agent integration for VS Code";
      license = pkgs.lib.licenses.mit;
    };
  };
in
{
  home-manager.users.jason = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhs;
      profiles.default.extensions = [
        pi-agent-studio
      ];
    };
  };
}