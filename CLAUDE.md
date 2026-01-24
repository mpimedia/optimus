# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@.mpi-standards/CLAUDE.base.md
@.mpi-standards/CLAUDE.rails.md

## Optimus-Specific Instructions

### About This Project

Optimus is the Rails application template and pattern source for the MPI Media application ecosystem. It serves as the reference implementation for coding standards, architectural patterns, and development workflows used across all MPI projects.

### Setup After Cloning

#### Submodule Initialization

This project uses shared standards via git submodule. After cloning:

```bash
git submodule update --init --recursive
```

Or clone with submodules in one command:

```bash
git clone --recurse-submodules https://github.com/mpimedia/optimus.git
```

#### MCP Configuration

After cloning this repository, create a `.mcp.json` file in the project root to enable MCP (Model Context Protocol) servers. This file is gitignored because it contains API keys.

Create `.mcp.json` with the following structure:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_CONTEXT7_API_KEY"
      }
    }
  }
}
```

Replace `YOUR_CONTEXT7_API_KEY` with your Context7 API key. You can obtain one from [Context7](https://context7.com).

### Related Projects

This repository serves as a Rails application template for the MPI Media application ecosystem. For cross-repository context, see `.claude/projects.json` which contains:

- **optimus** (this repo) - Rails application template and pattern source
- **avails** - Central data repository for MPI Media
- **sfa** - Video clip hosting and search engine
- **garden** - Static site generator for MPI sites
- **harvest** - Public-facing transaction and ecommerce platform

Each team member should create `.claude/projects.local.json` (gitignored) with their local paths to enable seamless cross-repo operations. See `.claude/projects.json` for GitHub URLs and project details.

### Updating Shared Standards

When shared standards in `mpi-application-standards` are updated:

```bash
# Pull latest standards
git submodule update --remote .mpi-standards

# Commit the update
git add .mpi-standards
git commit -m "Update shared standards to latest"
```
