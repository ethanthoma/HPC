#!/usr/bin/env bash

# pro
cd $HOME
touch $HOME/.bashrc
mkdir -p $HOME/.config/
mkdir -p $HOME/.local/bin/

# install uv and tools
if ! command -v uv &> /dev/null; then 
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
if ! uv tool list | grep -q "ruff"; then
    uv tool install ruff@latest
fi
if ! uv tool list | grep -q "ty"; then
    uv tool install ty@latest
fi

# direnv
if ! command -v direnv &> /dev/null; then
    curl -sfL https://direnv.net/install.sh | bash
fi
if ! grep -q "direnv hook bash" $HOME/.bashrc; then
    echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
fi

mkdir -p $HOME/.config/direnv
if [[ ! -f $HOME/.config/direnv/direnvrc ]]; then
    cat > $HOME/.config/direnv/direnvrc <<'EOF'
function use_uv() {
    if [[ -d ".venv" ]]; then
        uv sync
        source .venv/bin/activate
    fi
}
EOF
fi

# fzf
if ! command -v fzf &> /dev/null; then
    wget https://github.com/junegunn/fzf/releases/download/v0.65.1/fzf-0.65.1-linux_amd64.tar.gz \
        -O fzf.tar.gz
    tar -xzf fzf.tar.gz
    mv fzf $HOME/.local/bin/
    rm fzf.tar.gz
fi
if ! grep -q "fzf --bash" $HOME/.bashrc; then
    echo 'eval "$(fzf --bash)"' >> $HOME/.bashrc
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
    wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.8/zoxide-0.9.8-x86_64-unknown-linux-musl.tar.gz \
        -O zoxide.tar.gz
    tar -xzf zoxide.tar.gz
    mv zoxide $HOME/.local/bin/
    rm zoxide.tar.gz
fi

if ! grep -q "zoxide init bash" $HOME/.bashrc; then
    echo 'eval "$(zoxide init bash --cmd cd)"' >> $HOME/.bashrc
fi

# epi
cd -
source $HOME/.bashrc
