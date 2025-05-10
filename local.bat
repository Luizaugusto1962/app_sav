@echo off
setlocal EnableDelayedExpansion
:: =========================================================
:: Script de Seleção de Versões isCOBOL
:: =========================================================
:: Descrição: Permite selecionar versões do isCOBOL e conectar
:: a diferentes portas de servidores ou painéis.
:: =========================================================
:: ---------------- Configuração ----------------
:: Caminhos para Java e isCOBOL
set "JAVA_JDK=C:\Program Files\Java\jdk-21"
set "JAVA_JRE=C:\Program Files\Java\jre1.8.0_451"
set "EXE4J_JAVA_HOME=C:\iscobol\jre"
set "ISCOBOL_BASE=C:\isCOBOL"

:: Versões disponíveis do isCOBOL
set "VERSION_1=2024R2"
set "VERSION_2=2023R2"
set "VERSION_3=2020R2"
set "VERSION_4=2018R2"

:: Encoding padrão (pode ser alterado se necessário)
set "ENCODING=CP860"

:: Diretório de logs
set "LOG_DIR=logs"

:: Timeout para entrada de menu (em segundos)
set "MENU_TIMEOUT=30"

:: Linhas de formatação
set "line======================"
set "line2=================================="

:: Salvar variáveis de ambiente originais
set "oldPATH=%PATH%"
set "oldCLASSPATH=%CLASSPATH%"
set "oldLIBRARYPATH=%LD_LIBRARY_PATH%"

:: Configuração da janela do console
title Menu de Selecao isCOBOL
mode con cols=66 lines=30
color e0

:: ---------------- Menu Principal ----------------
:menu_versao
cls
echo %time% %date%
echo   %line%
echo  ^| Selecione a Versao ^|
echo   %line%
echo  ^|  1) !VERSION_1!     
echo  ^|  2) !VERSION_2!      
echo  ^|  3) !VERSION_3!    
echo  ^|  4) !VERSION_4!     
echo  ^|  0) Sair        
echo   %line%
echo.
set "op_vesao="
set /p "op_vesao=Qual versao vai usar? [Timeout em %MENU_TIMEOUT%s] "
if not defined op_vesao (
    echo Timeout! Retornando ao menu...
    timeout /t 2 >nul
    goto menu_versao
)

:: Validação e configuração da versão
if "!op_vesao!"=="0" goto limpar_sair
if "!op_vesao!"=="1" set "ISCOBOL=%ISCOBOL_BASE%\!VERSION_1!"& goto configure_java
if "!op_vesao!"=="2" set "ISCOBOL=%ISCOBOL_BASE%\!VERSION_2!"& goto configure_java
if "!op_vesao!"=="3" set "ISCOBOL=%ISCOBOL_BASE%\!VERSION_3!"& goto configure_java
if "!op_vesao!"=="4" set "ISCOBOL=%ISCOBOL_BASE%\!VERSION_4!"& goto configure_java
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto menu_versao

:: ---------------- Configuração do Ambiente Java ----------------
:configure_java
:: Validar caminhos Java e isCOBOL
if not exist "%JAVA_JDK%" (
    echo Erro: JDK nao encontrado em %JAVA_JDK%
    timeout /t 3 >nul
    goto limpar_sair
)
if not exist "%JAVA_JRE%" (
    echo Erro: JRE nao encontrado em %JAVA_JRE%
    timeout /t 3 >nul
    goto limpar_sair
)
if not exist "%ISCOBOL%" (
    echo Erro: Diretorio isCOBOL nao encontrado em %ISCOBOL%
    timeout /t 3 >nul
    goto limpar_sair
)

set "ISCOBOL_JDK_ROOT=%JAVA_JDK%"
set "ISCOBOL_JRE_ROOT=%JAVA_JRE%"
goto select_port_client

:: ---------------- Seleção de Porta ----------------
:LISTA_OPCAO
::echo %time% %date%
echo   %line2%
echo  ^|  Selecione a Porta             ^|
echo   %line2%
echo  ^|  1) Servidor Local             ^|
echo  ^|  2) Servidor Luizzy.dyndns     ^|
echo  ^|  3) Teste 1                    ^|
echo  ^|  4) Teste 2                    ^|
echo  ^|  99) Panel                     ^|
echo  ^|   0) Voltar                    ^|
echo   %line2%
exit /b

:select_port
:: Parâmetros: %1 = Tipo (Sistema ou Painel), %2 = Alvo (run_client ou run_panel)
cls
echo %line2%
echo ^|  SELECIONE A LOJA (%1)      ^|
echo %line2%
call :LISTA_OPCAO
set "op_porta="
set /p "op_porta=Selecione o numero da porta para o %1: "
if not defined op_porta (
    echo Timeout! Retornando ao menu...
    timeout /t 2 >nul
    goto select_port
)
echo.

:: Validação e configuração da porta
if "!op_porta!"=="0" goto menu_versao
if "!op_porta!"=="99" (
    if /i "%1"=="Painel" (
        echo Opcao invalida para Painel! Tente novamente.
        timeout /t 2 >nul
        goto select_port
    )
    goto select_port_panel
)
if "!op_porta!"=="1" set "PORT=10999"& set "HOSTNAME=169.169.69.69"& call :%2 & goto limpar_sair
if "!op_porta!"=="2" set "PORT=10999"& set "HOSTNAME=luizzy.duckdns.org"& call :%2 & goto limpar_sair
if "!op_porta!"=="3" set "PORT=10999"& set "HOSTNAME=192.168.1.139"& call :%2 & goto limpar_sair
if "!op_porta!"=="4" set "PORT=41130"& set "HOSTNAME=177.45.80.10"& call :%2 & goto limpar_sair
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto select_port

:select_port_client
call :select_port "Sistema" run_client
goto limpar_sair

:select_port_panel
call :select_port "Painel" run_panel
goto limpar_sair

:: ---------------- Executa o Cliente isCOBOL ----------------
:run_client
call :set_variaveis
if not exist "%ISCOBOL%\bin\isclient.exe" (
    echo Erro: isclient.exe nao encontrado em %ISCOBOL%\bin
    timeout /t 3 >nul
    goto limpar_sair
)
:: Criar diretório de logs se não existir
if not exist "%ISCOBOL%\%LOG_DIR%" mkdir "%ISCOBOL%\%LOG_DIR%"
echo Iniciando isCOBOL %ISCOBOL% em %HOSTNAME%:%PORT%...
start /min "" "%ISCOBOL%\bin\isclient.exe" -J-Discobol.encoding=%ENCODING% -J-Dfile.encoding=%ENCODING% -hostname %HOSTNAME% -port %PORT% SPS800 > "%ISCOBOL%\%LOG_DIR%\client_%time:~0,2%%time:~3,2%%time:~6,2%.log" 2>&1
exit /b

:: ---------------- Executa o Painel isCOBOL ----------------
:run_panel
call :set_variaveis
if not exist "%ISCOBOL%\bin\isclient.exe" (
    echo Erro: isclient.exe nao encontrado em %ISCOBOL%\bin
    timeout /t 3 >nul
    goto limpar_sair
)
:: Criar diretório de logs se não existir
if not exist "%ISCOBOL%\%LOG_DIR%" mkdir "%ISCOBOL%\%LOG_DIR%"
echo Iniciando Painel isCOBOL %ISCOBOL% em %HOSTNAME%:%PORT%...
start /min "" "%ISCOBOL%\bin\isclient.exe" -J-Discobol.encoding=%ENCODING% -J-Dfile.encoding=%ENCODING% -hostname %HOSTNAME% -port %PORT% -panel > "%ISCOBOL%\%LOG_DIR%\panel_%time:~0,2%%time:~3,2%%time:~6,2%.log" 2>&1
exit /b

:: ---------------- Configura Variáveis de Ambiente ----------------
:set_variaveis
set "PATH=%ISCOBOL%\bin;%oldPATH%"
set "CLASSPATH=.;%ISCOBOL%\bin;%ISCOBOL%\lib\;%ISCOBOL%\jars\;%oldCLASSPATH%"
set "LD_LIBRARY_PATH=%CLASSPATH%"
exit /b

:: ---------------- Restaura Variáveis e Sai ----------------
:limpar_sair
set "PATH=%oldPATH%"
set "CLASSPATH=%oldCLASSPATH%"
set "LD_LIBRARY_PATH=%oldLIBRARYPATH%"
set "oldPATH="
set "oldCLASSPATH="
set "oldLIBRARYPATH="
set "ISCOBOL="
set "PORT="
set "HOSTNAME="
set "op_vesao="
set "op_porta="
set "op_panel="
exit