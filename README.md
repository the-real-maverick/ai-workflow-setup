# AI Workflow Integration Setup

One-shot setup for a multi-AI workflow: **Perplexity Max + Claude Max + ChatGPT Plus** with Obsidian as the central knowledge hub.

## What This Does

1. **Installs Node.js** (via Homebrew) — required for MCP servers
2. **Creates Obsidian vault folder structure** — organized for multi-AI workflows
3. **Installs `CLAUDE.md`** — persistent context file at vault root for Claude Code
4. **Installs `context.md`** — master context file shared across all AIs
5. **Configures Claude Desktop MCP** — connects Claude to your Obsidian vault + Perplexity search

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/ai-workflow-setup.git
cd ai-workflow-setup
chmod +x setup.sh
./setup.sh
```

The script is interactive — it will:
- Auto-detect your iCloud-synced Obsidian vault
- Ask for your Perplexity API key (optional, for Claude → Perplexity search bridge)
- Back up any existing Claude Desktop config before replacing

## Files

| File | Purpose |
|------|---------|
| `setup.sh` | Main setup script — run this |
| `CLAUDE.md` | Gets copied to vault root — Claude Code reads this on every session |
| `Context/context.md` | Gets copied to vault `/Context/` — master context for all AIs |
| `claude_desktop_config.json` | Reference config (the script generates this dynamically) |

## Vault Structure Created

```
/AI-Conversations/
  /Claude/              ← Nightly Claude exports
  /ChatGPT/             ← Nightly ChatGPT exports
  /Perplexity/          ← Nightly Perplexity exports
/Context/
  context.md            ← Master context for all AIs
  /projects/            ← Active project briefs
/Research/              ← Perplexity research outputs
/Deliverables/          ← Finished work products
/Deals/                 ← Deal-specific folders
/Daily-Notes/           ← Daily journal
/Templates/             ← Note templates
```

## After Setup

1. **Restart Claude Desktop** — look for the hammer/tools icon
2. **Test:** Ask Claude "What files are in my Obsidian vault?"
3. **Install Chrome extension:** [Perplexity to Obsidian](https://extpose.com/ext/afmlkbanimddphcomahlfbaandfphjfk)
4. **Install Obsidian plugin:** "Local REST API" (for advanced MCP features)

## Architecture

```
Claude Desktop (MCP Hub)
    ├── Filesystem MCP → reads/writes Obsidian vault
    ├── Perplexity MCP → calls Perplexity web search
    └── (add more MCP servers as needed)

ChatGPT → Smart Connect app or file upload → Obsidian
Perplexity → Chrome extension batch export → Obsidian

Nightly 10:30 PM sync → all conversations → Obsidian vault
```
