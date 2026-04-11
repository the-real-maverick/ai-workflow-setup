---
type: reference
updated: 2026-04-10
---
# Nightly Automation Pipeline

The complete nightly sync runs in 4 steps across two systems. Perplexity Computer handles step 1 automatically. Steps 2-4 run as separate Claude Desktop Cowork tasks.

---

## Step 1 — 10:10 PM — Perplexity Computer → Obsidian Export

**System:** Perplexity Computer (scheduled task, runs automatically)
**Purpose:** Collects all Perplexity Computer outputs from the day and formats them as Obsidian-compatible markdown notes so Claude can pick them up in steps 2-3.

**What it does:**
- Scans the Perplexity workspace for files created or modified today
- Formats each as a markdown note with YAML frontmatter (`source: perplexity-computer`, date, tags, type)
- Saves to a staging location for Claude to import
- File naming: `YYYY-MM-DD-[descriptive-name].md`
- Creates a daily index file listing everything exported

**Output location:** Perplexity workspace → picked up by Claude in Step 3

**No action required** — this runs automatically via Perplexity's scheduled task system.

---

## Step 2 — 10:20 PM — Chat Digest

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Collects all AI conversations from the day across Claude, ChatGPT, and Perplexity, extracts meaningful content, and writes a single organized digest note.

**Output:** `08 Daily/YYYY-MM-DD-Chats.md`

**Claude Cowork prompt:** Use the full digest script (see `nightly-digest-prompt.md` in this repo).

---

## Step 3 — 10:30 PM — Vault Cleanup & Import

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Archives completed projects and imports Perplexity Computer exports into the vault.

**Claude Cowork prompt:**

```
Run the following using MCP vault access:

1. ARCHIVE COMPLETED PROJECTS:
   - Read all files in 03 Projects/
   - For any project marked as "Complete", "Done", or "Closed":
     a. Move the project note to 07 Archive/
     b. Append a summary line to 07 Archive/Archive Index.md: project name, completion date, outcome (1 sentence)
     c. Remove from "Current Projects" in Context/context.md
     d. Add to a "Recently Completed" section in Context/context.md (keep for 30 days as reference, then remove)

2. IMPORT PERPLEXITY COMPUTER EXPORTS:
   - Check AI-Conversations/Perplexity/ for any new files with frontmatter containing "source: perplexity-computer"
   - If the Perplexity Computer nightly export produced files, they should already be in the vault from the 10:10 PM export
   - If not present, check if any were staged and note the gap

3. IMPORT NEW PROJECTS:
   - Check 03 Projects/ for any new project files not yet tracked in Context/context.md
   - If found, read the file and flag for inclusion in Step 4

Do not modify Context/context.md or Dashboard.md — that happens in Step 4.
```

---

## Step 4 — 10:40 PM — Context & Dashboard Update

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Updates the master context file and tomorrow's dashboard based on the fully reconciled vault state.

**Claude Cowork prompt:**

```
Run the following using MCP vault access:

1. READ the current state:
   - Context/context.md
   - All files in 03 Projects/
   - The most recent daily note in 08 Daily/
   - Today's digest (08 Daily/YYYY-MM-DD-Chats.md) if it exists
   - Dashboard.md

2. UPDATE Context/context.md:
   - Refresh "Current Projects" section: update status, goals, and next steps for each active project based on project file contents
   - Add any new projects discovered in Step 3
   - Remove any projects archived in Step 3 (move to "Recently Completed")
   - Update "Key Decisions Made" if today's digest contains decisions
   - Keep identity, preferences, AI routing rules, and tools sections untouched

3. UPDATE Dashboard.md:
   - Replace "Top 3 today" with the three highest-leverage actions for tomorrow
   - Pull from: open loops in today's digest, stale action items across projects, approaching deadlines
   - Do NOT touch "This week" section unless it's Sunday night
   - Leave Quick links, Areas, Projects, and Templates sections untouched

4. VERIFY: Read back Context/context.md and confirm all sections are populated and no placeholders remain.
```

---

## Timing Summary

| Step | Time | System | Action |
|------|------|--------|--------|
| 1 | 10:10 PM | Perplexity (auto) | Export Computer outputs as Obsidian notes |
| 2 | 10:20 PM | Claude Cowork | Digest — collect all AI conversations → `[date]-Chats.md` |
| 3 | 10:30 PM | Claude Cowork | Archive completed projects, import exports |
| 4 | 10:40 PM | Claude Cowork | Update `context.md` + `Dashboard.md` top 3 |

---

## Setup Requirements

- **Claude Desktop** with MCP filesystem server pointing to the Obsidian vault (configured by `setup.sh`)
- **Claude in Chrome** MCP for ChatGPT and Perplexity conversation collection
- **Perplexity Max** subscription with Computer access (for Step 1 scheduled task)
- **Chrome** must be open with active sessions on chat.openai.com and perplexity.ai for Step 2 to collect conversations

## Troubleshooting

- **Digest shows "ChatGPT not accessible"**: Open Chrome and log into chat.openai.com before 10:20 PM
- **Digest shows "Perplexity not accessible"**: Open Chrome and log into perplexity.ai before 10:20 PM
- **No Perplexity Computer exports**: If you didn't use Perplexity Computer that day, Step 1 runs silently with no output — this is expected
- **Context.md has stale projects**: Check if project files in 03 Projects/ have been updated — Step 4 reads from those files
