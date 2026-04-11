---
type: reference
updated: 2026-04-10
---
# Nightly Automation Pipeline

The complete nightly sync runs in 5 steps across two systems. Perplexity Computer handles step 1 automatically. Steps 2-4 run as separate Claude Desktop Cowork tasks. Step 3.5 is the NEXUS reflection step.

Additionally, NEXUS discovery scans run on their own schedules (not nightly):
- **Sundays 7:00 PM** — MCP ecosystem scan (bi-weekly)
- **Sundays 8:00 PM** — Changelog + capability discovery (weekly)
- **Wednesdays 8:00 PM** — Community intelligence scan (weekly)

---

## Step 1 — 10:10 PM — Perplexity Computer → Obsidian Export

**System:** Perplexity Computer (scheduled task, runs automatically)
**Purpose:** Collects all Perplexity Computer outputs from the day (including NEXUS skill drafts) and formats them as Obsidian-compatible markdown notes so Claude can pick them up in steps 2-3.

**What it does:**
- Scans the Perplexity workspace for files created or modified today
- Formats each as a markdown note with YAML frontmatter (`source: perplexity-computer`, date, tags, type)
- **NEW:** If any files are NEXUS skill drafts (contain `type: skill-draft` in frontmatter), tags them for Step 3 to route to `Skills/_pending-review/`
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

## Step 3 — 10:30 PM — Vault Cleanup, Import & Skill Routing

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Archives completed projects, imports Perplexity Computer exports, and routes NEXUS skill drafts to the review queue.

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

4. ROUTE NEXUS SKILL DRAFTS:
   - Check AI-Conversations/Perplexity/ for any files with frontmatter containing "type: skill-draft"
   - For each skill draft found:
     a. Validate it has required frontmatter fields: skill_id, name, description, tool, status
     b. If valid: move to Skills/_pending-review/ with status set to "pending_review"
     c. If missing fields: move to Skills/_pending-review/ with status set to "draft" and add a note about missing fields
   - Also check for files with "type: routing-proposal" — move these to the Pending Proposals section of _agent-routing-rules.md
   - Log all skill imports to _learning-changelog.md

Do not modify Context/context.md or Dashboard.md — that happens in Step 4.
```

---

## Step 3.5 — 10:35 PM — NEXUS Routing Reflection

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Analyzes today's AI usage patterns, identifies routing improvements, and proposes updates. This is the NEXUS agent's nightly self-improvement loop.

**Claude Cowork prompt:**

```
Run the following using MCP vault access. This is the NEXUS routing reflection step.

1. READ TODAY'S CONTEXT:
   - Read today's digest: 08 Daily/YYYY-MM-DD-Chats.md
   - Read _agent-routing-rules.md (current routing table)
   - Read _rejection-log.md (to avoid repeating rejected proposals)
   - Read Skills/_dashboard.md frontmatter for current stats
   - Scan Skills/ folders for all verified skills (status: verified)

2. ANALYZE ROUTING DECISIONS:
   For each conversation in today's digest, ask:
   - Was the right AI tool used for this task? Could another tool have done it better?
   - Did any conversation reveal a capability gap? (User wanted something no AI could do)
   - Were there repeated task types that should have a dedicated routing rule?
   - Did any verified skill get used? Was it effective?

3. IDENTIFY LEARNING OPPORTUNITIES:
   - Are there recurring topics across recent digests that should become skills or templates?
   - Did the user express frustration with any tool's output? (Signal for routing change)
   - Did the user discover something new during a conversation? (Signal for skill creation)

4. PROPOSE IMPROVEMENTS (if any found):
   For routing changes:
   - Write proposals to the "Pending Proposals" section of _agent-routing-rules.md
   - Include: source conversation, current rule, proposed change, evidence, risk assessment
   
   For new skills:
   - Write draft skill notes to Skills/_pending-review/
   - Use the template from Skills/_skill-template.md
   - Set source_type to "reflection" and include the conversation that triggered it

5. UPDATE STATS:
   - Append today's reflection summary to _learning-changelog.md
   - Format: date, number of conversations analyzed, proposals made (if any), skills discovered (if any)

6. RULES:
   - If _rejection-log.md contains a similar proposal, DO NOT re-propose it unless you have genuinely new evidence
   - Never modify verified skills or the routing table directly — only propose
   - If no improvements found today, that's fine — write "No proposals" to the changelog and move on
   - Keep proposals concise — the user reviews these daily and needs to decide in 10-30 seconds each
```

---

## Step 4 — 10:40 PM — Context & Dashboard Update

**System:** Claude Desktop → Cowork (scheduled task)
**Purpose:** Updates the master context file and tomorrow's dashboard based on the fully reconciled vault state, including NEXUS skill status.

**Claude Cowork prompt:**

```
Run the following using MCP vault access:

1. READ the current state:
   - Context/context.md
   - All files in 03 Projects/
   - The most recent daily note in 08 Daily/
   - Today's digest (08 Daily/YYYY-MM-DD-Chats.md) if it exists
   - Dashboard.md
   - Skills/_pending-review/ (count of pending skills)
   - _agent-routing-rules.md (check for pending proposals)
   - _learning-changelog.md (today's entry)

2. UPDATE Context/context.md:
   - Refresh "Current Projects" section: update status, goals, and next steps for each active project based on project file contents
   - Add any new projects discovered in Step 3
   - Remove any projects archived in Step 3 (move to "Recently Completed")
   - Update "Key Decisions Made" if today's digest contains decisions
   - Update "NEXUS Skills Library" section:
     - Set "Current verified skills" count
     - Set "Pending review" count
   - Keep identity, preferences, and tools sections untouched

3. UPDATE Dashboard.md:
   - Replace "Top 3 today" with the three highest-leverage actions for tomorrow
   - Pull from: open loops in today's digest, stale action items across projects, approaching deadlines
   - **NEXUS integration:** If there are pending skill reviews (Skills/_pending-review/ has files) or pending routing proposals (_agent-routing-rules.md has entries in Pending Proposals), include ONE of the Top 3 as:
     - [ ] Review [N] pending NEXUS skills in Skills/_dashboard.md
   - If NEXUS discovered a high-confidence skill (stability: ga, from official_changelog), flag it specifically:
     - [ ] Review new [tool] skill: [name] — high confidence, from official changelog
   - Do NOT touch "This week" section unless it's Sunday night
   - Leave Quick links, Areas, Projects, and Templates sections untouched

4. VERIFY: Read back Context/context.md and confirm all sections are populated and no placeholders remain.
```

---

## Timing Summary

| Step | Time | System | Action |
|------|------|--------|--------|
| 1 | 10:10 PM | Perplexity (auto) | Export Computer outputs + skill drafts as Obsidian notes |
| 2 | 10:20 PM | Claude Cowork | Digest — collect all AI conversations → `[date]-Chats.md` |
| 3 | 10:30 PM | Claude Cowork | Archive projects, import exports, route skill drafts to review queue |
| 3.5 | 10:35 PM | Claude Cowork | NEXUS reflection — analyze routing, propose improvements |
| 4 | 10:40 PM | Claude Cowork | Update `context.md` + `Dashboard.md` top 3 (includes NEXUS status) |

### NEXUS Discovery Schedule (Non-Nightly)

| Task | Time | Frequency | System |
|------|------|-----------|--------|
| MCP Ecosystem Scan | Sun 7:00 PM | Bi-weekly | Perplexity Computer |
| Changelog Discovery | Sun 8:00 PM | Weekly | Perplexity Computer |
| Community Intelligence | Wed 8:00 PM | Weekly | Perplexity Computer |

---

## Setup Requirements

- **Claude Desktop** with MCP filesystem server pointing to the Obsidian vault (configured by `setup.sh`)
- **Claude in Chrome** MCP for ChatGPT and Perplexity conversation collection
- **Perplexity Max** subscription with Computer access (for Step 1 + NEXUS discovery tasks)
- **Chrome** must be open with active sessions on chat.openai.com and perplexity.ai for Step 2 to collect conversations
- **Dataview plugin** in Obsidian for the Skills dashboard queries
- **Skills/ folder structure** in vault (created by updated `setup.sh`)

## Troubleshooting

- **Digest shows "ChatGPT not accessible"**: Open Chrome and log into chat.openai.com before 10:20 PM
- **Digest shows "Perplexity not accessible"**: Open Chrome and log into perplexity.ai before 10:20 PM
- **No Perplexity Computer exports**: If you didn't use Perplexity Computer that day, Step 1 runs silently with no output — this is expected
- **Context.md has stale projects**: Check if project files in 03 Projects/ have been updated — Step 4 reads from those files
- **No NEXUS skill drafts**: Discovery scans only run weekly (Sun/Wed) — no drafts on other days is normal
- **Skill draft has "status: draft" instead of "pending_review"**: It was imported with missing frontmatter fields — open it in Obsidian and fill in the gaps, then change status to pending_review
- **Routing proposal was already rejected**: The reflection step should check _rejection-log.md, but if a duplicate slips through, reject it again and add a note to the log about the repeated proposal
