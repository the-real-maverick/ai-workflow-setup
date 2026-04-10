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
