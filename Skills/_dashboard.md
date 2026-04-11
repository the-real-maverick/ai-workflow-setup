---
updated: 2026-04-10
tags: [nexus, skills, dashboard]
---

# NEXUS Skills Dashboard

> **Daily Review:** Check this dashboard each morning alongside your Dashboard.md Top 3.
> Pending skills are surfaced in your Top 3 when high-confidence discoveries arrive.

---

## Pending Review

```dataview
TABLE WITHOUT ID
  file.link AS "Skill",
  name AS "Name",
  tool AS "Tool",
  stability AS "Stability",
  discovered_date AS "Found",
  source_type AS "Source"
FROM "Skills/_pending-review"
WHERE status = "pending_review"
SORT discovered_date DESC
```

> No pending items? The agent hasn't found anything new yet, or you're all caught up.

---

## Recently Verified (Last 30 Days)

```dataview
TABLE WITHOUT ID
  file.link AS "Skill",
  name AS "Name",
  tool AS "Tool",
  category AS "Category",
  approved_date AS "Approved"
FROM "Skills"
WHERE status = "verified"
  AND approved_date >= date(today) - dur(30 days)
  AND !contains(file.folder, "_pending-review")
  AND !contains(file.folder, "_rejected")
SORT approved_date DESC
```

---

## Recently Rejected (Last 30 Days)

```dataview
TABLE WITHOUT ID
  file.link AS "Skill",
  name AS "Name",
  tool AS "Tool",
  discovered_date AS "Proposed"
FROM "Skills/_rejected"
WHERE discovered_date >= date(today) - dur(30 days)
SORT discovered_date DESC
```

---

## Skills by Tool

```dataview
TABLE WITHOUT ID
  tool AS "Tool",
  length(rows) AS "Total Skills",
  length(filter(rows, (r) => r.status = "verified")) AS "Verified",
  length(filter(rows, (r) => r.status = "deprecated")) AS "Deprecated"
FROM "Skills"
WHERE status != "draft"
  AND !contains(file.folder, "_pending-review")
  AND !contains(file.folder, "_rejected")
  AND file.name != "_dashboard"
  AND file.name != "_skill-template"
GROUP BY tool
SORT length(rows) DESC
```

---

## Skills by Category

```dataview
TABLE WITHOUT ID
  category AS "Category",
  length(rows) AS "Count"
FROM "Skills"
WHERE status = "verified"
GROUP BY category
SORT length(rows) DESC
```

---

## Stats

- **Total verified skills:** `$= dv.pages('"Skills"').where(p => p.status == "verified" && !p.file.folder.includes("_pending") && !p.file.folder.includes("_rejected")).length`
- **Pending review:** `$= dv.pages('"Skills/_pending-review"').where(p => p.status == "pending_review").length`
- **Rejected (all time):** `$= dv.pages('"Skills/_rejected"').length`
- **Approval rate:** Track in `_learning-changelog.md`

---

## Quick Actions

- **Review pending:** Open each note in Pending Review above, read the Evidence Pack, change status
- **Reject a skill:** Move the file to `Skills/_rejected/` and add an entry to [[_rejection-log]]
- **Request a scan:** Ask Perplexity Computer to run a changelog/MCP/community scan on demand
- **Teach a skill:** Tell Claude Desktop about a new capability → it writes to `Skills/_pending-review/`
