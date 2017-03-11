@ECHO OFF

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION


SET INTF_NAME="EthB"
IF NOT "%~1"=="" (
	IF "%~1"=="only" (
		SET DHCP_ONLY=DHCP_ONLY
	) ELSE (
		IF "%~1"=="no" (
			SET NODHCP=NODHCP
		) ELSE (
			SET  INTF_NAME="%~1"
		)
	)
)

IF NOT "%NODHCP%"=="NODHCP" (
	:: Enable DHCP
	netsh int ipv4 set addr name=%INTF_NAME% source=dhcp 1>NUL 2>&1
	@REM ::netsh  int ipv4 set dnsservers name=%INTF_NAME% source=dhcp
)
IF "%DHCP_ONLY%"=="DHCP_ONLY" GOTO :EOF

SET DEFIP=172.16.116.53
SET DEFMASK=255.255.255.0

:: Get ip & mask
SET DIP=%DEFIP%
SET DMASK=%DEFMASK%
SET DGATE=
SET /A CNT=10
@ECHO Get DHCPed IP/mask/gateway:
:GetDHCPIP
FOR /F "usebackq tokens=1,2,3,4,5,6,7*" %%A in (`netsh int ipv4 show config name^=%INTF_NAME%`) DO (
	REM @ECHO A=%%A B=%%B C=%%C D=%%D E=%%E F=%%F
	IF "%%A"=="IP" SET DIP=%%C
	IF "%%A"=="Subnet" SET DMASK=%%E
	IF "%%A"=="Default" (IF "%%B"=="Gateway:" SET DGATE=%%C)
)
IF NOT "%NODHCP%"=="NODHCP" (
	SET /A CNT=%CNT%-1
	IF "%DGATE%"=="" (
		IF %CNT% GTR 0 (
			@ECHO      %CNT%
			timeout 1 1>NUL 2>&1
			GOTO :GetDHCPIP
		)
	)
)
IF NOT "%DMASK%"=="" SET DMASK=%DMASK:)=%
@ECHO IP=%DIP% MASK=%DMASK% GW=%DGATE%

:: Switch to static IPs with previous DHCPed IP
IF NOT "%DGATE%"=="" (
	netsh int ipv4 set address name=%INTF_NAME% source=static address=%DIP% mask=%DMASK% gateway=%DGATE%
) ELSE (
	netsh int ipv4 set address name=%INTF_NAME% source=static address=%DEFIP% mask=%DEFMASK%
)
:: add many ip address as you like here
::netsh int ipv4 add address %INTF_NAME% 192.168.1.53 255.255.255.0
::netsh int ipv4 add address %INTF_NAME% 192.168.53.53 255.255.255.0
netsh int ipv4 add address %INTF_NAME% 192.168.99.53 255.255.255.0
netsh int ipv4 add address %INTF_NAME% 192.168.192.53 255.255.192.0
netsh int ipv4 add address %INTF_NAME% 192.168.241.53 255.255.255.0
netsh int ipv4 add address %INTF_NAME% 192.168.245.53 255.255.255.0

timeout 5
:: dump config
netsh int ipv4 show addresses %INTF_NAME%
