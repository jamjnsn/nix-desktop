{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tdrop
    resources # GTK resource monitor
    alpaca # Ollama client
  ];
}
