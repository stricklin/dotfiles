# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Installation (New Machine)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply stricklin
```

You'll be prompted for:
- Git user name
- Git email

## What Gets Installed

**Config files:** aliases, bashrc, functions, gitconfig, tmux.conf, p10k.zsh, Claude Code config

**Tools (Debian/Ubuntu):**
- zsh + oh-my-zsh + powerlevel10k
- pyenv (Python 3.11.9, 3.12.4)
- AWS CLI v2
- Go 1.22.5 + golangci-lint
- gh CLI, npm, pre-commit, xclip
- vim + [vimfiles](https://github.com/stricklin/vimfiles)

## Development

```bash
# Preview changes
chezmoi diff

# Apply changes
chezmoi apply

# Check for issues
chezmoi doctor

# Verify all files match
chezmoi verify
```

## Testing

```bash
# Build and run tests in Docker
docker build -f Dockerfile.test -t dotfiles-test .
docker run --rm dotfiles-test chezmoi apply --verbose
docker run --rm dotfiles-test chezmoi verify
```

## Credits

Originally based on [toozej/dotfiles](https://github.com/toozej/dotfiles).
