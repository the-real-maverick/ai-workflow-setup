# Changelog

All notable changes to the AI Workflow Setup repo.

---

## 2026-04-10 (NEXUS Release)

### Added — NEXUS Self-Learning Agent
- **Skills/ folder structure** — Complete skill knowledge base with subfolders:
  - `_pending-review/` — Skills awaiting human approval
  - `_rejected/` — Rejected skills (agent reads before proposing)
  - `claude/`, `chatgpt/`, `perplexity/`, `mcp/`, `workflows/`, `new-tools/` — Verified skills by tool
  - `_skill-template.md` — Template with YAML frontmatter schema for new skill notes
  - `_dashboard.md` — Dataview-powered review dashboard (pending, verified, rejected, stats)

- **`_agent-routing-rules.md`** — Living routing document replacing static table in context.md
  - Version history, full routing table with reasons and skill references
  - Tool capability profiles (Claude, ChatGPT, Perplexity, MCP servers)
  - Pending Proposals section where NEXUS agent writes proposed changes

- **`_rejection-log.md`** — Agent reads this before proposing new skills to avoid repeating mistakes

- **`_learning-changelog.md`** — Tracks discovery stats, last-scanned dates per source, and full discovery log

### Changed
- **CLAUDE.md** — Added "NEXUS Self-Learning Agent Integration" section:
  - Reading skills (only use verified + human_approved)
  - Writing skills (draft to _pending-review, never modify routing directly)
  - User-taught learning workflow (skill notes instead of preference prompts)
  - Rejection-aware proposing
  - Skill lifecycle state machine
  - New fallback: NEXUS skill import failures

- **Context/context.md** — Added:
  - NEXUS Skills Library section (location, review cadence, notification preferences, discovery schedule)
  - Key decision: "Launched NEXUS self-learning agent"
  - Updated nightly sync reference to include NEXUS steps
  - Routing table now references `_agent-routing-rules.md` as source of truth
  - Added GUI automation and complex reasoning routing entries

- **nightly-pipeline.md** — Expanded from 4 steps to 5:
  - Step 1 updated: now also exports NEXUS skill drafts with `type: skill-draft` tagging
  - Step 3 updated: now routes skill drafts to `Skills/_pending-review/` and routing proposals to `_agent-routing-rules.md`
  - Step 3.5 (NEW): NEXUS routing reflection — analyzes today's AI usage, proposes routing improvements, reads rejection log
  - Step 4 updated: now includes NEXUS skill counts in context.md and surfaces pending reviews in Dashboard Top 3
  - Added NEXUS Discovery Schedule table (MCP scan, changelog, community intelligence)
  - Added Dataview plugin to setup requirements
  - Added NEXUS-specific troubleshooting entries

---

## 2026-04-10 (Initial)

### Added
- **GitHub Actions CI** (`validate-vault-files.yml`)
  - Runs on every push/PR that touches `CLAUDE.md`, `Context/context.md`, `nightly-pipeline.md`, or `nightly-digest-prompt.md`
  - Validates CLAUDE.md: required sections (Who I Am, Vault Structure, How I Want You to Work, Nightly Pipeline Fallbacks), identity present, references context.md, no leaked secrets
  - Validates context.md: YAML frontmatter with `updated` field, required sections (About Me, Current Projects, My Preferences, AI Routing Rules, Tools & Integrations), routing table present, no placeholders, no secrets, minimum file size
  - Cross-file checks: all YAML frontmatter properly closed, vault paths consistent, no API keys in any markdown file
  - Writes a summary table to the GitHub Actions job summary

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
