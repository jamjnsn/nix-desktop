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
    python3 -m venv .venv && . .venv/bin/activate && python3 -m pip install --upgrade pip &>/dev/null
}

# Take
function take() {
    if [[ $1 =~ ^(https?|ftp).*\.(tar(\.(gz|bz2?|xz|lz|lzma|Z))?|zip|rar|7z|tgz|tbz2?|txz|tlz)$ ]]; then
        takearchive "$@"
    elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
        takegit "$@"
    elif [[ $1 =~ ^(https?|ftp).*$ ]]; then
        takeurl "$@"
    else
        takedir "$@"
    fi
}

# Clone a repository and enter the directory
# Optionally accepts output path, otherwise named after the repo
function takegit() {
    local output=$2
    [[ -z "$output" ]] && output="$(basename ${1%%.git})"

    git clone "$1" "$output"
    cd "$output"
}

# Download, extract, and navigate to an archive
# Extracts to a folder named after the archive
function takearchive() {
    local filename=$(basename "$1")
    local dirname="${filename%.*}"

    local outputdir=$2
    [[ -z "$outputdir" ]] && outputdir="."

    local tmpdir="$(mktemp -d)"
    wget -O "$tmpdir/$filename" "$1"
    7z x "$tmpdir/$filename" -o"$outputdir/$dirname"
    cd "$outputdir/$dirname"
}

# Probably just wget
function takeurl() {
    echo "takeurl not implemented yet."
}

# Create and navigate to a directory
function mkcd takedir() {
    mkdir -p $@ && cd ${@:$#}
}

# Gomi with output
gomi_verbose() {
    for file in "$@"; do
        if [[ -e "$file" ]]; then
            echo "🗑️  $file"
            gomi "$file"
        else
            echo "❌  $file"
        fi
    done
}
