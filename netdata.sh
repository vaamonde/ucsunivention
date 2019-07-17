# Ativando os Repositórios não mantido do UCS Univention
ucr set repository/online/unmaintained='yes'

# Instalando as dependências do Netdata
univention-install zlib1g-dev uuid-dev libmnl-dev gcc make git autoconf autoconf-archive autogen automake pkg-config curl

# Fazendo o clone do projeto do Netdata do Github
git clone https://github.com/firehol/netdata.git --depth=1

# Acessando a pasta
cd netdata

# Rodando o script de instalação
./netdata-installer.sh

# Abrindo a Porta 19999
ucr set security/packetfilter/package/netdata/tcp/19999/all=ACCEPT

# Reinicializando o Firewall
/etc/init.d/univention-firewall restart

# Reinicializando o Servidor
shutdown -r now

# Verificando o serviço do Netdata
sudo service netdata status
