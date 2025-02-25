{ ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    languages = {
      language-server.rust-analyzer.config.check.command = "clippy";

      language = [
        {
          name = "dart";
          rulers = [ 80 ];
        }
      ];
    };

    settings = {
      theme = "custom";

      editor = {
        line-number = "relative";
        bufferline = "always";
        rulers = [ 100 ];
        true-color = true;

        file-picker.hidden = false;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };

      # https://docs.helix-editor.com/keymap.html
      keys = {
        normal = {
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          C-s = ":w";
          C-q = ":bc"; # TODO map to :bc if >1 buffers are open, otherwise :q
        };

        insert = {
          C-space = "normal_mode";
        };

        select = {
          C-space = "normal_mode";
        };
      };
    };

    themes = {
      custom = {
        "inherits" = "onedark";
        "ui.background" = { };
        "ui.gutter" = {
          bg = "black";
        };
      };
    };
  };
}
