---
source: designs/README.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 510630411ebc26a6d9327928b4d71e5155802ea4
source_date: 2026-05-09
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: This README is the design-corpus master index (Last updated 2026-05-11). Captures the *structure* (summary table, mermaid dependency graph, milestone tables, calibration round, gantt) without transcribing the full 100+-row summary table — that's better consulted in upstream where it's kept current. Cross-cuts heavily with CLAUDE.md (which describes the metadata conventions) and with every other design in the directory (each appears as a row in the summary). The "must update the README whenever a design changes" rule from CLAUDE.md is what keeps this in sync.
---

> Abstract: The master index of the `endo-but-for-bots` design corpus on the `llm` branch (Last updated 2026-05-11). 100+ designs spanning 7 milestones (M0 through M6). The corpus has five top-level subsections: **Summary** (per-design table with status), **Roadmap** (mermaid dependency graph + 7 milestone tables + size-and-time estimates calibrated against observed PR-merge velocity), **Timeline** (gantt + per-milestone durations), and **Strategic Early Items** (designs pulled forward as foundational). The 2026-05-08 calibration round measured median actual/estimate ratios: S 0.64, M 1.20, L 1.53; the binding constraint is **review-queue latency** (median 13.9 days), not author throughput. Most recent additions (per the overview header) bridge to library-known designs: trust-on-first-bind (cap-policy adapter), retention-path-notation (PR #151 row-format unblocker), cli-http-client (PR #144 design revision), endo-gateway (lifts hosting out of Daemon), break-dev-dependency-cycles (PR #121 follow-up), exo-zip-package (PR #128 reshape blocker), filesystem-watchers, daemon-make-archive.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo-but-for-bots--llm-designs-readme--overview.md) | repository-governance, agent-conventions | current |
| [summary-shape-and-counts](../sections/endo-but-for-bots--llm-designs-readme--summary-shape-and-counts.md) | repository-governance, agent-conventions | current |
| [milestones-overview](../sections/endo-but-for-bots--llm-designs-readme--milestones-overview.md) | repository-governance | current |
| [calibration-and-estimation-methodology](../sections/endo-but-for-bots--llm-designs-readme--calibration-and-estimation-methodology.md) | repository-governance | current |
| [timeline-and-strategic-items](../sections/endo-but-for-bots--llm-designs-readme--timeline-and-strategic-items.md) | repository-governance | current |

## Cross-references

- The metadata table + status taxonomy + 7-section template the summary uses: `endo-but-for-bots--llm-designs-claude--*`.
- The "must update the README whenever a design changes" rule: `endo-but-for-bots--llm-designs-claude--progress-tracking`.
- The recently-added designs the overview enumerates: most are either already in the library (cycle 39-40) or queued in the inbox.

## Source

[designs/README.md](https://github.com/endojs/endo-but-for-bots/blob/510630411ebc26a6d9327928b4d71e5155802ea4/designs/README.md) at commit `51063041` on branch `llm`.
