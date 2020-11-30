@echo off



::配置需要扫描清理文件夹的路径

set delpath=F:\deltest


echo.
color 02
echo.
echo  ---------------------------------------------------------------------------------------
echo  开始执行删除  %delpath% 下包含子路径中所有名为logs的文件夹中包含的所有文件
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
echo                             即将被清除的路径列表，请确认   
echo.
echo  ########################################################################################
echo.
echo.
pause
for  /f  "delims=" %%j in ('dir   /ad/b/s %delpath%\*logs ^|findstr /i \\logs' ) do (rd /s/q %%j && md %%j)
echo.
echo.
echo "已经删除  %delpath%  下名为logs文件夹内的所有内容"
echo.
echo.
pause