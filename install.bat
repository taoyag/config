@echo off

set dest_dir=%HOME%
set config_dir=%HOME%\config

echo %dest_dir%
echo %config_dir%

fsutil hardlink create "%dest_dir%\.vimrc" "%config_dir%\.vimrc"
fsutil hardlink create "%dest_dir%\.gvimrc" "%config_dir%\.gvimrc"

mklink /d %dest_dir%\vimfiles %config_dir%\.vim

