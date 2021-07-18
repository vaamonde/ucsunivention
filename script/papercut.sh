#!/bin/bash
# Autor: PaperCut KB
# Site: https://www.papercut.com/kb/Main/PapercutOnUnivention
# Site: https://www.univention.com/blog-en/2018/07/how-to-use-papercut-ng-on-ucs/
# Editado por: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 01/09/2018
# Data de atualização: 18/07/2021
# Versão: 0.2
# Testado e homologado para as versões do UCS Univention 4.2.x, 4.3.x, 4.4.x e 5.0.x
#
# O PaperCut NG é a maneira mais fácil de implementar um poderoso sistema de rastreamento e políticas
# de impressão, transformando o comportamento do usuário no local de trabalho. Você terá em suas mãos 
# dados e insights valiosos para ajudar na criação de uma nova cultura de impressão consciênte, além 
# de efetuar cortes de gastos significativos.
#
# Site PT-BR: https://www.papercut.com/pt-br/products/ng/
#
# Declarando as variáveis da instalação do Papercut no UCS Univention (atualizado em: 18/07/2021)
DOWNLOAD="https://cdn.papercut.com/web/products/ng-mf/installers/ng/21.x/pcng-setup-21.0.3.57216.sh"
USERNAME="papercut"
PASSWORD="$(papercut --chars=24)"
eval "$(ucr shell ldap/base)"
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# Script de instalação do Papercut no UCS Univention Core Free v5.0
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n"
#
echo -e "Instalação do Papercut NG no UCS Univention Core Free v5.0.x\n"
echo -e "Após a instalação do Papercut NG acessar a URL: https://`hostname -f | cut -d' ' -f1`:9192/admin\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
#
echo -e "Liberando as portas 9192 e 9191 de administração do Papercut, aguarde..."
	ucr set security/packetfilter/tcp/9192/all=ACCEPT
	ucr set security/packetfilter/tcp/9191/all=ACCEPT
	service univention-firewall restart
echo -e "Portas liberadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o usuário e grupo do PaperCut no UCS Univention, aguarde..."
	(echo $PASSWORD ; echo $PASSWORD) | adduser --home /usr/local/$USERNAME --gecos "Administrador do PaperCut" $USERNAME
echo -e "Usuário e grupo criado sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando a conta de administração do Papercut no LDAP do UCS Univention, aguarde..."
	univention-directory-manager users/user create --ignore_exists \
		--position "cn=users,$ldap_base" \
		--dn "uid=$USERNAME-ldap,cn=users,$ldap_base" \
		--set username="$USERNAME-ldap" \
		--set password="$PASSWORD" \
		--set firstname="$USERNAME" \
		--set lastname="Conta LDAP" \
		--set description="Conta usada pelo $USERNAME para se autenticar no diretório do LDAP" &&
echo -e "Conta de usuário: \"uid=$USERNAME-ldap,cn=users,$ldap_base\" com password: \"$PASSWORD\" criado com sucesso!!!, continuando com o script\n"
sleep 5
#
echo -e "Verificando as informações do usuário do Papercut no LDAP, aguarde...\n"
	# opção do comando read: -r (raw input), -p (prompt)
	read -r < /dev/tty -p  "Por favor, anote os detalhes da conta para configurar o acesso LDAP do PaperCut mais tarde. \
	Em seguida, pressione <Enter> para iniciar o processo de instalação do Papercut."
echo
sleep 5
#
echo -e "Baixando e executando o script de instalação do Papercut no UCS Univention, aguarde..."
	# opção do comando wget: -O (output file)
	# opção do comando sudo: -i (--login), -u (--user)
	wget $DOWNLOAD -O /tmp/papercut.sh
	sudo -iu $USERNAME /bin/bash /tmp/papercut.sh
echo -e "Papercut instalado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Rodando as tarefas de Root do Papercut, aguarde..."
	/usr/local/$USERNAME/MUST-RUN-AS-ROOT
echo -e "A instalação terminou e o servidor PaperCut deve começar em segundo plano."
sleep 5
#
echo -e "Verificando o Log de instalação do Papercut, aguarde...\n"
	# opção do comando read: -r (raw input), -p (prompt)
	# opção do comando tail: -f (flush)
	read -r < /dev/tty -p "Mostrando o Log do processo de instalação do Papercut. Pressione <Ctrl> -C para parar \
	a exibição do log do Papercut, pressione <Enter> para prosseguir."
	tail -f /usr/local/$USERNAME/server/logs/server.log
echo
sleep 5
#
echo -e "Verificando as portas de conexões do Papercut NG, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep ':9191\|:9192'
echo -e "Portas de conexões verificadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo "Para finalizar a instalação do Papercut NG, acesse a seguinte URL:"
	echo -e "https://`hostname -f | cut -d' ' -f1`:9192/admin"
sleep 5
#
echo -e "Instalação do Papercut NG feita com Sucesso!!!"
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n"
read
exit 1