{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=12";
        dpi = 0;
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "a6e3a1ff";
        selection = "89b4faff";
        selection-text = "1e1e2eff";
      };
    };
  };
}
