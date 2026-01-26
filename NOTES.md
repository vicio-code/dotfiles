# Install.sh exemple

```bash
cat > install.sh << 'EOF'
#!/bin/bash
set -e # Exit on error

echo "🚀 Installing dotfiles..."

# Install Starship

if ! command -v starship &> /dev/null; then
echo "📦 Installing Starship..."
curl -sS https://starship.rs/install.sh | sh
fi

# Install Stow (if needed)

if ! command -v stow &> /dev/null; then
echo "📦 Installing GNU Stow..."
sudo apt update && sudo apt install -y stow
fi

# Backup existing files

echo "💾 Backing up existing configs..."
mkdir -p ~/.backup
for file in .bashrc .profile .bash_logout; do
[ -f ~/$file ] && cp ~/$file ~/.backup/
done

# Stow all packages

echo "🔗 Creating symlinks..."
cd ~/dotfiles
stow bash git ssh starship

echo "✅ Done! Reload your shell: source ~/.bashrc"
EOF
```

chmod +x install.sh
