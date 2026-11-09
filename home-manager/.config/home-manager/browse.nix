{
  config,
  pkgs,
  ...
}: let
  browse = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "opencode-browse";
    version = "0.0.16";

    src = pkgs.fetchurl {
      url = "https://anoma.ly/release/browse/files/4a5a00eb15e9d8b126bed50f0499cab51e9c501bc9653866b3d002d35231051c/opencode-browse-linux-x64-${version}.tgz";
      hash = "sha256-SloA6xXp2LEmvtUPBJnKtR6cUBvJZThms9AC01IxBRw=";
    };

    sourceRoot = "package";
    # Bun compiled executables keep their application payload in the ELF file.
    # Rewriting or stripping it makes this binary start as the Bun runtime.
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/browse $out/bin/browse
      runHook postInstall
    '';

    meta = {
      description = "Control an existing Chromium browser from AI agents";
      homepage = "https://github.com/anomalyco/browse";
      license = pkgs.lib.licenses.mit;
      mainProgram = "browse";
      platforms = ["x86_64-linux"];
    };
  };
in {
  home.packages = [browse];

  # The browser runs on Windows while OpenCode and the relay run in WSL.
  # Listening on all WSL interfaces allows Windows localhost forwarding to
  # reach the relay; the relay API itself remains restricted to loopback.
  home.file.".config/browse/config.json" = {
    text = builtins.toJSON {
      hostname = "0.0.0.0";
    };
  };

  # Browse is pinned by Nix, so report upstream updates instead of allowing
  # Browse's imperative updater to write a second binary to ~/.local/bin.
  home.sessionVariables.OPENCODE_BROWSER_AUTO_UPDATE = "notify";
}
