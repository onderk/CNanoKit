@echo off
echo run %DATE% %TIME% [%~1] [%~2] > "%~dp0log\run_args.txt"
call "%~dp0step.bat" %*
