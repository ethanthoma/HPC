#!/usr/bin/env bash

# pro
cd $HOME
touch $HOME/.bashrc
mkdir -p $HOME/.config/
mkdir -p $HOME/.local/bin/

if ! grep -q "TERM=xterm" $HOME/.bashrc; then
    echo 'export TERM=xterm' >> $HOME/.bashrc
fi

# neovim
if ! command -v nvim &> /dev/null; then
    wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    mv nvim-linux-x86_64.appimage $HOME/.local/bin/nvim
fi
if ! grep -q "EDITOR=nvim" $HOME/.bashrc; then
    echo 'export EDITOR=nvim' >> $HOME/.bashrc
fi
if ! grep -q "=\"nvim\"" $HOME/.bashrc; then
    echo 'alias vim="nvim"' >> $HOME/.bashrc
    echo 'alias vi="nvim"' >> $HOME/.bashrc
fi

# git
if ! git config --global --get alias.s &> /dev/null; then
    git config --global alias.s status
fi

# install uv and tools
if ! command -v uv &> /dev/null; then 
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo 'export UV_CACHE_DIR="$SCRATCH/uv_cache"' >> $HOME/.bashrc
    echo 'export UV_TOOL_DIR="$SCRATCH/uv_tools"' >> $HOME/.bashrc
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
if ! grep -q "FZF_DEFAULT_OPTS" $HOME/.bashrc; then
    cat >> $HOME/.bashrc <<'EOF'
export FZF_DEFAULT_OPTS="
    --height 50% --layout=reverse --border
    --color=fg:#908caa,bg:#191724,hl:#ebbcba
    --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
    --color=border:#403d52,header:#31748f,gutter:#191724
    --color=spinner:#f6c177,info:#9ccfd8
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
EOF
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
    wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.8/zoxide-0.9.8-x86_64-unknown-linux-musl.tar.gz \
        -O zoxide.tar.gz
    mkdir -p zoxide
    tar -xzf zoxide.tar.gz -C zoxide
    mv zoxide/zoxide $HOME/.local/bin/
    rm -rf zoxide.tar.gz zoxide
fi

if ! grep -q "zoxide init bash" $HOME/.bashrc; then
    echo 'eval "$(zoxide init bash --cmd cd)"' >> $HOME/.bashrc
fi

# dust
if ! command -v dust &> /dev/null; then
    wget https://github.com/bootandy/dust/releases/download/v1.2.3/dust-v1.2.3-x86_64-unknown-linux-gnu.tar.gz
    tar -xf dust-v1.2.3-x86_64-unknown-linux-gnu.tar.gz
    mv dust-v1.2.3-x86_64-unknown-linux-gnu/dust $HOME/.local/bin/dust
    rm -rf dust-v1.2.3-x86_64-unknown-linux-gnu dust-v1.2.3-x86_64-unknown-linux-gnu.tar.gz
fi

# epi
cd -
source $HOME/.bashrc
