#!/bin/bash

_python_virtualenv_dir="$HOME/.local/python-virtualenv"

_python_set_virtualenv() {
    export VIRTUAL_ENV="$_python_virtualenv_dir/$1"
    export PATH="$VIRTUAL_ENV/bin:$PATH"
    unset PYTHON_HOME
}

_python_mkvirtualenv() {
    mkdir -p "$_python_virtualenv_dir/$1"
    virtualenv-3 
}

_python_setup_virtualenv() {
    pip install pylint
}

python_workon() {
    if [ "$#" -gt 1 ]; then
        env="$1"
    elif [ -f .virtualenv_name ]; then
        env="$(< .virtualenv_name)"
    fi

    local creating=no
    if ! [ -d "$_python_virtualenv_dir/$env" ]; then
        creating=yes
        echo >&2 "virtualenv $env does not exist. Creating."
        _python_mkvirtualenv "$env"
    fi
    _python_set_virtualenv "$env"

    if [ "$creating" = yes ]; then
        _python_setup_virtualenv "$env"
    fi
}
