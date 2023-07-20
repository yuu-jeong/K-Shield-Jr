@echo off

setlocal
chcp 437>nul
set DATETEXT=%date:%
set hh=%time:~0,2%
set hh1=%hh:~0,1%
set hh2=%hh:~1,1%
if "%hh1%" == "" set hh=0%hh2%
set TIMETEXT=%hh%%time:~3,2%%time:~6,2%

set RESULT_FILE=result_collect_%DATETEXT%%TIMETEXT%.txt

echo [Strat Script]
echo ================== Windows Security Check Script Start ================== > %RESULT_FILE%
echo. >> %RESULT_FILE%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::		주요 정보 통신 기반 시설 | 계정 관리
::		W - 04 계정 잠금 임계값 설정
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo. W-04 START 
echo [ W-04 계정 잠금 임계값 설정 START ] >> %RESULT_FILE%

net session > nul 2>&1
if "%errorlevel%" == "0" (
	goto NEXT
) else (
	echo 관리자 권한으로 실행되지 않았습니다. >> %RESULT_FILE%
)

secedit /export /cfg secpolicy_tmp.txt > nul
echo 1. 계정 잠금 임계값 설정 확인 >> %RESULT_FILE%
type secpolicy_tmp.txt | findstr /bic:"LockoutBadCount" > lockout.txt

if "%errorlevel%" == "0" (
	echo Not Found LockoutBadCount >> %RESULT_FILE%
	call :FAILVALUE W-04
	goto QUIT
)

type lockout.txt >> %RESULT_FILE%
for /f "tokens=1,2 delims==" %%a in (lockout.txt) do set CONF=%%b
if not %CONF% leq 5 (
	call :FAILVALUE W-04
	goto QUIT
	)
if %CONF% neq 0 (
	call :PASSVALUE W-04
) else (
	call :FAILVALUE W-04
)

:QUIT

echo. >> %RESULT_FILE%
echo [ W-04 계정 잠금 임계값 설정 END ] >> %RESULT_FILE%
echo. W-04 END

if exist secpolicy_tmp.txt (
	del /q secpolicy_tmp.txt
) 

if exist lockout.txt (
	del /q lockout.txt
) 

exit /b 0
:PASSVALUE
echo [ %1 ] : 양호 >> %RESULT_FILE%
exit /b

:FAILVALUE
echo [ %1 ] : 취약 >> %RESULT_FILE%
exit /b
