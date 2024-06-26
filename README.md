
# Tutorial básico para criar  seu server de quakelive
# Instalado no UBUNTU **22.04**
# Instruções para subir em um Docker (container) no final do texto.

**IMPORTANTE: VOCÊ DEVE LIBERAR A INTERNET DO SERVIDOR POIS ELE VAI FAZER DOWNLOAD, ATUALIZAÇAO, ETC E AS PORTAS DO SERVIDOR QUE FOR UTILIZAR (27960 UDP/TCP)**


**Vídeo do tutorial abaixo**  (Clique para abrir em uma nova guia)
[![TUTORIAL](https://github.com/philipecella/quakelive/assets/79929640/432f68c3-262b-447a-92b2-73dd9985cb42 "TUTORIAL")](https://www.youtube.com/watch?v=1X8Tqxc4Qcw "TUTORIAL")


Eu criei um script para facilitar a vida na criação do servidor.

O que o script vai fazer?

- Criar usuário chamado steam
- Instalar o pacote Screen (que é onde os servers rodam em background)
- Instala o steamcmd
- Instala o quakelive server
- Instala Minqlx e suas dependências
- Cria config do clan arena
- Cria o executavel do clan arena

**Como começar?**

Digite no seu servidor linux:

    sudo su

para você entrar como root e não ter problemas para instalar os pacotes, etc

- Durante a instalação, ele vai te pedir para setar:
- Nome do servidor (Hostname), 
- Senha do Rcon (usado para gerenciar remotamente) e,
- Senha do QLSTATS (para cadastrar no site qlstats.net)
- Sua SteamID



depois digite o comando:

    wget https://raw.githubusercontent.com/philipecella/quakelive/main/instalarservidor.sh

Ele vai baixar o arquivo **[instalarservidor.sh](https://raw.githubusercontent.com/philipecella/quakelive/main/instalarservidor.sh)**

Rode o comando:

    sudo chmod +x instalarservidor.sh
para dar permissão de execução no script.

Depois execute o comando:

    sudo ./instalarservidor.sh


Os dados que o instalador vai te pedir serão salvas em:

    /home/steam/ca.sh

Para edita-las posteriormente, digite

    nano /home/steam/ca.sh


------------
# Virar OWNER - ache o seu steamID caso não saiba

Caso você não saiba qual é sua steamid, use o site:
https://www.steamidfinder.com/
coloque seu link da sua steam ou url personalizada e ele vai trazer seu steamID:
Copie os numeros do campo `steamID64 (Dec):` que ele vai fornecer e coloque no arquivo ca.sh




![image](https://github.com/philipecella/quakelive/assets/79929640/926514dc-72ef-4544-9269-45abbd6c915c)

digite `!myperm` no servidor para verificar se você é o **Owner**

------------
# Cadastrar server para contabilizar elo

A senha que você setou durante a instalação e que também se encontra no arquivo ca.sh será usada para contabilizar o ELO no site:

https://qlstats.net/panel1/servers.html

Clique no botão Add Server e em seguida preencha com os dados que você setou em ca.sh (localizados em /home/steam/ca.sh)

![image](https://github.com/philipecella/quakelive/assets/79929640/01972792-3006-461c-90aa-766472b01c50)



Adiciona o ip, a porta e a senha do arquivo.

------------

Os comandos para você gerenciar seu servidor são:

**screen -ls** (ele exibe a lista de janelas rodando em background)
![image](https://github.com/philipecella/quakelive/assets/79929640/4b7dc365-09e0-45c1-8393-63d24c9ab3c5)


Note que ele está com status de: (Detached)

Para acessar ela, digite:
**screen -r clanarena**

![image](https://github.com/philipecella/quakelive/assets/79929640/99e33042-53c6-45b7-866a-17b1e7bbafbd)

digite:

**./ca.sh**

para voltar a tela anterior e manter seu servidor rodando, pressione CTRL seguido de A D

`CTRL A D`

que ele volta para a tela anterior como (Detached)


------------


# Instruções básicas:
Caso você precise alterar as informações, como steamid, senha do qlstats,
você pode usar o comando nano

**nano /home/steam/ca.sh**

ou mudar configurações na config do servidor:

**nano /home/steam/steamcmd/steamapps/common/qlds/baseq3/clan.cfg**

e reinicie o servidor após mudar esses dados.

acesse o servidor com: screen -r clanarena

**digite QUIT**

e pressione **CTRL C**

ele vai retornar a tela do console do linux, e você executa novamente

**./ca.sh**


-----------------


# Clone o repositorio
git clone https://github.com/philipecella/quakelive.git

# Acesse a pasta do Docker
cd docker

# Crie sua imagem
docker build -t qliveserver .

# Execute o redis
docker run -d --name redis -v ql-redis:/data redis

# Rode o server de quakelive e aguarde
docker run -d \
  -e SERVER_NAME="Digite o Hostname Aqui" \
  -e RCON_PASSWORD="Defina sua Rcon" \
  -e STATS_PASSWORD="Defina a senha do qlstats" \
  -e STEAM_ID="coloque sua steam id" \
  --link redis \
  --name qliveserver \
  -p 27960:27960/udp \
  -p 28960:28960/tcp \
  qliveserver

# Comando par acompanhar o servidor ser criado
docker logs -f qliveserver



