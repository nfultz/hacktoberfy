@echo off
setlocal ENABLEDELAYEDEXPANSION
set BROWSER_PYSCRIPT=import os, webbrowser, sys^

try:^

	from urllib import pathname2url^

except:^

	from urllib.request import pathname2url^

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))

set PRINT_HELP_PYSCRIPT=import re, sys^

for line in sys.stdin:^

	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$', line)^

	if match:^

		target, help = match.groups()^

		print("%-20s %s" % (target, help))

if "%PYTHON%"=="" (
    set PYTHON=python
) else (
    set "PATH=%PYTHON%;%PYTHON%\Scripts;%PATH%"
    set PYTHON=python
)

set PIP=pip
set PIPENV=pipenv
set PIPRUN=%PIPENV% run
set PIPINST=%PIPENV% --bare install --dev --skip-lock
set BROWSER=%PYTHON% -c !BROWSER_PYSCRIPT!

if "%1"=="help" (
    %PYTHON% -c "!PRINT_HELP_PYSCRIPT!" < %~f0
    goto :end
)

if "%1"=="clean" (
    call :cleanbuild
    call :cleanpyc
    call :cleantest
    goto :end
)

if "%1"=="cleanbuild" (
    call :cleanbuild
    goto :end
)

if "%1"=="cleanpyc" (
    call :cleanpyc
    goto :end
)

if "%1"=="cleantest" (
    call :cleantest
    goto :end
)

if "%1"=="lint" (
    @echo on
    %PIPRUN% pylint hacktoberfy tests --disable=parse-error
    @echo off
    goto :end
)
 
if "%1"=="test" (
    @echo on
    %PIPRUN% python -m pytest
    @echo off
    goto :end
)

if "%1"=="test-all" (
    @echo on
    %PIPRUN% tox
    @echo off
    goto :end
)

if "%1"=="test-install" (
    @echo on
    %PYTHON% -m %PIP% install --upgrade pip pipenv
    %PIPINST%
    @echo off
    goto :end
)

if "%1"=="coverage" (
    @echo on
    %PIPRUN% python -m pytest --cov=hacktoberfy
    @echo off
    goto :end
)

if "%1"=="coverage-html" (
    @echo on
    %PIPRUN% python -m pytest --cov=hacktoberfy
    %PIPRUN% coverage html
    %BROWSER% htmlcov\index.html
    @echo off
    goto :end
)

if "%1"=="release" (
    @echo on
    %PIPRUN% flit build
    dir dist
    %PIPRUN% flit publish
    @echo off
    goto :end
)

if "%1"=="dist" (
    @echo on
    %PIPRUN% flit build
    dir dist
    @echo off
    goto :end
)

if "%1"=="install" (
    @echo on
    %PIPRUN% flit install --deps=none
    @echo off
    goto :end
)

if "%1"=="run" (
    @echo on
    %PIPRUN% python -m hacktoberfy %cmd%
    @echo off
    goto :end
)

if "%1"=="debug" (
    @echo on
    %PIPRUN% flit install --deps=none
    %PIPRUN% pudb3 hacktoberfy %cmd%
    @echo off
    goto :end
)

:cleanbuild
@echo on
rmdir /S /Q build
rmdir /S /Q dist
rmdir /S /Q .eggs
del /S *.egg-info
del /S *.egg
@echo off
exit /B 0

:cleanpyc
@echo on
del /S *.pyc
del /S *.pyo
del /S *~
del /S __pycache__
%PIPRUN% pip uninstall -y hacktoberfy
@echo off
exit /B 0

:cleantest
@echo on
del .coverage
rmdir /S /Q htmlcov
rmdir /S /Q .pytest_cache
rmdir /S /Q .tox
@echo off
exit /B 0

:end
