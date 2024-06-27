FROM ubuntu:22.04

# Define o frontend do Debian como não interativo
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza os pacotes do sistema
RUN apt-get update -y && apt-get upgrade -y

# Instala pacotes necessários
RUN apt-get install -y \
    lib32z1 \
    lib32stdc++6 \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    git \
    build-essential

# Cria o usuário steam
RUN useradd -m -s /bin/bash steam && echo "steam:steam123" | chpasswd

# Muda o usuário para steam
USER steam

# Define o diretório de trabalho
WORKDIR /home/steam

# Instala o SteamCMD
RUN mkdir -p /home/steam/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -P /home/steam/steamcmd/

# Verifica se o arquivo foi baixado corretamente
RUN ls -la /home/steam/steamcmd

# Extrai o SteamCMD
RUN tar -xvzf /home/steam/steamcmd/steamcmd_linux.tar.gz -C /home/steam/steamcmd && \
    rm /home/steam/steamcmd/steamcmd_linux.tar.gz

# Instala o Quake Live Server
RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/steamcmd/steamapps/common/qlds/ +login anonymous +app_update 349090 +quit

USER root
# Instala o minqlx
RUN git clone https://github.com/MinoMino/minqlx.git /tmp/minqlx && \
    cd /tmp/minqlx && \
    make && \
    cp -r /tmp/minqlx/bin/* /home/steam/steamcmd/steamapps/common/qlds

# Atualiza os pacotes do sistema
RUN apt-get update -y

# Clona os plugins minqlx e instala dependências Python
RUN git clone https://github.com/MinoMino/minqlx-plugins /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins && \
    pip install -r /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins/requirements.txt

RUN chown steam -R /home/steam/steamcmd/

# Baixa configurações adicionais
RUN git clone https://github.com/philipecella/minqlx-plugins /tmp/minqlx-plugins && \
    cp -r /tmp/minqlx-plugins/*.py /home/steam/steamcmd/steamapps/common/qlds/minqlx-plugins && \
    git clone https://github.com/philipecella/quakelive.git /tmp/quakelive && \
    ls -la /tmp/quakelive && \
    cp /tmp/quakelive/clan.cfg /home/steam/steamcmd/steamapps/common/qlds/baseq3/ && \
    cp /tmp/quakelive/workshop.txt /home/steam/steamcmd/steamapps/common/qlds/baseq3/ && \
    cp /tmp/quakelive/mappool_ca.txt /home/steam/steamcmd/steamapps/common/qlds/baseq3/ && \
    cp /tmp/quakelive/ca.sh /home/steam && \
    chmod +x /home/steam/ca.sh

# Define as permissões e limpa arquivos temporários
RUN rm -rf /tmp/minqlx /tmp/minqlx-plugins /tmp/quakelive

# Exponha a porta do Quake Live Server
EXPOSE 27960/udp
EXPOSE 27980/tcp

# Script de entrada
COPY entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

# Define o comando padrão a ser executado quando o contêiner for iniciado
ENTRYPOINT ["/home/steam/entrypoint.sh"]