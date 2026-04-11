---
skill_id: ""
name: ""
description: >
  [One-paragraph description of what this skill enables.
  Include when to use it and what makes it distinct.]
tool: ""                              # claude | chatgpt | perplexity | mcp-[name] | workflow | [new-tool-name]
category: ""                          # reasoning | generation | research | automation | integration | communication | data | media
status: draft                         # discovered | draft | pending_review | verified | deprecated
stability: ""                         # experimental | beta | ga
discovered_date: ""                   # YYYY-MM-DD
source_url: ""
source_type: ""                       # official_changelog | community | documentation | user_taught | video | screenshot
routing_triggers: []
routing_exclusions: []
parameters: {}
test_result:
  last_tested: ""
  result: untested                    # pass | fail | partial | untested
  notes: ""
human_approved: false
approved_date: ""
supersedes: []
depends_on: []
related_skills: []
tags: []
---

# [Skill Name]

## What It Does

[Clear explanation of the capability. What becomes possible that wasn't before?]

## When to Use

- [Specific scenario 1]
- [Specific scenario 2]
- [Specific scenario 3]

## When NOT to Use

- [Anti-pattern 1]
- [Anti-pattern 2]

## How to Use

### Setup / Prerequisites

[Any configuration, model requirements, or dependencies]

### Usage

[Step-by-step instructions, API calls, prompt patterns, or workflow steps]

```
[Example prompt, API call, or code snippet]
```

### Expected Output

[What the output looks like when this skill works correctly]

## Gotchas

- [Edge case or limitation 1]
- [Edge case or limitation 2]

## Evidence

> [!review] **Approval Required**
> **Source:** [Where this was discovered]
> **Source URL:** [Link]
> **Confidence:** [Low/Medium/High] ([reason])
> **Routing Impact:** [How this should change task routing]
> **Test Result:** [What was tested and the outcome]
>
> **Action:**
> - To approve: Change `status: pending_review` → `status: verified` and set `human_approved: true`
> - To reject: Move this file to `Skills/_rejected/` and add your reason to `_rejection-log.md`
> - To modify: Edit the note, then approve
