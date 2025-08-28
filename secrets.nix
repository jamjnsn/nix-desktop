let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXQ0A39DByhw8/nXW4laWGjAGOP15uWH1EUFSPQldUW" # jamie@lappy
  ];
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAZ4FCYZa/qTCUHo3fr+3Fw8Nr2clSx1Pj6AdKQ+tqU" # lappy
  ];
in
{
  "secrets/env-jamie.age".publicKeys = users ++ systems;
}
