"""Tool implementations for the MCP server"""

from typing import Dict, Any, List
from mcp.types import TextContent
from .utils import run_command


async def install_dotfiles(args: Dict[str, Any]) -> List[TextContent]:
    """Install dotfiles"""
    force = args.get("force", False)
    minimal = args.get("minimal", False)
    
    if minimal:
        cmd = ["make", "install-minimal"]
    elif force:
        cmd = ["make", "install-force"]
    else:
        cmd = ["make", "install"]
    
    result = await run_command(cmd)
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Dotfiles installation completed successfully!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text", 
            text=f"❌ Dotfiles installation failed!\n\nError:\n{result['stderr']}\n\nOutput:\n{result['stdout']}"
        )]


async def backup_dotfiles() -> List[TextContent]:
    """Create backup of dotfiles"""
    result = await run_command(["make", "backup"])
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Backup created successfully!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text",
            text=f"❌ Backup failed!\n\nError:\n{result['stderr']}"
        )]


async def restore_dotfiles(args: Dict[str, Any]) -> List[TextContent]:
    """Restore dotfiles from backup"""
    backup_dir = args.get("backup_dir")
    if not backup_dir:
        return [TextContent(
            type="text",
            text="❌ backup_dir parameter is required"
        )]
    
    cmd = ["make", "restore", f"BACKUP_DIR={backup_dir}"]
    result = await run_command(cmd)
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Restore completed successfully!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text",
            text=f"❌ Restore failed!\n\nError:\n{result['stderr']}"
        )]


async def update_dotfiles() -> List[TextContent]:
    """Update dotfiles"""
    result = await run_command(["make", "update"])
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Update completed successfully!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text",
            text=f"❌ Update failed!\n\nError:\n{result['stderr']}"
        )]


async def test_dotfiles() -> List[TextContent]:
    """Test dotfiles configuration"""
    result = await run_command(["make", "test"])
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Tests passed!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text",
            text=f"❌ Tests failed!\n\nError:\n{result['stderr']}\n\nOutput:\n{result['stdout']}"
        )]


async def doctor_dotfiles() -> List[TextContent]:
    """Run system diagnostics"""
    result = await run_command(["make", "doctor"])
    
    return [TextContent(
        type="text",
        text=f"🔍 System Diagnostics:\n\n{result['stdout']}\n\nErrors:\n{result['stderr']}"
    )]


async def list_aliases(args: Dict[str, Any]) -> List[TextContent]:
    """List available aliases"""
    category = args.get("category", "all")
    
    from .config import DOTFILES_DIR
    aliases_file = DOTFILES_DIR / "zsh" / "aliases.zsh"
    if not aliases_file.exists():
        return [TextContent(
            type="text",
            text="❌ Aliases file not found"
        )]
    
    try:
        with open(aliases_file, 'r') as f:
            content = f.read()
        
        aliases = []
        lines = content.split('\n')
        
        for line in lines:
            line = line.strip()
            if line.startswith('alias ') and '=' in line:
                parts = line.split('=', 1)
                if len(parts) == 2:
                    alias_name = parts[0].replace('alias ', '').strip()
                    alias_cmd = parts[1].strip().strip("'\"")
                    aliases.append(f"`{alias_name}` - {alias_cmd}")
        
        if category != "all":
            filtered_aliases = [a for a in aliases if category.lower() in a.lower()]
            aliases = filtered_aliases
        
        return [TextContent(
            type="text",
            text=f"📋 Available Aliases ({len(aliases)} total):\n\n" + "\n".join(aliases[:50]) + 
                 (f"\n\n... and {len(aliases) - 50} more" if len(aliases) > 50 else "")
        )]
        
    except Exception as e:
        return [TextContent(
            type="text",
            text=f"❌ Error reading aliases: {str(e)}"
        )]


async def get_dotfiles_status() -> List[TextContent]:
    """Get dotfiles status"""
    result = await run_command(["make", "status"])
    
    return [TextContent(
        type="text",
        text=f"📊 Dotfiles Status:\n\n{result['stdout']}\n\nErrors:\n{result['stderr']}"
    )]


async def clean_dotfiles() -> List[TextContent]:
    """Clean dotfiles"""
    result = await run_command(["make", "clean"])
    
    if result["success"]:
        return [TextContent(
            type="text",
            text=f"✅ Cleanup completed successfully!\n\nOutput:\n{result['stdout']}"
        )]
    else:
        return [TextContent(
            type="text",
            text=f"❌ Cleanup failed!\n\nError:\n{result['stderr']}"
        )]


async def benchmark_shell() -> List[TextContent]:
    """Benchmark shell startup"""
    result = await run_command(["make", "benchmark"])
    
    return [TextContent(
        type="text",
        text=f"⏱️ Shell Benchmark Results:\n\n{result['stdout']}\n\nErrors:\n{result['stderr']}"
    )]
