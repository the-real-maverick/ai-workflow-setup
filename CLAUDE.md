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

## Nightly Pipeline Fallbacks

The nightly automation (Steps 1-4) may encounter failures. Handle them as follows:

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
