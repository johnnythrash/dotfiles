#!/bin/bash

set -e  # Exit on error

echo "🔧 Bootstrapping dotfiles..."

DOTFILES_DIR="$HOME/dotfiles"

# Backup and symlink .zshrc
if [ -f "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  echo "📦 Backed up existing .zshrc to .zshrc.bak"
fi
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
echo "🔗 Linked .zshrc"

# Backup and symlink .p10k.zsh
if [ -f "$HOME/.p10k.zsh" ]; then
  mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
  echo "📦 Backed up existing .p10k.zsh to .p10k.zsh.bak"
fi
ln -s "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
echo "🔗 Linked .p10k.zsh"

# Backup and symlink .vimrc
if [ -f "$HOME/.vimrc" ]; then
  mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
  echo "📦 Backed up existing .vimrc to .vimrc.bak"
fi
ln -s "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
echo "🔗 Linked .vimrc"

# Install Oh My Zsh if not installed (unattended, don't auto-run zsh or chsh)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💾 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install custom ZSH plugins and theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "⬇️  Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "⬇️  Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "⬇️  Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# OS-specific packages: command-not-found, autojump, fzf
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "📦 Installing CLI tools via apt (command-not-found, autojump, fzf)..."
  # command-not-found may already be present; ignore failures
  sudo apt update -y || true
  sudo apt install -y command-not-found autojump fzf || true
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if command -v brew >/dev/null 2>&1; then
    echo "📦 Installing CLI tools via Homebrew (autojump, fzf)..."
    brew install autojump fzf || true
  else
    echo "⚠️ Homebrew not found; skipping autojump/fzf install on macOS"
  fi
else
  echo "⚠️ Unsupported OS type '$OSTYPE' for package installs; skipping autojump/fzf/command-not-found"
fi

echo "✅ Bootstrap complete. Reload your shell or run 'source ~/.zshrc'"