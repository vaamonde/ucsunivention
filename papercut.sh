#!/bin/bash
# Autor: PaperCut KB
# Site: https://www.papercut.com/kb/Main/PapercutOnUnivention
# Editado por: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 01/09/2018
# Data de atualização: 23/10/2018
# Versão: 0.1
# Testado e homologado para as versões do UCS Univention 4.2.x 4.3.x

#Declarando as variáveis da instalação 
APP="papercut"
password="$(papercut --chars=24)"
eval "$(ucr shell ldap/base)"

#Habilitando as regras de firewall do UCS Univention para permitir o Papercut
#Liberando as portas 9192 e 9191
ucr set security/packetfilter/tcp/9192/all=ACCEPT
ucr set security/packetfilter/tcp/9191/all=ACCEPT
service univention-firewall restart

#Criando o usuário e grupo no GNU/Linux do PaperCut
(echo $passward ; echo $password)|adduser --home /usr/local/$APP --gecos "Administrador do PaperCut" $APP

#Criando a conta dedicada para se conectar com o LDAP do Papercut
univention-directory-manager users/user create --ignore_exists \
    --position "cn=users,$ldap_base" \
    --dn "uid=$APP-ldap,cn=users,$ldap_base" \
    --set username="$APP-ldap" \
    --set password="$password" \
    --set firstname="$APP" \
    --set lastname="Conta LDAP" \
    --set description="Conta usada pelo $APP para autenticar no diretório do LDAP" &&
echo "Conta de usuário \"uid=$APP-ldap,cn=users,$ldap_base\" criada com o password \"$password\""
read -r < /dev/tty -p  "Por favor, anote os detalhes para configurar o acesso ldap do PaperCut mais tarde. Em seguida, pressione qualquer tecla para iniciar o processo de instalação"
echo

#Rodando o script de instalação do Papercut
#O mesmo já deve ter sido baixado do site para começar o processo de instalação
sudo -iu $APP /bin/bash /tmp/pc*-setup*linux-x64.sh

#Rodando as tarefas de Root
echo "Agora executando as tarefas de Root"
echo
/usr/local/$APP/MUST-RUN-AS-ROOT

echo "A instalação terminou e o servidor PaperCut deve começar em segundo plano."
read -r < /dev/tty -p "Mostrando agora o log do progresso de instalação. Pressione <Ctrl> -C para parar a exibição do log. Aperte qualquer tecla para prosseguir..."

tail -f /usr/local/$APP/server/logs/server.log
echo

echo "Para finalizar a instalação, acesse a seguinte URL:"
echo -e "https://`hostname`:9192/admin"
