#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 23/10/2017
# Data de atualização: 23/10/2017
# Versão: 0.1
# Testado e homologado para a versão do UCS Univention Corporate Server (Core Free) UCS 4.2 UMC 9.0
# Kernel >= 4.9.x
#
#Criação das variáveis globais e parâmetros utilizadas pelos scripts de instalação

#Identificação do Usuário logado
USUARIO="`id -u`"

#Indentificação do usuário Root
ROOT="0"

