
# Tutorial básico para criar  seu server de quakelive

Eu criei um script para facilitar a vida na criação do servidor.

**Como começar?**

Digite no seu servidor linux:
`wget https://raw.githubusercontent.com/philipecella/quakelive/main/instalar_servidor.sh`

Ele vai baixar o arquivo **[instalar_servidor.sh](https://raw.githubusercontent.com/philipecella/quakelive/main/instalar_servidor.sh")**
Rode o comando:`chmod +x instalar_servidor.sh `
para dar permissão de execução no script.

Depois execute o comando: `sudo ./instalar_servidor.sh`

O que o script vai fazer?

- Criar usuário chamado steam (com a senha steam depois você **deve** alterar, se quiser)
- Instalar o pacote Screen (que é onde os servers rodam em background)
- Instala o steamcmd
- Instala o quakelive server
- Instala Minqlx e suas dependências
- Cria config do clan arena
- cria o executavel do clan arena

Como começar?

Digite no seu servidor linux:
`wget https://raw.githubusercontent.com/philipecella/quakelive/main/instalar_servidor.sh`
Após tudo estar funcionando bonitinho, você precisa alterar algumas informações, como o 
`zmq_stats_password "SuaSenha1"`

pois essa senha será usada para contabilizar o ELO no site:
https://qlstats.net/panel1/servers.html

Adiciona o ip, a porta e a senha do arquivo.

e por último, você deve alterar a linha
`qlx_owner "sua_steam_id"`
com seu steamID para você ter permissão total no servidor
digite `!myperm` no servidor para verificar se você é o **Owner**
