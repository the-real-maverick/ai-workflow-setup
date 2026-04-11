---
updated: 2026-04-10
update_count: 1
auto_update_enabled: false
requires_approval: true
tags: [nexus, routing, living-document]
---

# AI Routing Rules (Living Document)

> **This is a living document.** The NEXUS agent proposes updates in the Pending Proposals
> section below. To approve a proposal, move it into the Routing Table and delete it from
> Pending. To reject, move it to `_rejection-log.md` with your reason.

---

## Version History

| Date | Change | Source | Approved |
|------|--------|--------|----------|
| 2026-04-10 | Initial rules migrated from context.md | Manual setup | Yes |

---

## Routing Table

| Task Type | Route To | Reason | Skill Reference |
|-----------|----------|--------|-----------------|
| Market research, comps, citations | Perplexity | Best sourced web research with citations | — |
| Contract review, long documents, writing | Claude | 200K token context, strong analytical reasoning | — |
| Data files, charts, images, video | ChatGPT | DALL-E, Sora, Python code interpreter | — |
| Coding, automation, scripts | Claude (Code) | Best code generation and debugging | — |
| Quick factual Q&A | Perplexity | Fastest with inline citations | — |
| Multi-model validation | Perplexity (Model Council) | Cross-model consensus checking | — |
| GUI automation, browser tasks | Perplexity Computer | Web access + scheduled task execution | — |
| Complex reasoning, multi-step analysis | Claude | Extended thinking when accuracy matters more than speed | — |
| Real estate deal analysis | Claude + Perplexity | Claude for financial modeling, Perplexity for market comps | — |
| Vault management, file operations | Claude Desktop (MCP) | Direct filesystem access to Obsidian vault | — |

---

## Tool Capability Profiles

### Claude (Desktop + Code + API)
- **Context window:** 200K tokens
- **Strengths:** Long-document synthesis, contract analysis, code generation, financial modeling, structured reasoning
- **MCP tools:** Obsidian vault (filesystem), Perplexity search (Sonar API)
- **Limitations:** No image generation, no real-time web access (except via Perplexity MCP)

### ChatGPT (Plus)
- **Strengths:** DALL-E image generation, Sora video, Python code interpreter, data analysis with charts, persistent memory across sessions
- **Limitations:** Smaller context than Claude, no MCP, no vault access

### Perplexity (Max + Computer)
- **Strengths:** Real-time web search with citations, Model Council for cross-model consensus, Computer agent for browser automation and scheduled tasks
- **Limitations:** No vault access (uses context.md copy in Space), shorter context for deep analysis

### MCP Servers (Current)
- `obsidian-vault` — @modelcontextprotocol/server-filesystem → Obsidian vault read/write
- `perplexity-search` — server-perplexity-ask → Claude can call Perplexity search mid-conversation

---

## Pending Proposals

*No pending routing proposals. The NEXUS discovery agent will write proposals here.*

<!-- 
Format for proposals:

### [Date]: [Proposed Change]
- **Source:** [Where this was discovered — changelog URL, community post, etc.]
- **Current rule:** [What the routing table says now]
- **Proposed change:** [What should change and why]
- **Evidence:** [Test results or documentation supporting this change]
- **Risk:** [What could go wrong]
- **Action:** Approve (move to table above) / Reject (move to _rejection-log.md)
-->
