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

# Optional: Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💾 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install custom ZSH plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "⬇️  Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "⬇️  Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "✅ Bootstrap complete. Reload your shell or run 'source ~/.zshrc'"