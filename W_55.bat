echo. %RESULT FILER echo. 
echo. W-55 Start
echo [ W-55 최근 임호 기억 start ] >> %RESULT_FILE%

secedit lexport /cfg secpolicy_tmp.txt > nul

echo 1. 최근 암호 기억 설정 확인 >> %RESULT_FILE%

type secpolicy_tmp.txt | findstr /bic: "PasswordHistorySize" > history.txt
if not "%errorlevel%" == "0" (
  echo Not Found Passwordhistorysize>> %RESULT_FILE% 
  call :FAILVALUE W-55 
  goto QUIT55
)

type history.txt >> %RESULT_FILE% 
for /f "tokes=1,2 delims==" %%a in (history.txt) do set CONF=%%b

if %CONF% GEO 4 (
  call :PASSWALUE W-55
) else (
  call : FAILVALUE W-55
)

:QUIT55
echo. >> %RESULT_FILE%
echo [ W-55 최근 임호 기억 end ] >> %RESULT_FILE%
echo. W-55 End
del /a secpolicy_tmp.txt 
del /q history.txt
