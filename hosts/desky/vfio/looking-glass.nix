{ pkgs, config, ... }:
let
  vmConfig = config.vmConfig;
in
{
  environment.systemPackages = with pkgs; [
    looking-glass-client
    (writeShellScriptBin "looking-glass-launch" ''
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
              echo "Domain start command issued successfully."
              
              # Wait for domain to be fully running
              echo "Waiting for domain to be ready..."
              for ((i=1; i<=MAX_START_RETRIES; i++)); do
                  if virsh -c "$CONNECTION" list --state-running | grep -q "$DOMAIN_NAME"; then
                      echo "Domain '$DOMAIN_NAME' is now running!"
                      break
                  fi
                  
                  if [ $i -eq $MAX_START_RETRIES ]; then
                      echo "Error: Domain failed to start within $MAX_START_RETRIES seconds."
                      exit 1
                  fi
                  
                  echo "Still waiting... (attempt $i/$MAX_START_RETRIES)"
                  sleep 1
              done
              
              # Give the VM a bit more time to fully boot
              echo "Giving VM additional time to boot..."
              sleep 5
              
          else
              echo "Error: Failed to start domain '$DOMAIN_NAME'"
              exit 1
          fi
      fi

      echo "Attempting to start looking-glass-client..."

      # Try to start looking-glass-client with retries
      for ((i=1; i<=MAX_LG_RETRIES; i++)); do
          echo "Starting looking-glass-client (attempt $i/$MAX_LG_RETRIES)..."
          
          if looking-glass-client; then
              echo "looking-glass-client started successfully!"
              exit 0
          else
              echo "looking-glass-client failed to start (exit code: $?)"
              
              if [ $i -lt $MAX_LG_RETRIES ]; then
                  echo "Waiting $LG_RETRY_DELAY seconds before retry..."
                  sleep $LG_RETRY_DELAY
              fi
          fi
      done

      echo "Error: looking-glass-client failed to start after $MAX_LG_RETRIES attempts."
      echo "Please check your Looking Glass setup and VM configuration."
      exit 1
    '')
  ];
}
