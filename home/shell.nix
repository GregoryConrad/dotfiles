{ ... }:
{
  programs.fish =
    let
      fishFunctionsDir = ./fish/functions;
      fishFunctionFiles = builtins.attrNames (builtins.readDir fishFunctionsDir);
      fishFunctions = builtins.listToAttrs (
        map (name: {
          name = builtins.replaceStrings [ ".fish" ] [ "" ] name;
          value = builtins.readFile (fishFunctionsDir + "/${name}");
        }) fishFunctionFiles
      );
    in
    {
      enable = true;
      functions = fishFunctions;
      shellInit = ''
        set -gx SUDOEDIT $EDITOR
      '';
      interactiveShellInit = ''
        set fish_greeting

        # TODO figure out why we have to call these next few in order for stuff not to break
        fish_helix_key_bindings
        fish_prompt
        fish_right_prompt
      '';
    };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
