#!/bin/bash

while [ true ]; do
    gameport="27960"
    rconport="28960"

    bash /home/steam/steamcmd/steamapps/common/qlds/run_server_x64_minqlx.sh \
    +set net_strict "1" \
    +set net_port "$gameport" \
    +set qlx_redisAddress "redis" \
    +set sv_hostname "${SERVER_NAME:-"NOME DO SERVER"}" \
    +set fs_homepath "/home/steam/.quakelive/$gameport" \
    +set zmq_rcon_enable "1" \
    +set zmq_rcon_password "${RCON_PASSWORD:-"SuaSenha"}" \
    +set zmq_rcon_port "$rconport" \
    +set zmq_stats_enable "1" \
    +set zmq_stats_password "${STATS_PASSWORD:-"SuaSenha1"}" \
    +set zmq_stats_port "$gameport" \
    +set sv_mapPoolFile "mappool_ca.txt" \
    +set qlx_owner "${STEAM_ID:-"sua_steam_id"}" \
    +exec clan.cfg

done