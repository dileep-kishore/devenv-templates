default:
    @just --list --unsorted

alias u := update
alias c := clean-env
alias i := install

update:
    uv lock --upgrade

install:
    uv sync && uv pip install -e .

clean-env:
    rm -rf .devenv .direnv .venv flake.lock poetry.lock
