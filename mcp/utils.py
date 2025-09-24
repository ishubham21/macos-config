"""Utility functions for the MCP server"""

import subprocess
from typing import Dict, Any, Optional
from pathlib import Path
from .config import DOTFILES_DIR, COMMAND_TIMEOUT


async def run_command(cmd: list[str], cwd: Optional[Path] = None) -> Dict[str, Any]:
    """Run a command and return result"""
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd or DOTFILES_DIR,
            capture_output=True,
            text=True,
            timeout=COMMAND_TIMEOUT
        )
        return {
            "success": result.returncode == 0,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode
        }
    except subprocess.TimeoutExpired:
        return {
            "success": False,
            "stdout": "",
            "stderr": "Command timed out",
            "returncode": -1
        }
    except Exception as e:
        return {
            "success": False,
            "stdout": "",
            "stderr": str(e),
            "returncode": -1
        }
