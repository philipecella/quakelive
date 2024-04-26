#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
timeout=3

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
echo -e "${YELLOW}Instalando Screen...${NC}"
apt-get install screen -y
echo -e "${GREEN}Screen instalado com sucesso.${NC}"

# Instalação do STEAMCMD
apt-get install lib32z1 lib32stdc++6 -y

# Cria o diretório e faz o download do SteamCMD
su - steam -c 'mkdir -p ~/steamcmd && cd ~/steamcmd && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz'
echo -e "${GREEN}SteamCMD instalado${NC}"
sleep $timeout

# Instalação do Quake Live Server
echo -e "${YELLOW}Instalando Quake Live Server...${NC}"
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
echo -e "${YELLOW}Atualizando os pacotes do sistema...${NC}"
apt-get update

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
apt-get -y install redis-server git build-essential

echo -e "${GREEN}Redis, Git e build essentials instalados com sucesso.${NC}"
sleep $timeout

# Clone o repositório do minqlx
echo -e "${RED}Clonando o repositório do minqlx...${NC}"
git clone https://github.com/MinoMino/minqlx.git /tmp/minqlx/
cd /tmp/minqlx/

# Compila o minqlx
echo -e "${RED}Compilando o minqlx...${NC}"
make

echo -e "${GREEN}Minqlx compilado com sucesso.${NC}"

sleep $timeout

# Diretório do servidor Quake Live
QLDS_DIR="/home/steam/steamcmd/steamapps/common/qlds"

# Verifica se o diretório existe, caso contrário, cria
mkdir -p "$QLDS_DIR"

# Copia os arquivos do minqlx para o diretório do servidor Quake Live
cp -r /tmp/minqlx/bin/* "$QLDS_DIR"

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

echo -e "${RED}Baixando a config e executavel do clan arena${NC}"

echo -e "${RED}Baixando os plugins que eu uso no meu server agora${NC}"

# Clona o repositório
git clone https://github.com/philipecella/minqlx-plugins.git /tmp/minqlx-plugins

# Copia os arquivos .py para o destino desejado e substitui os existentes
cp -r /tmp/minqlx-plugins/*.py /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins

echo "Arquivos copiados com sucesso para /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins."


# Clona o repositório
mkdir /tmp/
git clone https://github.com/philipecella/quakelive.git /tmp/quakelive/

# Copia o arquivo clan.cfg para o diretório desejado

cp /tmp/quakelive/{clan.cfg,workshop.txt,mappool_ca.txt} /home/steam/steamcmd/steamapps/common/qlds/baseq3/

cp /tmp/quakelive/ca.sh /home/steam/
chmod +x /home/steam/ca.sh
chown steam /home/steam/ca.sh
chown steam /home/steam/steamcmd/steamapps/common/qlds/baseq3/{clan.cfg,workshop.txt,mappool_ca.txt}


# limpando sujeiras
sudo rm -fr /tmp/minqlx-plugins/ /tmp/minqlx/ /tmp/quakelive/

echo "Configs copiadas com sucesso para /home/steam/steamcmd/steamapps/common/qlds/baseq3 e /home/steam/"

echo -e "${GREEN}para iniciar seu servidor, digite: screen -r clanarena\n\
acesse o diretório: cd /home/steam\n\
e execute o arquivo ./ca.sh\n\
para sair do console sem fechá-lo, pressione CTRL A D tudo junto\n\
Ele vai continuar executando o servidor em background, para acessá-lo, digite novamente:\n\
screen -r clanarena${NC}\n\n\
${YELLOW}Só jogar agora!${NC}"

su - steam <<EOF
cd /home/steam
screen -dmS clanarena
EOF
su - steam
