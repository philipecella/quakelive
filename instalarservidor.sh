#!/bin/bash
tput clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
timeout=3


echo "         _____ ___________           "
echo "        /  ___|_   _|  ___|          "
echo "        \ \`--.  | | | |_             "
echo "         \`--. \\ | | |  _|            "
echo "        /\\__/ / | | | |              "
echo "        \\____/  \\_/ \\_|              "
echo "                                     "
echo "                                     "
echo " _____ ___________ _   _ ___________ "
echo "/  ___|  ___| ___ \\ | | |  ___| ___ \\"
echo "\\ \`--.| |__ | |_/ / | | | |__ | |_/ /"
echo " \`--. \\  __||    /| | | |  __||    / "
echo "/\\__/ / |___| |\\ \\ \\_/ / |___| |\\ \\ "
echo "\\____/\\____/\\_| \\_\\___/\\____/\\_| \\_\\"

sleep $timeout

# Verifica se o script está sendo executado com permissões de root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script precisa ser executado com permissões de root${NC}"
   exit 1
fi

echo -e "${YELLOW}Digite a senha para o usuário steam:${NC}"
read -s steam_password

useradd -m -s /bin/bash steam
echo "steam:$steam_password" | chpasswd
echo -e "${GREEN}Usuário steam criado com sucesso.${NC}"
sleep $timeout

# Instalação do Screen
echo -e "${YELLOW}Instalando Screen...${NC}"
apt-get install screen -y
echo -e "${GREEN}Screen instalado com sucesso.${NC}"
sleep $timeout

# Diretório do servidor Quake Live
QLDS_DIR="/home/steam/steamcmd/steamapps/common/qlds"

# Verifica se o diretório existe, caso contrário, cria
mkdir -p "$QLDS_DIR"

# Instalação do STEAMCMD
apt-get install lib32z1 lib32stdc++6 -y
su - steam -c 'mkdir -p ~/steamcmd && cd ~/steamcmd && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz'
echo -e "${GREEN}SteamCMD instalado${NC}"
sleep $timeout

# Instalação do Quake Live Server
echo -e "${YELLOW}Instalando Quake Live Server...${NC}"
su - steam -c '~/steamcmd/steamcmd.sh +force_install_dir /home/steam/steamcmd/steamapps/common/qlds/ +login anonymous +app_update 349090 +quit'
su - steam -c '~/steamcmd/steamcmd.sh +force_install_dir /home/steam/steamcmd/steamapps/common/qlds/ +login anonymous +app_update 349090 +quit'

echo -e "${GREEN}Instalação do Quake Live Server concluída!${NC}"
sleep $timeout

echo -e "${YELLOW}Instalando MINQLX, aguarde!${NC}"
sleep $timeout

# Verifica se o script está sendo executado com permissões de root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script precisa ser executado com permissões de root${NC}"
   exit 1
fi

# Atualiza os pacotes do sistema
echo -e "${YELLOW}Atualizando os pacotes do sistema...${NC}"
apt-get update -y

# Instala o Python 3 e suas dependências
echo -e "${YELLOW}Instalando Python 3 e suas dependências...${NC}"
apt-get -y install python3 python3-dev

# Verifica se o Python 3.5 ou posterior está instalado
python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
required_version="3.5"
if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo -e "${RED}Versão do Python insuficiente. Por favor, instale o Python $required_version ou posterior.${NC}"
    exit 1
fi

echo -e "${GREEN}Python 3 instalado com sucesso.${NC}"
sleep $timeout

# Instala o Redis, Git e as ferramentas de compilação
echo -e "${YELLOW}Instalando Redis, Git e ferramentas de compilação...${NC}"
sleep $timeout
apt-get -y install redis-server git build-essential

echo -e "${GREEN}Redis, Git e build essentials instalados com sucesso.${NC}"
sleep $timeout

# Clone o repositório do minqlx
echo -e "${YELLOW}Clonando o repositório do minqlx...${NC}"
git clone https://github.com/MinoMino/minqlx.git /tmp/minqlx/
cd /tmp/minqlx/

# Compila o minqlx
echo -e "${YELLOW}Compilando o minqlx...${NC}"
make

echo -e "${GREEN}Minqlx compilado com sucesso.${NC}"
sleep $timeout

# Copia os arquivos do minqlx para o diretório do servidor Quake Live
cp -r /tmp/minqlx/bin/* "$QLDS_DIR"

echo -e "${GREEN}Arquivos do minqlx copiados para o diretório do servidor Quake Live.${NC}"
sleep $timeout
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
timeout=3
echo -e "${GREEN}Instalação e configuração do MinoMino/minqlx concluídas!${NC}"
sleep $timeout
###########################

echo -e "${YELLOW}Baixando a config e executavel do clan arena${NC}"
echo -e "${YELLOW}Baixando os plugins que eu uso no meu server agora${NC}"
sleep $timeout

# Clona o repositório
git clone https://github.com/philipecella/minqlx-plugins.git /tmp/minqlx-plugins

# Copia os arquivos .py para o destino desejado e substitui os existentes
cp -r /tmp/minqlx-plugins/*.py /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins

echo -e "${GREEN}Arquivos copiados com sucesso para /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins/${NC}"
sleep $timeout

# Clona o repositório
mkdir /tmp/
git clone https://github.com/philipecella/quakelive.git /tmp/quakelive/

# Copia o arquivo clan.cfg para o diretório desejado
cp /tmp/quakelive/{clan.cfg,workshop.txt,mappool_ca.txt} /home/steam/steamcmd/steamapps/common/qlds/baseq3/
cp /tmp/quakelive/ca.sh /home/steam/

## Facilitando a vida do peao para setar o nome do servidor e senha do qlstats

print_green() {
    echo -e "\033[0;32m$1\033[0m"
}

# Lê o conteúdo do arquivo ca.sh
script_content=$(cat /home/steam/ca.sh)

# Solicita ao usuário as informações necessárias
print_green "Digite o nome do servidor: "
read server_name
print_green "Digite a senha de rcon: "
read rcon_password
print_green "Digite a senha do qlstats: "
read stats_password
print_green "Digite sua Steam ID: "
read steam_id

# Substitui as partes relevantes do script com as informações inseridas pelo usuário
modified_content=$(echo "$script_content" \
    | sed -e "s/+set sv_hostname .*/+set sv_hostname \"$server_name\" \\\/" \
          -e "s/+set zmq_rcon_password .*/+set zmq_rcon_password \"$rcon_password\" \\\/" \
          -e "s/+set zmq_stats_password .*/+set zmq_stats_password \"$stats_password\" \\\/" \
          -e "s/+set qlx_owner .*/+set qlx_owner \"$steam_id\" \\\/")

# Salva o script modificado no mesmo arquivo ca.sh
echo "$modified_content" > /home/steam/ca.sh

# Torna o script ca.sh executável
chmod +x /home/steam/ca.sh
chown steam /home/steam/ca.sh
chown steam /home/steam/steamcmd/steamapps/common/qlds/baseq3/{clan.cfg,workshop.txt,mappool_ca.txt}


# limpando sujeiras
sudo rm -fr /tmp/minqlx-plugins/ /tmp/minqlx/ /tmp/quakelive/

echo -e "${GREEN}Configs copiadas com sucesso para /home/steam/steamcmd/steamapps/common/qlds/baseq3 e /home/steam/${NC} \n\"
sleep $timeout

# echo -e "${YELLOW}Iniciando servidor...${NC}"
# sleep $timeout

print_message() {
    local message="$1"
    for ((i = 1; i <= 4; i++)); do
        printf "${YELLOW}${message}${NC}"
        for ((j = 1; j <= i; j++)); do
            printf "."
        done
        printf "\n"
        sleep 1
    done
}

print_message "Iniciando servidor"

echo -e "${GREEN}SERVIDOR INICIADO${NC}"
sleep $timeout

echo -e "\n\
${RED}#################################################
${GREEN}## Digite: ${YELLOW}screen -r clanarena
${GREEN}##
${GREEN}## e você verá que seu servidor já está rodando.
## Para sair desse console e retornar ao terminal
## Linux sem fechar o servidor,
## pressione: ${YELLOW}CTRL A D
${GREEN}##
## Tudo junto. Ele vai continuar executando
## o servidor em background
## Para acessá-lo novamente,
##
## Digite: ${YELLOW}screen -r clanarena
${RED}#################################################"

sleep $timeout

su - steam <<EOF
cd /home/steam
screen -dmS clanarena
screen -S clanarena -X stuff 'bash /home/steam/ca.sh^M'
EOF
su - steam
