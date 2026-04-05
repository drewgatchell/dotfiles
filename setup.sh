#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
TAGS="${TAGS:-}"

echo "==> Dotfiles Setup"
echo "    Repository: ${DOTFILES_DIR}"
echo ""

# Detect OS
if [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
    echo "==> Detected macOS"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
    echo "==> Detected Debian/Ubuntu Linux"
else
    OS="linux"
    echo "==> Detected Linux"
fi

# Clone dotfiles if not present (for curl|bash usage)
if [[ ! -d "${DOTFILES_DIR}" ]]; then
    echo "==> Cloning dotfiles repository..."
    git clone https://github.com/drew/dotfiles.git "${DOTFILES_DIR}"
    cd "${DOTFILES_DIR}"
else
    cd "${DOTFILES_DIR}"
fi

# Install Ansible
install_ansible() {
    if command -v ansible-playbook &> /dev/null; then
        echo "==> Ansible already installed"
        return
    fi

    echo "==> Installing Ansible..."
    if [[ "${OS}" == "macos" ]]; then
        # Ensure Homebrew is installed first
        if ! command -v brew &> /dev/null; then
            echo "==> Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        brew install ansible
    else
        sudo apt-get update
        sudo apt-get install -y ansible
    fi
}

install_ansible

# Run Ansible playbook
echo ""
echo "==> Ready to run Ansible playbook"
echo "    This will install packages and configure your system."
if [[ -n "${TAGS:-}" ]]; then
    echo "    Tags: ${TAGS}"
fi
echo ""
read -rp "Proceed? [y/N] " confirm
if [[ "${confirm}" != [yY] ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "==> Running Ansible playbook..."
cd "${DOTFILES_DIR}/ansible"

if [[ -n "${TAGS:-}" ]]; then
    ansible-playbook site.yml --tags "${TAGS}"
else
    ansible-playbook site.yml
fi

echo ""
echo "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal to load the new shell configuration"
echo "  2. Create ~/.gitconfig.local with your email and credentials"
echo "  3. Create ~/.zshrc.local for machine-specific settings"
echo "  4. Enable SSH agent in Bitwarden desktop app"
