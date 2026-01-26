# Dotfiles

Personal configuration files managed with GNU Stow.

## 🚀 Quick Start

```bash
# Run install script (coming soon)
./install.sh
```

## ⚙️ Local Configuration (Not Tracked)

After installation, create these local files for work/personal separation:

### Git Work Identity

```bash
cat > ~/.gitconfig.work << 'EOF'
[user]
    name = Your Name
    email = your.work@company.com

[url "git@gitlab.company.com:"]
    insteadOf = https://gitlab.company.com/
EOF
```

### Git Personal Identity

```bash
cat > ~/.gitconfig.local << 'EOF'
[user]
    name = Your Name
    email = your.personal@email.com

[url "git@github.com:"]
    insteadOf = https://github.com/
EOF
```

## 📁 Structure

```
dotfiles/
├── bash/
│   ├── .bashrc
│   ├── .profile
│   └── .bash_logout
├── git/
│   └── .gitconfig
├── ssh/
│   └── .ssh/
│       └── config
├── starship/
│   └── .config/
│       └── starship.toml
├── .gitignore
├── README.md
└── install.sh
```

## 🔗 How It Works

GNU Stow creates symlinks from `~/dotfiles/` to `~/`:

```
~/.bashrc -> ~/dotfiles/bash/.bashrc
~/.gitconfig -> ~/dotfiles/git/.gitconfig
~/.ssh/config -> ~/dotfiles/ssh/.ssh/config
```

Editing `~/.bashrc` directly edits the file in your dotfiles repo, making it easy to track and commit changes.

## 🎨 Git Configuration Strategy

The base git config includes conditional configurations:

- **Work projects** (`~/cvs/*`): Uses `~/.gitconfig.work` (work email)
- **Personal projects**: Uses `~/.gitconfig.local` (personal email)
- **Base settings**: Editor, aliases, colors (tracked in repo)

This ensures you never accidentally commit with the wrong email address.

## 🛠️ Adding New Configurations

```bash
# 1. Create package directory
mkdir -p ~/dotfiles/newapp

# 2. Move config file (preserving path structure)
mv ~/.newapprc ~/dotfiles/newapp/.newapprc

# 3. Stow it
cd ~/dotfiles
stow newapp

# 4. Commit
git add newapp/
git commit -m "Add newapp configuration"
git push
```

## 🔄 Updating Configurations

Just edit the files normally - they're symlinked:

```bash
vim ~/.bashrc  # Actually edits ~/dotfiles/bash/.bashrc
cd ~/dotfiles
git add bash/.bashrc
git commit -m "Update bashrc"
git push
```

## 🗑️ Removing Configurations

```bash
cd ~/dotfiles
stow -D bash  # Removes all bash symlinks
```

## 🔒 Security Notes

- SSH private keys are **NEVER** tracked in this repo
- `.gitignore` excludes all sensitive files (`*.work`, `*.local`, `id_*`)
- Only configuration files are versioned
- Work-specific details stay on local machine

## ✅ TODO

- [ ] Configure Starship
- [ ] Verify bash configuration
- [ ] Verify ssh configuration
- [ ] Verify git configuration
- [ ] Create install.sh
- [ ] Add tmux configuration
- [ ] Add error handling and logging
