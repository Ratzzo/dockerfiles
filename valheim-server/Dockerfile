############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:bullseye-slim as build_stage

#LABEL maintainer=""
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=10.2.1-6 \
		lib32gcc-s1=10.2.1-6 \
		ca-certificates=20210119 \
		nano=5.4-2+deb11u2 \
		curl=7.74.0-1.3+deb11u3 \
		locales=2.31-13+deb11u5 \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	# Create unprivileged user
	&& useradd -u "${PUID}" -m "${USER}" \
	# Download SteamCMD, execute as user
	&& su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
		&& curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
		&& \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
		&& mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
		&& ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
		&& ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
		&& ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	# Symlink steamclient.so; So misconfigured dedicated servers can find it
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"

RUN apt-get install unzip

#RUN apt-get remove --purge --auto-remove -y \
#        && rm -rf /var/lib/apt/lists/*

WORKDIR ${STEAMCMDDIR}

## Switch to user
USER ${USER}

RUN ./steamcmd.sh steamcmd +force_install_dir /home/steam/valheim-server +login anonymous +app_update 896660 +quit

RUN cd /home/steam/; curl https://gcdn.thunderstore.io/live/repository/packages/denikson-BepInExPack_Valheim-5.4.1901.zip -o bepinex.zip && \
    unzip bepinex.zip && mv BepInExPack_Valheim/* valheim-server/

RUN cd /home/steam/; curl https://gcdn.thunderstore.io/live/repository/packages/ValheimModding-Jotunn-2.10.1.zip -o jotunn.zip && \
    unzip jotunn.zip "plugins/*" -d /home/steam/valheim-server/BepInEx

RUN cd /home/steam/; curl https://uwadodardo.ratzzo.net/ValheimRAFT.zip -o raft.zip && \
    unzip raft.zip && mv ValheimRAFT/* /home/steam/valheim-server/BepInEx/plugins

ADD --chown=1000:1000 scripts/valheim_server /home/steam/start_valheim_server
ADD --chown=1000:1000 scripts/bepinex_server /home/steam/start_bepinex_server

CMD /home/steam/start_valheim_server
