let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYDw1JYMnAcMjQTPvl0WV9uQwa9wE8h+OWESKCM9xxg" # jamie@desky
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8lBuFPtFthJicDFcmHc4kYMUaA8pzciCH7OpK3ltSv" # jamie@lappy
  ];
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAZ4FCYZa/qTCUHo3fr+3Fw8Nr2clSx1Pj6AdKQ+tqU" # lappy
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInP2UxyHBtsUjAfQ2VvFPY/WhH5fcohpRH6BwXI4dlc" # desky
  ];
in
{
  "secrets/env-jamie.age".publicKeys = users ++ systems;
  "secrets/samba-mox.age".publicKeys = users ++ systems;
  "secrets/restic-password.age".publicKeys = users ++ systems;
}
