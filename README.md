
# Tutorial básico para criar  seu server de quakelive

**IMPORTANTE: VOCÊ DEVE LIBERAR AS PORTAS DO SERVIDOR NO FIREWALL DE ONDE VOCÊ FOR RODAR, 
PORTAS UDP/TCP, A PORTA 27960 É PADRÃO QUE VAMOS USAR AQUI.**

Eu criei um script para facilitar a vida na criação do servidor.

**Como começar?**

Digite no seu servidor linux:

`wget https://raw.githubusercontent.com/philipecella/quakelive/main/instalarservidor.sh`

Ele vai baixar o arquivo **[instalarservidor.sh](https://raw.githubusercontent.com/philipecella/quakelive/main/instalarservidor.sh)**

Rode o comando:`sudo chmod +x instalarservidor.sh`
para dar permissão de execução no script.

Depois execute o comando:
`sudo ./instalarservidor.sh`

O que o script vai fazer?

- Criar usuário chamado steam (com a senha steam depois você **deve** alterar, se quiser)
- Instalar o pacote Screen (que é onde os servers rodam em background)
- Instala o steamcmd
- Instala o quakelive server
- Instala Minqlx e suas dependências
- Cria config do clan arena
- cria o executavel do clan arena

Após tudo estar funcionando bonitinho, você precisa alterar algumas informações 

`zmq_stats_password "SuaSenha1"`

pois essa senha será usada para contabilizar o ELO no site:

https://qlstats.net/panel1/servers.html

Clique no botão Add Server e em seguida preencha com os dados que você setou em ca.sh (localizados em /home/steam/ca.sh)

![image](https://github.com/philipecella/quakelive/assets/79929640/01972792-3006-461c-90aa-766472b01c50)



Adiciona o ip, a porta e a senha do arquivo.

e por último, você deve alterar a linha
`qlx_owner "sua_steam_id"`
com seu steamID para você ter permissão total no servidor
Caso você não saiba qual é sua steamid, use o site:
https://www.steamidfinder.com/
coloque seu link da sua steam ou url personalizada e ele vai trazer seu steamID:
Copie os numeros do campo `steamID64 (Dec):` que ele vai fornecer e coloque no arquivo ca.sh




![image](https://github.com/philipecella/quakelive/assets/79929640/926514dc-72ef-4544-9269-45abbd6c915c)

digite `!myperm` no servidor para verificar se você é o **Owner**



Os comandos para você gerenciar seu servidor são:

**screen -ls** (ele exibe a lista de janelas rodando em background)
![image](https://github.com/philipecella/quakelive/assets/79929640/4b7dc365-09e0-45c1-8393-63d24c9ab3c5)


Note que ele está com status de: (Detached)

Para acessar ela, digite:

**screen -r clanarena**

![image](https://github.com/philipecella/quakelive/assets/79929640/99e33042-53c6-45b7-866a-17b1e7bbafbd)

Agora ela está como (Attached)

dai é só navegar na pasta **cd /home/steam/**

lá você vai encontrar o arquivo chamado 
**ca.sh**
digite:

**./ca.sh**

e seu servidor vai rodar

para voltar a tela anterior e manter seu servidor rodando, pressione CTRL seguido de A D

`CTRL A D`

que ele volta para a tela anterior como (Detached)



