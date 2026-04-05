# Dotfiles

Portable dotfiles repository using Ansible for system provisioning. Supports macOS (Intel/ARM) and Linux.

## Quick Start

### Fresh Machine (curl | bash)

```bash
curl -sL https://raw.githubusercontent.com/drew/dotfiles/main/setup.sh | bash
```

> **Note:** The setup script will prompt for confirmation before making changes.

### Existing Clone

```bash
cd ~/.dotfiles
make install
```

Or run specific roles:

```bash
make install TAGS=shell,git
```

See all available commands:

```bash
make help
```

## What Gets Installed

### macOS (via Homebrew)

- **CLI Tools:** fastfetch, starship, jq, fzf, ripgrep, neovim
- **Development:** git, gh, pipx, uv (Python), bitwarden-cli
- **Casks:** google-cloud-sdk

### Linux (via apt + installers)

- **System:** build-essential, curl, git, unzip, zsh, fzf, ripgrep, jq
- **Via Installers:** starship, neovim (AppImage)

### All Platforms

- **Shell:** oh-my-zsh, zsh as default shell
- **Python:** uv (version + package management)
- **Node.js:** fnm + LTS version

## Directory Structure

```
~/.dotfiles/
├── setup.sh                    # Bootstrap script
├── ansible/
│   ├── site.yml                # Main playbook
│   ├── inventory/localhost.yml
│   ├── group_vars/all.yml      # Package lists
│   └── roles/                  # Ansible roles
├── shell/
│   ├── zshrc                   # Main zsh config
│   └── zshrc.local.example     # Local override template
├── git/
│   ├── gitconfig               # Git configuration
│   ├── gitconfig.local.example # Local git template
│   └── gitignore_global        # Global gitignore
├── ssh/
│   └── config                  # SSH configuration
├── starship/
│   └── starship.toml           # Prompt configuration
├── nvim/
│   └── init.lua                # Neovim configuration
├── ghostty/
│   └── config                  # Ghostty terminal config
└── zed/
    └── settings.json           # Zed editor config
```

## Symlinks Created

| Dotfile | Symlink Target |
|---------|----------------|
| `~/.zshrc` | `~/.dotfiles/shell/zshrc` |
| `~/.gitconfig` | `~/.dotfiles/git/gitconfig` |
| `~/.gitignore_global` | `~/.dotfiles/git/gitignore_global` |
| `~/.ssh/config` | `~/.dotfiles/ssh/config` |
| `~/.config/starship.toml` | `~/.dotfiles/starship/starship.toml` |
| `~/.config/nvim` | `~/.dotfiles/nvim` |
| `~/.config/ghostty/config` | `~/.dotfiles/ghostty/config` |
| `~/.config/zed/settings.json` | `~/.dotfiles/zed/settings.json` |

## Machine-Specific Configuration

For settings that vary between machines, use local override files (not tracked in git):

### ~/.gitconfig.local

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### ~/.zshrc.local

```bash
# Work-specific settings
export KUBECONFIG="$HOME/.kube/work-config"
alias myproject="cd ~/work/project && source .venv/bin/activate"
```

## SSH with Bitwarden

This setup uses Bitwarden's SSH agent for key management:

1. Install [Bitwarden Desktop](https://bitwarden.com/download/)
2. Open Bitwarden → Settings → SSH Agent → Enable
3. Add SSH keys to your Bitwarden vault
4. The `zshrc` automatically detects and configures `SSH_AUTH_SOCK`

Verify it works:
```bash
ssh-add -l  # Should show your Bitwarden keys
```

## Ansible Roles

| Role | macOS | Linux | Description |
|------|:-----:|:-----:|-------------|
| homebrew | ✓ | - | Install Homebrew and packages |
| apt | - | ✓ | Install apt packages |
| shell | ✓ | ✓ | oh-my-zsh, set zsh as default |
| python | ✓ | ✓ | Install uv |
| node | ✓ | ✓ | Install fnm + Node.js LTS |
| ssh | ✓ | ✓ | SSH config and Bitwarden setup |
| dotfiles | ✓ | ✓ | Create all symlinks |

## Manual Steps After Setup

1. **Open a new terminal** to load the new shell configuration
2. **Create `~/.gitconfig.local`** with your name and email
3. **Create `~/.zshrc.local`** for machine-specific settings (optional)
4. **Enable SSH agent in Bitwarden** and add your keys

## Updating

Pull the latest changes and re-run:

```bash
cd ~/.dotfiles
make update
```

## Customization

- Add packages to `ansible/group_vars/all.yml`
- Add symlinks to the `dotfile_links` variable
- Create new roles in `ansible/roles/`

## Troubleshooting

### Ansible not found after install

Close and reopen your terminal, or source your shell config:
```bash
source ~/.zshrc
```

### SSH agent not working

Check if Bitwarden socket exists:
```bash
ls -la ~/.bitwarden-ssh-agent.sock
# or (Mac App Store)
ls -la ~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
```

### Symlink conflicts

The playbook backs up existing files before creating symlinks. Check for `.backup` files in your home directory.
