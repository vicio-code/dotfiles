# Agent Guidelines for Dotfiles Repository

This document provides guidelines for agentic coding assistants working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository managed with **GNU Stow**. It contains shell configurations, git settings, SSH configs, and prompt customization using Starship. The repository uses a symlink-based approach where files are stowed from package directories to the home directory.

## Build/Test Commands

### Testing Installation
```bash
# Test stowing packages (dry-run, no changes made)
cd ~/dotfiles
stow -n bash        # Simulate bash package
stow -n git         # Simulate git package
stow -n ssh         # Simulate ssh package
stow -n starship    # Simulate starship package

# Actually stow packages
stow bash git ssh starship

# Remove/unstow packages (for testing)
stow -D bash        # Remove bash symlinks
stow -D git ssh starship  # Remove all
```

### Validation Commands
```bash
# Check bash syntax (most important - run before committing)
bash -n bash/.bashrc
bash -n bash/.bash_aliases
bash -n bash/.bash_functions
bash -n bash/.profile
bash -n bash/.bash_logout
bash -n bash/.blerc

# Check for personal data (replace with actual names to search)
grep -r "username\|company" bash/ git/ ssh/ starship/

# Verify symlinks are created correctly
ls -la ~ | grep -E '\.bashrc|\.gitconfig|\.ssh/config'

# Check for broken symlinks
find ~ -maxdepth 1 -xtype l

# Test bash configuration loads without errors
bash -c 'source ~/.bashrc && echo "OK"'

# Validate git config syntax
git config --list --show-origin

# Check SSH config syntax
ssh -G github.com
```

### CI/CD Validation
All commits are automatically validated via GitHub Actions:
- Bash syntax checks
- Personal data detection
- Example file existence

**Note:** No local validation script needed - GitHub Actions handles it.

## File Structure

```
dotfiles/
├── bash/              # Bash configuration package
│   ├── .bashrc       # Main bash configuration
│   ├── .bash_aliases # Command aliases
│   ├── .bash_functions # Custom shell functions
│   ├── .bash_personal.example # Template for local settings
│   ├── .profile      # Login shell configuration
│   ├── .bash_logout  # Logout script
│   └── .blerc        # ble.sh configuration
├── git/              # Git configuration package
│   ├── .gitconfig    # Base git config (uses conditional includes)
│   ├── .gitconfig.personal.example # Personal identity template
│   ├── .gitconfig.work.example     # Work identity template
│   └── .gitignore_global # Global ignore patterns
├── ssh/              # SSH configuration package
│   └── .ssh/config   # SSH client configuration
├── starship/         # Starship prompt package
│   └── .config/starship.toml  # Prompt configuration
├── .github/workflows/ # CI/CD automation
│   └── validate.yml  # Automated validation
├── .gitignore        # Excludes sensitive files
├── AGENTS.md         # This file
└── README.md         # User documentation
```

## Code Style Guidelines

### Shell Scripts (Bash)

**General Principles:**
- Use `#!/usr/bin/env bash` shebang for portability
- Enable strict mode: `set -euo pipefail` for safety-critical scripts
- Use 4 spaces for indentation (consistent with existing files)
- Add section headers with `# ============= Section Name =============`

**Naming Conventions:**
- Functions: lowercase with underscores (e.g., `log_info`, `backup_if_exists`)
- Variables: UPPERCASE for constants/env vars (e.g., `DOTFILES_DIR`, `RED`)
- Variables: lowercase for local/function variables (e.g., `file`, `package`)

**Conditionals & Tests:**
- Use `[[ ]]` for test conditions (bash-specific, more features)
- Use `[ ]` only when POSIX compatibility is required
- Check command existence: `command -v tool &> /dev/null`
- Check file existence: `[ -f "$file" ]` or `[[ -f "$file" ]]`

**Functions:**
```bash
# Good: Descriptive name, local variables, error handling
backup_if_exists() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup="${file}.backup-$(date +%Y%m%d-%H%M%S)"
        log_warn "Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}
```

**Aliases:**
- Keep alphabetically organized within sections
- Include helpful comments for non-obvious aliases
- Preserve original commands when overriding (e.g., `alias ccat='/usr/bin/cat'`)

**Error Handling:**
- Use helper functions for logging: `log_info`, `log_warn`, `log_error`
- Exit with non-zero status on errors in scripts
- Use `|| true` to ignore errors when intentional
- Quote all variable expansions: `"$var"` not `$var`

### Git Configuration

**Format:**
- Use tabs for indentation (git's default)
- Group related settings in sections
- Add comments for non-obvious configurations

**Structure:**
```gitconfig
[section]
	key = value
	
[alias]
	shortname = full-command
	
# Include pattern
[include]
    path = ~/.gitconfig.personal
```

**Aliases:**
- Short, memorable names (2-4 characters)
- Use full commands with options for clarity
- Examples: `st` (status), `lg` (log graph), `cm` (commit message)

### TOML Configuration (Starship)

**Format:**
- Use 4 spaces for indentation
- Organize sections with `# ============= Section =============` headers
- Group related prompt modules together
- Use descriptive comments for complex configurations

**Settings:**
```toml
[module_name]
format = "pattern"
style = "color"
option = value
```

### Commit Messages

Follow the existing commit style observed in `git log`:

**Format:**
- Capitalize first word
- Descriptive imperative mood ("Add", "Update", "Enhance", "Fix")
- Be specific about what changed and why
- Examples from repo:
  - "Enhance .bashrc with batcat integration for improved man page viewing and fallback options"
  - "Update .gitconfig to switch editor to vim and enhance delta configuration for improved diff viewing"
  - "Add bash aliases, functions, and fzf integration for improved shell experience"

**Structure:**
```
<Action> <component> [with <details>] [for <benefit>]

Examples:
- Add SSH configuration for GitHub
- Update Starship Config
- Enhance .bash_aliases and .blerc with modern CLI tool integrations for improved usability
```

## Important Patterns & Conventions

### Security & Personal Data
- **NEVER** commit SSH private keys (id_*, *.pem)
- **Personal configs are git-ignored but still in the repo**:
  - `.bash_personal`, `.gitconfig.personal`, `.gitconfig.work` exist in repo directories
  - They are **symlinked via stow** (single source of truth)
  - They are **git-ignored** (never committed/pushed)
  - This keeps personal data local while maintaining the symlink workflow
- SSH config should reference key paths, not include actual keys
- `.example` template files show the structure for new users

### How Git-Ignored Files Work with Stow
**Key Understanding:** Files can exist in the repo directory AND be git-ignored simultaneously.

Example:
```bash
# File location:
dotfiles/bash/.bash_personal          # Exists in repo (git-ignored)

# Stow creates symlink:
~/.bash_personal → dotfiles/bash/.bash_personal

# Git ignores it:
.gitignore contains: **/.bash_personal

# Result:
✅ Single source of truth (file in repo)
✅ Symlinked like all other configs
✅ Never committed to git
✅ Repo stays public-safe
```

This pattern applies to:
- `bash/.bash_personal` - Machine-specific bash settings
- `git/.gitconfig.personal` - Personal git identity
- `git/.gitconfig.work` - Work git identity

### GNU Stow Structure
- Each package directory (bash/, git/, ssh/, starship/) mirrors home directory structure
- Files in `bash/` are stowed to `~/`
- Files in `starship/.config/` are stowed to `~/.config/`
- When adding configs: create proper directory structure within package

### Conditional Configuration
- Git uses `includeIf` for work/personal separation
- Personal configs (`.gitconfig.personal`, `.gitconfig.work`) are git-ignored but exist in repo
- They are symlinked via stow, providing single source of truth
- Base configs should work without personal configs present (graceful degradation)

### Modern CLI Tools
The environment uses modern alternatives when available:
- `bat/batcat` replaces `cat`
- `eza` replaces `ls`
- `ripgrep` (rg) - use directly, not aliased over grep
- `fd/fdfind` - use directly, not aliased over find
- `delta` for git diffs
- `starship` for prompt

Preserve fallback aliases to original tools (e.g., `alias ccat='/usr/bin/cat'`, `alias lls='/usr/bin/ls'`)

## Adding New Configurations

When adding a new tool/package:

1. Create package directory: `mkdir -p ~/dotfiles/newtool`
2. Mirror home directory structure inside it
3. Move config preserving path: `mv ~/.configfile ~/dotfiles/newtool/.configfile`
4. Test with `stow -v newtool`
5. Update README.md with new package info
6. Commit with descriptive message

## Error Handling

Scripts should:
- Check dependencies before use (`command -v stow &> /dev/null`)
- Back up existing files before overwriting
- Provide clear error messages with color coding (RED, YELLOW, GREEN)
- Exit with appropriate status codes (0 success, 1 error)
- Use verbose flags for debugging (`stow -v`)

## Testing Changes

Before committing:
1. Check bash syntax: `bash -n bash/.bashrc`
2. Verify no personal data: `grep -r "username\|company" bash/ git/ ssh/ starship/`
3. Test stowing: `stow -n bash git ssh starship`
4. Ensure GitHub Actions will pass (validates automatically on push)
