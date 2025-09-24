"""Main MCP server implementation"""

import asyncio
from typing import Any, Dict, List
from mcp.server import Server
from mcp.server.models import InitializationOptions
from mcp.server.stdio import stdio_server
from mcp.types import (
    CallToolRequest,
    CallToolResult,
    ListToolsRequest,
    ListToolsResult,
    Tool,
    TextContent,
)
from .tools import (
    install_dotfiles,
    backup_dotfiles,
    restore_dotfiles,
    update_dotfiles,
    test_dotfiles,
    doctor_dotfiles,
    list_aliases,
    get_dotfiles_status,
    clean_dotfiles,
    benchmark_shell,
)

server = Server("dotfiles-manager")

@server.list_tools()
async def handle_list_tools() -> List[Tool]:
    """List available dotfiles management tools"""
    return [
        Tool(
            name="install_dotfiles",
            description="Install or update dotfiles configuration",
            inputSchema={
                "type": "object",
                "properties": {
                    "force": {
                        "type": "boolean",
                        "description": "Force installation without prompts",
                        "default": False
                    },
                    "minimal": {
                        "type": "boolean", 
                        "description": "Install minimal configuration only",
                        "default": False
                    }
                }
            }
        ),
        Tool(
            name="backup_dotfiles",
            description="Create backup of current dotfiles configuration",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="restore_dotfiles",
            description="Restore dotfiles from backup",
            inputSchema={
                "type": "object",
                "properties": {
                    "backup_dir": {
                        "type": "string",
                        "description": "Path to backup directory"
                    }
                },
                "required": ["backup_dir"]
            }
        ),
        Tool(
            name="update_dotfiles",
            description="Update dotfiles and dependencies",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="test_dotfiles",
            description="Run tests on dotfiles configuration",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="doctor_dotfiles",
            description="Run system diagnostics for dotfiles",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="list_aliases",
            description="List all available aliases and their descriptions",
            inputSchema={
                "type": "object",
                "properties": {
                    "category": {
                        "type": "string",
                        "description": "Filter by category (git, docker, system, etc.)",
                        "default": "all"
                    }
                }
            }
        ),
        Tool(
            name="get_dotfiles_status",
            description="Get current status of dotfiles installation",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="clean_dotfiles",
            description="Clean up broken symlinks and temporary files",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="benchmark_shell",
            description="Benchmark shell startup time",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(name: str, arguments: Dict[str, Any]) -> List[TextContent]:
    """Handle tool calls"""
    
    tool_map = {
        "install_dotfiles": install_dotfiles,
        "backup_dotfiles": backup_dotfiles,
        "restore_dotfiles": restore_dotfiles,
        "update_dotfiles": update_dotfiles,
        "test_dotfiles": test_dotfiles,
        "doctor_dotfiles": doctor_dotfiles,
        "list_aliases": list_aliases,
        "get_dotfiles_status": get_dotfiles_status,
        "clean_dotfiles": clean_dotfiles,
        "benchmark_shell": benchmark_shell,
    }
    
    if name in tool_map:
        return await tool_map[name](arguments)
    else:
        raise ValueError(f"Unknown tool: {name}")

async def main():
    """Main server function"""
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="dotfiles-manager",
                server_version="1.0.0",
                capabilities=server.get_capabilities(
                    notification_options=None,
                    experimental_capabilities={}
                )
            )
        )

if __name__ == "__main__":
    asyncio.run(main())
