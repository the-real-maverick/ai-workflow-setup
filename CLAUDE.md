# CLAUDE.md
## Who I Am
Jacob Althaus, Vice President of Real Estate based in West Hollywood, CA.

## Vault Structure
```
/AI-Conversations/       — Nightly exports from all AI platforms
  /Claude/               — Claude conversation exports
  /ChatGPT/              — ChatGPT conversation exports
  /Perplexity/           — Perplexity conversation exports
/Context/                — Shared context files for all AIs
  context.md             — Master context (read this first)
  projects/              — Active project briefs
/Research/               — Perplexity research outputs & web findings
/Deliverables/           — Finished work products (memos, reports, models)
/Deals/                  — Deal-specific folders (one per deal)
/Daily-Notes/            — Daily journal / log
/Templates/              — Note templates
/Skills/                 — NEXUS skill knowledge base
  /_pending-review/      — Skills awaiting human approval
  /_rejected/            — Rejected skills (read before proposing)
  /claude/               — Verified Claude skills
  /chatgpt/              — Verified ChatGPT skills
  /perplexity/           — Verified Perplexity skills
  /mcp/                  — Verified MCP server skills
  /workflows/            — Cross-tool workflow skills
  /new-tools/            — Skills for tools not yet in the stack
  _dashboard.md          — Dataview review dashboard
  _skill-template.md     — Template for new skill notes
```

## How I Want You to Work
- **Always read `/Context/context.md` before starting any task** — it contains my active projects, preferences, and recent decisions
- Check `/Research/` for existing Perplexity findings on the topic before doing new research
- Check `/AI-Conversations/` for recent conversations that may have relevant context
- Save outputs to the appropriate folder based on content type
- Use YAML frontmatter with tags for all new notes:
  ```yaml
  ---
  date: {{date}}
  source: claude
  tags: [relevant, tags]
  project: project-name
  ---
  ```
- When creating deal-specific content, save to `/Deals/[deal-name]/`
- Prefer tables for comparisons, bullet points for lists
- Always cite sources when referencing external data
- Flag assumptions explicitly — don't present uncertain data as fact
- Ask before deleting or overwriting existing files

## NEXUS Self-Learning Agent Integration

### Reading Skills
Before routing a task, check `Skills/` for verified skills that match the task:
1. Read `_agent-routing-rules.md` for high-level routing decisions
2. Check tool-specific folders (`Skills/claude/`, `Skills/chatgpt/`, etc.) for detailed skill notes relevant to the task
3. **Only use skills with `status: verified` and `human_approved: true`**
4. **Never use skills with `status: draft` or `status: pending_review`** — these are unconfirmed
5. If a skill has `stability: experimental` or `stability: beta`, mention this when using it

### Writing Skills (When You Discover Something New)
When you discover a new capability, learn something from the user, or identify a technique:
1. Read `_rejection-log.md` first — check if a similar skill was already rejected
2. Read `_learning-changelog.md` to check if this has already been discovered
3. Write a draft skill note using the template at `Skills/_skill-template.md`
4. Save to `Skills/_pending-review/` with a descriptive filename
5. Include an Evidence Pack callout at the top of the note
6. **Do NOT update `_agent-routing-rules.md` directly** — propose changes in its Pending Proposals section
7. **Do NOT update `context.md` routing rules directly** — all routing changes go through review

### When the User Teaches You
If the user shares a video, screenshot, article, or direct instruction about a capability:
1. Create a skill note with `source_type: user_taught` (or `video`, `screenshot` as appropriate)
2. Set `confidence: high` since the user is the source
3. Still write to `Skills/_pending-review/` — the user approves by changing the status field
4. Extrapolate: research the capability further (documentation, edge cases, related skills) and include findings in the skill note
5. If the teaching is a preference update (not a skill), propose a diff to `context.md` or `_agent-routing-rules.md` instead

### Before Proposing Anything
Always read `_rejection-log.md` first. If your proposal is similar to a previously rejected one:
- Either don't propose it
- Or explain specifically what's different this time and why the previous rejection reason doesn't apply

### Skill Lifecycle
```
DISCOVERED → DRAFT → PENDING_REVIEW → VERIFIED (human approved)
                ↑          |                         ↓
                └──────────┘ (rejected → _rejected/ + log)    DEPRECATED
```

## Nightly Pipeline Fallbacks

The nightly automation (Steps 1-4, plus NEXUS Steps 3.5 and updated Step 4) may encounter failures. Handle them as follows:

### Perplexity Computer Export Failure (Step 1)
If no Perplexity Computer exports appear in `AI-Conversations/Perplexity/` by 10:20 PM (i.e., no files with today's date and `source: perplexity-computer` in frontmatter), this means the Perplexity scheduled export did not run or produced nothing.

**Fallback — Manual Upload:**
1. During Steps 2-3 (Digest and Vault Cleanup), check `AI-Conversations/Perplexity/` for today's Computer exports
2. If missing, write a placeholder note:
   ```
   AI-Conversations/Perplexity/YYYY-MM-DD-computer-pending.md
   ```
   With contents:
   ```yaml
   ---
   date: YYYY-MM-DD
   source: perplexity-computer
   status: pending-manual-upload
   tags: [fallback, needs-review]
   ---
   # Perplexity Computer -- Manual Upload Needed

   The automated export did not run for this date.

   **Action required:** Open Perplexity Computer, check today's tasks, and
   manually export any outputs to this folder. Rename this file when done.

   Alternatively, open the Perplexity to Obsidian Chrome extension and
   batch export today's conversations to this folder.
   ```
3. In the digest (`08 Daily/YYYY-MM-DD-Chats.md`), flag this under the Perplexity Computer Tasks section:
   *Automated export did not run. Manual upload pending -- check AI-Conversations/Perplexity/ tomorrow morning.*
4. In Dashboard.md "Top 3 today" for the next morning, include:
   - [ ] Review and manually export yesterday's Perplexity Computer outputs

### Chrome Session Failures (Steps 2-3)
If ChatGPT or Perplexity web conversations can't be collected (Chrome not open, session expired):
- Skip that section in the digest and note the failure clearly
- Do NOT block the rest of the pipeline -- continue with available sources
- Add a morning action item to Dashboard.md: "Re-run digest for [platform] -- Chrome was closed"

### NEXUS Skill Import Failures (Step 3)
If skill draft files from Perplexity Computer are malformed or missing required frontmatter:
- Move them to `Skills/_pending-review/` anyway but add `status: draft` (not `pending_review`)
- Add a note to the file: "Imported with missing/malformed frontmatter — needs manual review"
- Flag in Dashboard.md Top 3: "Review malformed skill draft in Skills/_pending-review/"
