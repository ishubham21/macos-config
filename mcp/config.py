"""Configuration settings for the MCP server"""

import os
from pathlib import Path

DOTFILES_DIR = Path(os.getenv("DOTFILES_DIR", Path.home() / ".dotfiles"))
MAKEFILE_PATH = DOTFILES_DIR / "Makefile"
INSTALL_SCRIPT = DOTFILES_DIR / "install.sh"
COMMAND_TIMEOUT = 300
