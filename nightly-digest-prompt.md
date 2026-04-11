---
type: claude-cowork-prompt
schedule: "10:20 PM daily"
step: 2
---
# Nightly Chat Digest — Claude Cowork Prompt

Paste this into Claude Desktop → Cowork as a scheduled task at 10:20 PM.

---

You are running the Nightly Chat Digest for Jake Althaus. Collect today's Claude (Cowork), ChatGPT, and Perplexity conversations, extract the meaningful content from each, and write a single organized digest note into his Obsidian vault.

Vault path: /Users/jakealthaus/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/Jake-Obsidian-Full-Operating-System

---

## STEP 1 -- Get today's date

Use mcp__Control_your_Mac__osascript: do shell script "date '+%Y-%m-%d'"
Store this as TODAY (e.g. 2026-04-03).

---

## STEP 2 -- Collect Claude / Cowork sessions from today

Call mcp__session_info__list_sessions with limit=30.
For each session active today, call mcp__session_info__read_transcript.
Identify: main topic (1 sentence), key decisions, action items, relevant vault area.
Skip trivial sessions (under 3 exchanges) or sessions with no decisions/actions.

---

## STEP 3 -- Collect ChatGPT conversations from today

Use mcp__Claude_in_Chrome__tabs_context_mcp (createIfEmpty: true) to get a tab.
If no chat.openai.com tab exists, use mcp__Claude_in_Chrome__navigate to go to https://chat.openai.com and wait 2 seconds.

IMPORTANT: The ChatGPT backend API requires an Authorization Bearer token. Always get it first:

```javascript
(async () => {
const r = await fetch('/api/auth/session', {credentials: 'include'});
const s = await r.json();
return s.accessToken || '';
})()
```

Store that token. Then list conversations (always pass the token in headers):

```javascript
(async () => {
const token = 'TOKEN_HERE';
const r = await fetch('/backend-api/conversations?offset=0&limit=50&order=updated', {
credentials: 'include',
headers: {'Authorization': 'Bearer ' + token}
});
const d = await r.json();
const cutoff = Date.now() - 36 * 60 * 60 * 1000;
const today = (d.items || []).filter(c => new Date(c.update_time).getTime() > cutoff);
return JSON.stringify(today.map(c => ({id: c.id, title: c.title, updated: c.update_time})));
})()
```

For each conversation active today, fetch its content:

```javascript
(async () => {
const token = 'TOKEN_HERE';
const r = await fetch('/backend-api/conversation/CONVERSATION_ID_HERE', {
credentials: 'include',
headers: {'Authorization': 'Bearer ' + token}
});
const d = await r.json();
const msgs = Object.values(d.mapping || {})
.filter(m => m.message && (m.message.author.role === 'user' || m.message.author.role === 'assistant'))
.sort((a, b) => (a.message.create_time || 0) - (b.message.create_time || 0))
.map(m => ({
role: m.message.author.role,
text: (m.message.content?.parts || []).filter(p => typeof p === 'string').join(' ').substring(0, 600)
}));
return JSON.stringify({title: d.title, messages: msgs.slice(0, 30)});
})()
```

Replace TOKEN_HERE and CONVERSATION_ID_HERE with actual values each time. From each conversation extract: main topic, key decisions, action items, relevant vault area.
Skip conversations that are trivial, casual (gift notes, promo codes), or contain no decisions or actionable content.

---

## STEP 3B -- Collect Perplexity conversations from today

Use mcp__Claude_in_Chrome__tabs_context_mcp (createIfEmpty: true) to get a tab.
If no perplexity.ai tab exists, use mcp__Claude_in_Chrome__navigate to go to https://www.perplexity.ai and wait 2 seconds.

Perplexity uses session cookies for auth -- no separate token fetch required. List recent threads:

```javascript
(async () => {
const r = await fetch('/rest/user/threads?version=2.11&source=default', {
credentials: 'include'
});
const d = await r.json();
const cutoff = Date.now() - 36 * 60 * 60 * 1000;
const today = (d || []).filter(t => new Date(t.updated_at || t.created_at).getTime() > cutoff);
return JSON.stringify(today.map(t => ({id: t.id, title: t.title || t.query_str, updated: t.updated_at})));
})()
```

For each thread active today, fetch its content:

```javascript
(async () => {
const r = await fetch('/rest/threads/THREAD_ID_HERE', {
credentials: 'include'
});
const d = await r.json();
const steps = (d.steps || []).map(s => ({
query: (s.query_str || '').substring(0, 300),
answer: (s.text || '').substring(0, 600)
}));
return JSON.stringify({title: d.title || d.query_str, steps: steps.slice(0, 15)});
})()
```

Replace THREAD_ID_HERE with actual values each time. From each thread extract: main topic, key decisions, action items, relevant vault area.
Skip threads that are trivial lookups with no decisions or actionable content.
If Perplexity is not accessible or thread fetch fails, skip this section and note:
*Perplexity not accessible -- open Chrome and log into perplexity.ai to enable.*

---

## STEP 3C -- Collect Perplexity Computer outputs

Check if any files exist in AI-Conversations/Perplexity/ with today's date and frontmatter containing "source: perplexity-computer".
If found, extract: task description, key outputs produced, any action items or follow-ups.

---

## STEP 4 -- Write the digest note

Check if file exists:
do shell script "test -f 'VAULT/08 Daily/TODAY-Chats.md' && echo exists || echo missing"

If exists: append a new section with a timestamp header. If missing: create fresh.

Write via Python at /tmp/write_digest.py then: do shell script "python3 /tmp/write_digest.py"

Python script requirements:
- Start with: # -*- coding: utf-8 -*-
- ASCII only in content (replace -- for dashes, straight quotes)
- Write with open(path, 'a' if exists else 'w', encoding='utf-8')
- After writing, fix line endings: read binary, replace b'\r\n' and b'\r' with b'\n', write binary

## Output format

# Chat Digest -- TODAY

*Auto-generated at 10:30 PM. Edit freely.*

---

## Claude Sessions

### [Session title]
**Area:** [[02 Areas/Career Strategy]]
**Summary:** One sentence.
**Key points:**
- Point 1
- Point 2
**Action items:**
- [ ] Action 1

(If none: *No Claude sessions today.*)

---

## ChatGPT Conversations

### [Conversation title]
**Area:** [[02 Areas/Real Estate Operating System]]
**Summary:** One sentence.
**Key points:**
- Point 1
**Action items:**
- [ ] Action 1

(If none or not accessible: note it clearly.)

---

## Perplexity Threads

### [Thread title]
**Area:** [[02 Areas/Real Estate Operating System]]
**Summary:** One sentence.
**Key points:**
- Point 1
**Action items:**
- [ ] Action 1

(If none or not accessible: note it clearly.)

---

## Perplexity Computer Tasks

### [Task description]
**Summary:** One sentence.
**Key outputs:** What was produced (reports, data, code, etc.)
**Action items:**
- [ ] Any follow-ups

(If none: *No Perplexity Computer tasks today.*)

---

## Open loops
(Unresolved questions or cross-conversation follow-ups)

---
*-> [[Dashboard]] -- [[08 Daily/Daily Notes]]*

---

## STEP 5 -- Back up digest to iCloud

After the digest is written and verified, copy it to a dedicated iCloud backup folder outside the Obsidian vault.

Backup path: /Users/jakealthaus/Library/Mobile Documents/com~apple~CloudDocs/AI-Digest-Backups/

Use osascript:
```
do shell script "mkdir -p '$HOME/Library/Mobile Documents/com~apple~CloudDocs/AI-Digest-Backups' && cp 'VAULT/08 Daily/TODAY-Chats.md' '$HOME/Library/Mobile Documents/com~apple~CloudDocs/AI-Digest-Backups/TODAY-Chats.md'"
```

Replace VAULT and TODAY with actual values. This ensures the digest survives even if the Obsidian vault is corrupted, accidentally deleted, or iCloud sync breaks for the vault folder specifically.

If the copy fails, note in the digest footer:
*iCloud backup failed -- manually copy 08 Daily/TODAY-Chats.md to iCloud Drive > AI-Digest-Backups tomorrow.*

---

## CONSTRAINTS
- Vault path: /Users/jakealthaus/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/Jake-Obsidian-Full-Operating-System
- 08 Daily folder already exists. Do not create it.
- Never include passwords, API keys, financial account numbers, or sensitive IPO/M&A details.
- Summaries and bullets only -- never paste raw conversation text.
- Keep total note under 900 words.
- Useful vault wikilinks: [[02 Areas/Career Strategy]], [[02 Areas/Real Estate Operating System]], [[02 Areas/Family Operating System]], [[02 Areas/Health & Fitness]], [[02 Areas/Investing & Wealth]], [[02 Areas/Vehicles & Gear]], [[03 Projects/Round One - 30-60-90]], [[03 Projects/Business Acquisition Thesis]], [[03 Projects/NEXUS -- AI Orchestrator]], [[03 Projects/R1 VP Real Estate Expansion Strategy]]
- If Chrome not open or token fetch fails for any platform, skip that section and note the issue clearly.
- After writing, verify: do shell script "wc -l 'VAULT/08 Daily/TODAY-Chats.md'"
