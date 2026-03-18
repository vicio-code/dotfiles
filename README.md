# Dotfiles

Personal configuration files managed with GNU Stow.

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Copy template files and customize
cp bash/.bash_personal.example ~/.bash_personal
cp git/.gitconfig.personal.example ~/.gitconfig.personal
cp git/.gitconfig.work.example ~/.gitconfig.work

# Edit with your information
vim ~/.bash_personal
vim ~/.gitconfig.personal
vim ~/.gitconfig.work

# 3. Stow packages (creates symlinks)
stow bash git ssh starship

# 4. Reload shell
exec bash
```

## ⚙️ Local Configuration

This repository contains **no personal data**. All personal settings use template files:

- `bash/.bash_personal.example` → copy to `~/.bash_personal`
- `git/.gitconfig.personal.example` → copy to `~/.gitconfig.personal`
- `git/.gitconfig.work.example` → copy to `~/.gitconfig.work`

These files are git-ignored and stay on your local machine only.

### What Goes in Each File?

**~/.bash_personal** - Machine-specific bash settings:
- AWS profiles
- SSH shortcuts/aliases
- SSH keys to auto-load
- Personal aliases and functions

**~/.gitconfig.personal** - Personal git identity:
- Your personal name/email
- GitHub SSH URLs (optional)

**~/.gitconfig.work** - Work git identity (used for `~/cvs/*` directories):
- Your work name/email
- Work git server SSH URLs (optional)

## 📁 Structure

```
dotfiles/
├── bash/
│   ├── .bashrc              # Main bash configuration
│   ├── .bash_aliases        # Command aliases
│   ├── .bash_functions      # Custom functions
│   ├── .bash_personal.example  # Template for local settings
│   ├── .profile             # Login shell config
│   ├── .bash_logout         # Logout script
│   └── .blerc               # ble.sh configuration
├── git/
│   ├── .gitconfig           # Base git config
│   ├── .gitconfig.personal.example  # Personal identity template
│   └── .gitconfig.work.example      # Work identity template
├── ssh/
│   └── .ssh/
│       └── config           # SSH client configuration
├── starship/
│   └── .config/
│       └── starship.toml    # Prompt configuration
├── .github/
│   └── workflows/
│       └── validate.yml     # CI/CD validation
├── .gitignore
├── AGENTS.md                # Guidelines for AI coding agents
└── README.md
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
- **Personal projects**: Uses `~/.gitconfig.personal` (personal email)
- **Base settings**: Editor, aliases, colors (tracked in repo)

This ensures you never accidentally commit with the wrong email address.

## 🔄 Updating Configurations

Just edit the files normally - they're symlinked:

```bash
vim ~/.bashrc  # Actually edits ~/dotfiles/bash/.bashrc
cd ~/dotfiles
git add bash/.bashrc
git commit -m "Update bashrc"
git push
```

## 🔄 Pulling Updates from Remote

```bash
cd ~/dotfiles
git pull
stow -R bash git ssh starship  # Restow to update symlinks
```

## 🗑️ Uninstalling

```bash
cd ~/dotfiles
stow -D bash git ssh starship  # Removes all symlinks
```

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

## ✅ Validation

Before committing changes, you can manually check:

```bash
# Check bash syntax
bash -n bash/.bashrc

# Verify no personal data (replace with your info)
grep -r "your-username\|your-company" bash/ git/ ssh/ starship/

# Test stowing (dry-run, no changes made)
stow -n bash git ssh starship
```

All pushes are automatically validated via GitHub Actions.

## 🔒 Security Notes

- SSH private keys are **NEVER** tracked in this repo
- `.gitignore` excludes all sensitive files (`.bash_personal`, `.gitconfig.personal`, `.gitconfig.work`, `id_*`)
- Only configuration files are versioned
- Personal/work details stay on local machine
- CI/CD validates no personal data in tracked files
