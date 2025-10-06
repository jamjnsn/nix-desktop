{ pkgs, config, ... }:
let
  vmConfig = config.vmConfig;
in
{
  environment.systemPackages = with pkgs; [
    (pkgs.looking-glass-client.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        echo "NoDisplay=true" >> $out/share/applications/looking-glass-client.desktop
      '';
    }))

    (pkgs.makeDesktopItem {
      name = "looking-glass-launcher";
      desktopName = "Looking Glass";
      exec = "looking-glass-launcher";
      icon = "looking-glass";
      comment = "Low latency KVM framebuffer relay";
      categories = [
        "System"
        "Utility"
      ];
    })

    (writeShellScriptBin "looking-glass-launcher" ''
      #!${pkgs.bash}/bin/bash

      # Configuration
      DOMAIN_NAME="${vmConfig.name}"
      CONNECTION="qemu:///system"
      MAX_START_RETRIES=30
      MAX_LG_RETRIES=10
      LG_RETRY_DELAY=3

      echo "Checking if domain '$DOMAIN_NAME' is running..."

      # Check if domain is running
      if virsh -c "$CONNECTION" list --state-running | grep -q "$DOMAIN_NAME"; then
          echo "Domain '$DOMAIN_NAME' is already running."
      else
          echo "Domain '$DOMAIN_NAME' is not running. Starting it..."
          
          # Start the domain
          if virsh -c "$CONNECTION" start "$DOMAIN_NAME"; then
              echo "Waiting for domain to be ready..."
              
              for ((i=1; i<=MAX_START_RETRIES; i++)); do
                  if virsh -c "$CONNECTION" list --state-running | grep -q "$DOMAIN_NAME"; then
                      break
                  fi
                  
                  if [ $i -eq $MAX_START_RETRIES ]; then
                      echo "Error: Domain failed to start within $MAX_START_RETRIES seconds."
                      exit 1
                  fi
                  
                  echo "Still waiting... (attempt $i/$MAX_START_RETRIES)"
                  sleep 3
              done
          else
              echo "Error: Failed to start domain '$DOMAIN_NAME'"
              exit 1
          fi
      fi

      looking-glass-client
    '')
  ];
}
