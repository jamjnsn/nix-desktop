{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gomi
  ];

  programs.zsh.initContent = ''
    # Gomi with output
    gomi_verbose() {
        for file in "$@"; do
            if [[ -e "$file" ]]; then
                echo "🗑️  $file"
                gomi "$file"
            else
                echo "❌  $file"
            fi
        done
    }

    # Replace rm
    alias rm="gomi_verbose"
  '';
}
