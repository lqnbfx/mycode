@echo off



::������Ҫɨ�������ļ��е�·��

set delpath=F:\deltest


echo.
color 02
echo.
echo  ---------------------------------------------------------------------------------------
echo  ��ʼִ��ɾ��  %delpath% �°�����·����������Ϊlogs���ļ����а����������ļ�
echo  ---------------------------------------------------------------------------------------
echo.  
echo.  
echo.
echo.
echo.
echo.
cd /d %delpath%
for  /f  "delims=" %%i in ('dir   /ad/b/s %delpath%\*logs ^|findstr /i \\logs' ) do  (echo %%i)
echo.
echo.
echo.
echo.
echo  #######################################################################################
echo.
echo                             �����������·���б���ȷ��   
echo.
echo  ########################################################################################
echo.
echo.
pause
for  /f  "delims=" %%j in ('dir   /ad/b/s %delpath%\*logs ^|findstr /i \\logs' ) do (rd /s/q %%j && md %%j)
echo.
echo.
echo "�Ѿ�ɾ��  %delpath%  ����Ϊlogs�ļ����ڵ���������"
echo.
echo.
pause