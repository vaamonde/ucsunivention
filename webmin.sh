# Fazendo o Download do Pacote do Webmin
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.860_all.deb

# Ativando os Repositórios não mantidos do UCS Univention
ucr set repository/online/unmaintained='yes'

# Verificando o source.list se foi criado com sucesso.
cat /etc/apt/sources.list.d/15_ucs-online-version.list

# Instalando as dependências do Webmin
univention-install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

# Instalando o Webmin
dpkg -i webmin_1.860_all.deb

# Abrindo a Porta 10000
ucr set security/packetfilter/package/webmin/tcp/10000/all=ACCEPT

# Reinicializando o Firewall
/etc/init.d/univention-firewall restart

# Reinicializando o Servidor
shutdown -r now

# Verificando o serviço do Webmin
sudo service webmin status
