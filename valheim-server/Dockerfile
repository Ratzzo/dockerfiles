FROM cm2network/steamcmd:latest

RUN ./steamcmd.sh steamcmd +login anonymous +force_install_dir /home/steam/valheim-server +app_update 896660 +quit

ADD --chown=1000:1000 scripts/valheim_server /home/steam/start_valheim_server

ENTRYPOINT /home/steam/start_valheim_server
