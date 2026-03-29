{ ... }:

{

home.sessionPath = [ "$HOME/bin" ];

  home.file."bin/update_servers" = {
    source = ./scripts/update_servers.sh;
    executable = true;
  };
}
