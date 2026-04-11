# Changelog

All notable changes to the AI Workflow Setup repo.

---

## 2026-04-10

### Added
- **Initial setup** (`c5cbedb`)
  - `setup.sh` — one-shot installer: Node.js, vault folder structure, Claude Desktop MCP config
  - `CLAUDE.md` — vault root context file for Claude Code (identity, vault structure, work preferences)
  - `Context/context.md` — master context file shared across all AIs (projects, preferences, routing rules)
  - `claude_desktop_config.json` — reference MCP config (Obsidian filesystem + Perplexity Sonar)
  - `README.md` — repo documentation

- **Vault detection fixes** (`4d20015`, `7c2c181`)
  - Fixed iCloud vault auto-detection to search `com~apple~CloudDocs/Obsidian/` (not just the Obsidian-specific iCloud container)
  - Added vault path as CLI argument to skip slow iCloud scanning: `./setup.sh /path/to/vault`

- **Nightly pipeline** (`1602fd9`)
  - `nightly-pipeline.md` — full 4-step nightly automation reference (timing, prompts, troubleshooting)
  - `nightly-digest-prompt.md` — complete Claude Cowork prompt for Step 2 (chat digest across Claude, ChatGPT, Perplexity web, and Perplexity Computer)
  - Pipeline: 10:10 PM Perplexity export → 10:20 PM digest → 10:30 PM vault cleanup → 10:40 PM context/dashboard update

- **Fallbacks and backup** (`8af64fe`)
  - `CLAUDE.md`: Added "Nightly Pipeline Fallbacks" section
    - Perplexity Computer export failure → writes `pending-manual-upload` placeholder, flags in digest, adds morning action to Dashboard
    - Chrome session failure → skips gracefully, surfaces as morning action item
  - `nightly-digest-prompt.md`: Added Step 5 — iCloud backup
    - Copies finished digest to `iCloud Drive/AI-Digest-Backups/` outside the vault
    - Auto-creates backup folder on first run
    - Failure note appended to digest footer if copy fails
