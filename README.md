# Don't commit SSH private keys

ssh/.ssh/id\__
ssh/.ssh/_.pem
ssh/.ssh/known_hosts

# Don't commit sensitive files

**/secrets
**/\*.secret
EOF

# 2.7: Create README

cat > README.md << 'EOF'

# My Dotfiles

## Installation

```bash
cd ~/dotfiles
stow bash git sshcp
```
