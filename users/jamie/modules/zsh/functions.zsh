# Periodically attempt to ssh to a host until it succeeds
sssh() {
    while ! \ssh "$@"; do sleep 1; done
}

# Quick maffs
m() {
    python3 -c "from math import *; print($*)"
}

# Create and activate a python virtual environment
venv() {
    python3 -m venv .venv && . .venv/bin/activate && python3 -m pip install --upgrade pip &> /dev/null
}