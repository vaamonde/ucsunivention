@echo off
rem Site Oficial do Script: https://docs.microsoft.com/pt-br/troubleshoot/windows-client/system-management-components/rsat-client-missing-dns-server-tool
rem Modificado por: Robson Vaamonde
rem Procedimentos em TI: http://procedimentosemti.com.br
rem Bora para Prática: http://boraparapratica.com.br
rem Robson Vaamonde: http://vaamonde.com.br
rem Facebook Procedimentos em TI: https://www.facebook.com/ProcedimentosEmTi
rem Facebook Bora para Prática: https://www.facebook.com/BoraParaPratica
rem Instagram Procedimentos em TI: https://www.instagram.com/procedimentoem
rem YouTUBE Bora Para Prática: https://www.youtube.com/boraparapratica
rem LinkedIn Robson Vaamonde: https://www.linkedin.com/in/robson-vaamonde-0b029028/
rem Data de criação: 14/07/2021
rem Data de atualização: 14/07/2021
rem Versão: 0.01
rem Testado e homologado no UCS Univention Core Free 5.0.x e Windows 10 Pro
echo Data/hora de início do script: %date% - %time%

echo Criando o diretório de extração do arquivo do RSAT
md ex

echo Extraindo o conteúdo do arquivo do RSAT no diretório: ex\
expand -f:* WindowsTH-RSAT_WS_1709-x64.msu ex\

echo Acessando o diretório: ex\ e criando o subdiretório: ex\
cd ex
md ex

echo Copiando o arquivo: unattend_x64.xml para o diretório: ex\
copy ..\unattend_x64.xml ex\

echo Extraindo o arquivo CAB do RSAT para o subdiretório: ex\
expand -f:* WindowsTH-KB2693643-x64.cab ex\

echo Aplicando o Patch de Correção do DNS no instalador do RSAT
cd ex
dism /online /apply-unattend="unattend_x64.xml"

echo Instalando o RSAT com o Patch de Correção do DNS, aguarde...
cd ..\
dism /online /Add-Package /PackagePath:"WindowsTH-KB2693643-x64.cab"

echo Removendo o diretório: ex\
cd ..\
rmdir ex /s /q

echo Fim do processo de instalação do RSAT no Windows 10 Pro
echo Data/hora de início do script: %date% - %time%