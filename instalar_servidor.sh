#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
timeout=5

# Verifica se o script está sendo executado com permissões de root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script precisa ser executado com permissões de root${NC}"
   exit 1
fi

# Cria o usuário steam sem pedir senha
useradd -m -s /bin/bash steam
echo "steam:steam" | chpasswd
echo -e "${GREEN}Usuário steam criado com sucesso.${NC}"

echo -e "${YELLOW}A senha do seu usuario steam é steam${NC}"
sleep $timeout

# Instalação do Screen
echo -e "${RED}Instalando Screen...${NC}"
apt-get install screen -y
echo -e "${GREEN}Screen instalado com sucesso.${NC}"

# Instalação do Steam Client
echo -e "${RED}Instalando Steam Client...${NC}"
apt-get install lib32z1 lib32stdc++6 -y

# Cria o diretório e faz o download do SteamCMD
echo -e "${RED}Instalando SteamCMD...${NC}"
su - steam -c 'mkdir -p ~/steamcmd && cd ~/steamcmd && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz'

# Instalação do Quake Live Server
echo -e "${RED}Instalando Quake Live Server...${NC}"
su - steam -c '~/steamcmd/steamcmd.sh +login anonymous +force_install_dir ~/steamcmd/steamapps/common/qlds/ +app_update 349090 +quit'
echo -e "${GREEN}Instalação do Quake Live Server concluída!${NC}"

###########################
echo -e "${YELLOW}Partindo para instalar MINQLX, aguarde!${NC}"
sleep $timeout

# Verifica se o script está sendo executado com permissões de root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script precisa ser executado com permissões de root${NC}"
   exit 1
fi

# Atualiza os pacotes do sistema
echo -e "${RED}Atualizando os pacotes do sistema...${NC}"
apt-get update

# Instala o Python 3 e suas dependências
echo -e "${RED}Instalando Python 3 e suas dependências...${NC}"
apt-get -y install python3 python3-dev

# Verifica se o Python 3.5 ou posterior está instalado
python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
required_version="3.5"
if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo -e "${RED}Versão do Python insuficiente. Por favor, instale o Python $required_version ou posterior.${NC}"
    exit 1
fi

echo -e "${RED}Python 3 instalado com sucesso.${NC}"

# Instala o Redis, Git e as ferramentas de compilação
echo -e "${RED}Instalando Redis, Git e ferramentas de compilação...${NC}"
apt-get -y install redis-server git build-essential

echo -e "${RED}Redis, Git e build essentials instalados com sucesso.${NC}"

# Clone o repositório do minqlx
echo -e "${RED}Clonando o repositório do minqlx...${NC}"
git clone https://github.com/MinoMino/minqlx.git
cd minqlx

# Compila o minqlx
echo -e "${RED}Compilando o minqlx...${NC}"
make

echo -e "${RED}Minqlx compilado com sucesso.${NC}"

# Diretório do servidor Quake Live
QLDS_DIR="/home/steam/steamcmd/steamapps/common/qlds"

# Verifica se o diretório existe, caso contrário, cria
mkdir -p "$QLDS_DIR"

# Copia os arquivos do minqlx para o diretório do servidor Quake Live
cp -r bin/* "$QLDS_DIR"

echo -e "${RED}Arquivos do minqlx copiados para o diretório do servidor Quake Live.${NC}"

# Volta para o diretório do servidor Quake Live
cd "$QLDS_DIR"

# Clone o repositório dos plugins minqlx
git clone https://github.com/MinoMino/minqlx-plugins
cd minqlx-plugins

# Baixa e instala o pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
rm get-pip.py

# Instala as dependências Python
export PIP_BREAK_SYSTEM_PACKAGES=1
sudo python3 -m pip install -r requirements.txt

echo -e "${GREEN}Plugins minqlx instalados com sucesso.${NC}"

echo -e "${GREEN}Instalação e configuração do MinoMino/minqlx concluídas!${NC}"

###########################
echo -e "${YELLOW}Criando a config de Clan Arena e o executavel${NC}"
sleep $timeout

###########################
# Define o conteúdo da CFG em uma variável
cfg_content='set sv_tags "stf, ca, br, hue" // Comma delimited field of server tags to show in server browser.
set g_accessFile "/home/steam/steamcmd/steamapps/common/qlds/baseq3/access.txt"
               
set sv_maxClients "26"     // How many players can connect at once.
set g_password ""          // Set a server-wide password, and stop all users from connecting without it.
set sv_privateClients "2"  // Reserve slots that can be used with sv_privatePassword.
set sv_privatePassword ""
set com_hunkMegs "192"      // May need to be increased for additional players.

set sv_floodprotect "10"       // Kick the player when they reach x commands, decreases by 1 every second
set g_floodprot_maxcount "10"  // Kick the player when their userinfo flood counter reaches this level.
set g_floodprot_decay "1000"   // Decrease the userinfo flood counter by 1 this often, in milliseconds.


set g_voteFlags "8"
set g_allowVote "1"        // Turn off all votes
set g_voteDelay "0"        // Delay allowing votes for x milliseconds after map load.
set g_voteLimit "0"        // Limit users to x votes per map.
set g_allowVoteMidGame "1" // Dont allow callvotes once the map has started
set g_allowSpecVote "0"    // Allow spectators to call votes

set sv_warmupReadyPercentage "0.51"  // Ratio of players that must be ready before the match starts.
set g_warmupDelay "15"               // Wait x seconds before allowing match to start to allow all players to connect.
set g_warmupReadyDelay "0"           // Force the game to start after x seconds after someone readies up.
set g_warmupReadyDelayAction "1"     // Set to 1 to force players to spectator after g_warmupReady Delay, 2 to force ready up.

set g_inactivity "0"  // Kick players who are inactive for x amount of seconds.
set g_alltalk "0"     // 0: Limit voice comms to teams during match
                      // 1: Allow all players to talk to each other always
                      // 2: 1+ send back your own voice to yourself for testing


set sv_serverType "2"    // 0 = Offline, 1 = LAN, 2 = Internet
set sv_master "1"        // Whether the server should respond to queries. Disable this to stop server from appearing in browser.
                         // (This will affect the LAN browser!)

set sv_fps "40" // Change how many frames the server runs per second. WARNING: Has not been tested extensively, and
                // will have a direct impact on CPU and network usage!



set sv_idleExit "120"


// MINQLX CONFIGS

set qlx_plugins "banvote, rdamage, warn, specs, sv_fps, players_db, intermission, motd, myFun, killingspree, votestats, plugin_manager, essentials, kills, centerprint, permission, ban, silence, clan, names, log, workshop, balance, queue, branding, aliases, commands, autospec, midair, player_info, funnysounds"
set qlx_workShopReferences "2963187980, 2932595158, 2926846023, 605561819, 919565155, 2790708234, 2867194460, 2787795819, 2786181750, 2783931097, 585892371, 572453229, 1250689005, 1733859113, 2783899919, 2783671923, 2109702467, 597920398, 2780413391, 2780121009, 620087103, 549600167, 547252823, 1752943955, 740534444, 1205737264, 666692962, 701783942"

// sv_fps https://github.com/tjone270/Quake-Live/blob/master/minqlx-plugins/sv_fps.py
set qlx_svfps "40"

// votestats https://github.com/tjone270/Quake-Live/blob/master/minqlx-plugins/votestats.py
set qlx_privatiseVotes "0"

// branding https://github.com/tjone270/Quake-Live/blob/master/minqlx-plugins/branding.py


set qlx_connectMessage "^2[^3<^4@^3>^2] ^2SOH ^3TEM ^4FERA ^3- CA"
set qlx_serverBrandName "^2[^3<^4@^3>^2] ^2SOH ^3TEM ^4FERA ^3- CA"
set qlx_serverBrandTopField "^2[^3<^4@^3>^2] ^2SOH ^3TEM ^4FERA ^3- CA"
set qlx_serverBrandBottomField "^2[^3<^4@^3>^2]"
set qlx_loadedMessage "^2[^3<^4@^3>^2] ^1Quack ^1Quack"


// essentials https://github.com/MinoMino/minqlx-plugins/blob/master/essentials.py
set qlx_teamsizeMaximum "12"
set qlx_enforceMappool "1"

// motd https://github.com/MinoMino/minqlx-plugins/blob/master/motd.py
set qlx_motdSound "0"

// specqueue https://github.com/BarelyMiSSeD/minqlx-plugins/blob/master/specqueue.py
set qlx_queueSpecMsg "0"
set qlx_queueUseBDMPlacement "0"
set qlx_queuePlaceByTeamScores "0"
set qlx_queueMinPlayers "2"
set qlx_queueSpecByPrimary "time"
set qlx_queueSpecByTime "1"
set qlx_queueSpecByScore "0"
set qlx_queueQueueMsg "0"
set qlx_queueEnforceEvenTeams "1"

// balance https://github.com/MinoMino/minqlx-plugins/blob/master/balance.py
set qlx_balanceUrl "qlstats.net"
set qlx_balanceApi "elo"
set qlx_balanceMinimumSuggestionDiff "40"

// centerprint https://github.com/dsverdlo/minqlx-plugins/blob/master/centerprint.py
set qlx_cp_message "^1FALTA 1 ^2TROXA"

// myFun https://github.com/BarelyMiSSeD/minqlx-plugins/blob/master/myFun/myFun.py
set qlx_funSoundDelay "5"
set qlx_funPlayerSoundRepeat "30"
set qlx_funAdminSoundCall "0"
set qlx_funJoinSound "sound/funnysounds23/dilma.ogg"
set qlx_funJoinSoundForEveryone "3"
set qlx_funFastSoundLookup "0"
set qlx_funLast2Sound "2"

// set g_laghaxms "160"
// set g_laghaxhistory "20"
// start server with map and mod

set serverstartup "map asylum ca"
'

# Escreve o conteúdo no arquivo ca.sh
echo "$cfg_content" > $QLDS_DIR/baseq3/clan.cfg

echo "Arquivo clan.cfg criado com sucesso em /home/steam/steamcmd/steamapps/common/qlds/baseq3/"


#############################
echo "Criar o atalho que executa o servidor"

# Define o conteúdo do script em uma variável
script_content='#!/bin/bash

while [ true ]; do
    gameport="27960"
    rconport="28960"

    bash /home/steam/steamcmd/steamapps/common/qlds/run_server_x64_minqlx.sh \
    +set net_strict "1" \
    +set net_port $gameport \
    +set sv_hostname "NOME DO SERVER" \
    +set fs_homepath /home/steam/.quakelive/$gameport \
    +set zmq_rcon_enable "1" \
    +set zmq_rcon_password "SuaSenha" \
    +set zmq_rcon_port $rconport \
    +set zmq_stats_enable "1" \
    +set zmq_stats_password "SuaSenha1" \
    +set zmq_stats_port $gameport \
    +set sv_mapPoolFile "mappool_ca.txt" \
    +set qlx_owner "sua_steam_id" \
    +exec clan.cfg

    sleep 5
done'

# Escreve o conteúdo no arquivo ca.sh
echo "$script_content" > /home/steam/ca.sh

# Torna o arquivo executável
chmod +x /home/steam/ca.sh

echo "Arquivo ca.sh criado com sucesso!"

####
echo -e "${RED}Baixando os plugins que eu uso no meu server agora${NC}"

#!/bin/bash

# Clona o repositório
git clone https://github.com/philipecella/minqlx-plugins.git /tmp/minqlx-plugins

# Verifica se o clone foi bem-sucedido
if [ $? -ne 0 ]; then
    echo "Erro ao clonar o repositório."
    exit 1
fi

# Navega até o diretório com os arquivos .py
cd /tmp/minqlx-plugins

# Copia os arquivos .py para o destino desejado e substitui os existentes
cp -r *.py /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins

# Verifica se a cópia foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro ao copiar os arquivos."
    exit 1
fi

echo "Arquivos copiados com sucesso para /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins."

