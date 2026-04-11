---
updated: 2026-04-10
tags: [nexus, learning, rejections]
---

# Rejection Log

> **Purpose:** Every rejected or modified skill proposal is logged here with the reason.
> The NEXUS agent reads this file before proposing new skills to avoid repeating mistakes.
> Each rejection is a high-value training signal — be specific about WHY you rejected it.

---

## How to Log a Rejection

When you reject a skill from `Skills/_pending-review/`:

1. Move the file to `Skills/_rejected/`
2. Add an entry below with this format:

```
### YYYY-MM-DD: [Skill Name] (REJECTED / MODIFIED)
- **Proposed:** What the agent wanted to do
- **Reason:** Why you rejected or changed it
- **Agent mistake:** What the agent got wrong in its reasoning
- **Lesson:** The general rule the agent should learn from this
```

---

## Rejections

*No rejections yet. This log will populate as you review the agent's first proposals.*

<!-- 
Example entry for reference:

### 2026-04-15: Claude Vision Auto-Routing (REJECTED)
- **Proposed:** Route all image analysis to Claude Vision automatically
- **Reason:** ChatGPT handles image analysis better for my use cases (charts, data viz)
- **Agent mistake:** Assumed changelog announcement = superiority; didn't consider use-case fit
- **Lesson:** Don't change routing based solely on changelog; require A/B comparison evidence
-->
