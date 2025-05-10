@echo off
setlocal EnableDelayedExpansion

:: =========================================================
:: Script de Seleção de Versões isCOBOL 
:: =========================================================

:: Configurações Gerais
set "ISCOBOL_BASE=C:\isCOBOL"
set "ISCOBOL_JDK_ROOT=C:\Program Files\Java\jdk-21"
set "ISCOBOL_JRE_ROOT=C:\Program Files\Java\jre1.8.0_451"
set "EXE4J_JAVA_HOME=C:\iscobol\jre"

:: Salvar variáveis originais
set "ORIGINAL_PATH=%PATH%"
set "ORIGINAL_CLASSPATH=%CLASSPATH%"
set "ORIGINAL_LIBRARY_PATH=%LD_LIBRARY_PATH%"

:: Configuração da janela
title Gerenciador de acesso as Lojas 
::mode con cols=68 lines=25
color 0e

:: Constantes
set "LINE===================================="

:: Mapeamento de lojas (ID: Nome|Host|Port|Version)
set "STORE_COUNT=21"
set "STORES[1]= Gil|45.166.152.54|10999|2023R2"
set "STORES[2]= Casa Pronta|casapronta.dyndns.org|10999|2023R2"
set "STORES[3]= Jisam|177.45.80.10|41133|2024R2"
set "STORES[4]= Dmaker|177.45.80.10|10999|2024R2"
set "STORES[5]= Diten - VPN|192.168.100.244|10999|2023R2"
set "STORES[6]= Fat|177.45.80.10|41133|2024R2"
set "STORES[7]= Kalebre|169.169.69.69|10999|2024R2"
set "STORES[8]= Atual - VPN|10.10.10.14|10999|2023R2"
set "STORES[9]= Dishelp|dishelp.dyndns.org|10999|2023R2"
set "STORES[10]= Jtelecom|jotatelecom.homelinux.com|10999|2023R2"
set "STORES[11]= Cheddar|52.67.103.231|10999|2023R2"
set "STORES[12]= Titan - VPN|192.168.15.101|10999|2020R2"
set "STORES[13]= Titan Loja - VPN|192.168.15.101|11888|2020R2"
set "STORES[14]= Patricia - VPN|192.168.1.199|10999|2023R2"
set "STORES[15]= PatriciaMW - VPN|192.168.1.199|11888|2023R2"
set "STORES[16]= 2Leoes|186.192.97.112|10999|2023R2"
set "STORES[17]= Dep.Lima|depositolima.homelinux.com|10999|2023R2"
set "STORES[18]= LA - VPN|192.168.50.100|10999|2020R2"
set "STORES[19]= Vilas Boas|189.84.75.140|10999|2020R2"
set "STORES[20]= Real Pecas|192.168.1.100|10999|2020R2"
set "STORES[21]= Lojao Itapua|lojaoitapua.dyndns.org|10999|2020R2"

:: Menu principal
:MAIN_MENU
cls
echo %TIME% %DATE%
echo %LINE%
echo ^|    SELECIONE UMA OPCAO          ^|
echo %LINE%
echo ^|   1) Conectar a Loja            ^|
echo ^|   2) Acessar Painel             ^|
echo ^|   0) Sair                       ^|
echo %LINE%
set "CHOICE="
set /p "CHOICE=Digite a opcao: "

:: Validação da entrada
if "%CHOICE%"=="1" goto STORE_MENU
if "%CHOICE%"=="2" goto PANEL_MENU
if "%CHOICE%"=="0" goto CLEANUP_EXIT
echo Opcao invalida!
ping -n 3 127.0.0.1 >nul
goto MAIN_MENU

:: Menu de Lojas
:STORE_MENU
cls
echo %TIME% %DATE%
echo %LINE%
echo ^|   SELECIONE A LOJA              ^|
echo %LINE% 
echo ^|   1) Gil                        ^|
echo ^|   2) Casa Pronta                ^|
echo ^|   3) Jisam                      ^|
echo ^|   4) Dmaker                     ^|
echo ^|   5) Diten - VPN                ^|
echo ^|   6) Fat                        ^|
echo ^|   7) Kalebre                    ^|
echo ^|   8) Atual                      ^|
echo ^|   9) Dishelp                    ^|
echo ^|  10) Jtelecom                   ^|
echo ^|  11) Cheddar                    ^|
echo ^|  12) Titan - VPN                ^|
echo ^|  13) Titan Loja - VPN           ^|
echo ^|  14) Patricia - VPN             ^|
echo ^|  15) PatriciaMW - VPN           ^|
echo ^|  16) 2Leoes                     ^|
echo ^|  17) Dep.Lima                   ^|
echo ^|  18) LA - VPN                   ^|
echo ^|  19) Vilas Boas                 ^|
echo ^|  20) Real Pecas                 ^|
echo ^|  21) Lojao Itapua               ^|
echo ^|   0) Voltar                     ^|
echo %LINE%
set "STORE_ID="
set /p "STORE_ID=Digite o numero da loja: "

:: Validação da entrada
if "%STORE_ID%"=="0" goto MAIN_MENU
set /a STORE_ID_NUM=STORE_ID 2>nul
if !STORE_ID_NUM! GEQ 1 if !STORE_ID_NUM! LEQ %STORE_COUNT% (
    call :SET_CONNECTION !STORE_ID_NUM!
    if errorlevel 1 (
        echo [ERRO] Falha ao configurar conexão
        pause
        goto STORE_MENU
    )
    goto RUN_CLIENT
)
echo Numero de loja invalido!
ping -n 3 127.0.0.1 >nul
goto STORE_MENU

:: Menu de Painel
:PANEL_MENU
cls
echo %TIME% %DATE%
echo %LINE%
echo ^|    SELECIONE O PAINEL           ^|
echo %LINE%
echo ^|   1) Gil                        ^|
echo ^|   2) Casa Pronta                ^|
echo ^|   3) Jisam                      ^|
echo ^|   4) Dmaker                     ^|
echo ^|   5) Diten - VPN                ^|
echo ^|   6) Fat                        ^|
echo ^|   7) Kalebre                    ^|
echo ^|   8) Atual                      ^|
echo ^|   9) Dishelp                    ^|
echo ^|  10) Jtelecom                   ^|
echo ^|  11) Cheddar                    ^|
echo ^|  12) Titan - VPN                ^|
echo ^|  13) Titan Loja - VPN           ^|
echo ^|  14) Patricia - VPN             ^|
echo ^|  15) PatriciaMW - VPN           ^|
echo ^|  16) 2Leoes                     ^|
echo ^|  17) Dep.Lima                   ^|
echo ^|  18) LA - VPN                   ^|
echo ^|  19) Vilas Boas                 ^|
echo ^|  20) Real Pecas                 ^|
echo ^|  21) Lojao Itapua               ^|
echo ^|   0) Voltar                     ^|
echo %LINE%
set "PANEL_ID="
set /p "PANEL_ID=Digite o numero do painel: "

:: Validação da entrada
if "%PANEL_ID%"=="0" goto MAIN_MENU
set /a PANEL_ID_NUM=PANEL_ID 2>nul
if !PANEL_ID_NUM! GEQ 1 if !PANEL_ID_NUM! LEQ %STORE_COUNT% (
    call :SET_CONNECTION !PANEL_ID_NUM!
    if errorlevel 1 (
        echo [ERRO] Falha ao configurar conexão
        pause
        goto PANEL_MENU
    )
    goto RUN_PANEL
)
echo Numero de painel invalido!
ping -n 3 127.0.0.1 >nul
goto PANEL_MENU

:: Configurar conexão
:SET_CONNECTION
set "ID=%1"
set "STORE_LINE=!STORES[%ID%]!"
if not defined STORE_LINE (
    echo [ERRO] Loja/Painel ID %ID% não encontrado
    exit /b 1
)
for /F "tokens=1-4 delims=|" %%a in ("!STORE_LINE!") do (
    set "STORE_NAME=%%a"
    set "HOST=%%b"
    set "PORT=%%c"
    set "VERSION=%%d"
)
if not defined HOST (
    echo [ERRO] Falha ao configurar HOST
    exit /b 1
)
if not defined PORT (
    echo [ERRO] Falha ao configurar PORT
    exit /b 1
)
if not defined VERSION (
    echo [ERRO] Falha ao configurar VERSION
    exit /b 1
)
exit /b 0

:: Configurar ambiente
:SETUP_ENVIRONMENT
set "ISCOBOL_PATH=%ISCOBOL_BASE%\%VERSION%"
set "PATH=%ISCOBOL_PATH%\bin;%ORIGINAL_PATH%"
set "CLASSPATH=.;%ISCOBOL_PATH%\lib;%ORIGINAL_CLASSPATH%"
set "LD_LIBRARY_PATH=%ISCOBOL_PATH%\bin;%ORIGINAL_LIBRARY_PATH%"

if not exist "%ISCOBOL_PATH%\bin\isclient.exe" (
    echo [ERRO] Arquivo isclient.exe nao encontrado em:
    echo %ISCOBOL_PATH%\bin
    pause
    exit /b 1
)
exit /b 0

:: Executar cliente
:RUN_CLIENT
if errorlevel 1 goto CLEANUP_EXIT
call :SETUP_ENVIRONMENT
if errorlevel 1 goto CLEANUP_EXIT

start "isCOBOL Client - %STORE_NAME%" /B "%ISCOBOL_PATH%\bin\isclient.exe" ^
-J-Discobol.encoding=CP860 ^
-J-Dfile.encoding=CP860 ^
-hostname %HOST% ^
-port %PORT% ^
SPS800
if errorlevel 1 (
    echo [ERRO] Falha ao iniciar o cliente isCOBOL
    pause
)
goto CLEANUP_EXIT

:: Executar painel
:RUN_PANEL
if errorlevel 1 goto CLEANUP_EXIT
call :SETUP_ENVIRONMENT
if errorlevel 1 goto CLEANUP_EXIT

start "isCOBOL Panel - %STORE_NAME%" /B "%ISCOBOL_PATH%\bin\isclient.exe" ^
-J-Discobol.encoding=CP860 ^
-J-Dfile.encoding=CP860 ^
-hostname %HOST% ^
-port %PORT% ^
-panel
if errorlevel 1 (
    echo [ERRO] Falha ao iniciar o panel isCOBOL
    pause
)
goto CLEANUP_EXIT

:: Limpeza e saída
:CLEANUP_EXIT
set "HOST="
set "PORT="
set "VERSION="
set "STORE_ID="
set "PANEL_ID="
set "CHOICE="
set "ISCOBOL_PATH="
set "PATH=%ORIGINAL_PATH%"
set "CLASSPATH=%ORIGINAL_CLASSPATH%"
set "LD_LIBRARY_PATH=%ORIGINAL_LIBRARY_PATH%"
set "ORIGINAL_PATH="
set "ORIGINAL_CLASSPATH="
set "ORIGINAL_LIBRARY_PATH="
set "STORE_NAME="
set "STORE_LINE="
endlocal
exit