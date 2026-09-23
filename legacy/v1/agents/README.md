---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Agent archive

Termination reports for long-living subagents. One file per terminated agent, with a structured frontmatter summary and the agent's final report verbatim. When the raw Claude Code JSONL transcript can be located, it is copied alongside under `transcripts/`.

The schema and writing procedure live in `skills/agent-termination/SKILL.md` on the `main` branch.

## Layout

```
agents/
  README.md                                  (this file)
  <YYYY-MM-DD>-<role>-<short-id>.md          per-agent termination report
  transcripts/
    agent-<session-id>.jsonl                 raw subagent transcript (best-effort)
```

The date in the report filename is the termination date in UTC. Filenames sort chronologically; the role tag in the middle gives a clean per-role glob.

## Browse and consult

Three index views by convention:

- **By date**: `ls *.md` sorts chronologically.
- **By role**: `ls *-monitor-*.md`, `ls *-boatman-*.md`, etc.
- **By subject matter or project**: `grep -l 'ses-intrinsics' *.md`, `grep -l '^project: endo' *.md`.

The frontmatter `subject_matter:` list and `project:` slug are the canonical tagging surfaces. Report authors should pick conservative tags that match how a future agent would search; the agent-termination skill's procedure section has the conventions.

When a future agent (or the user) asks "btw, what did the prior X agent conclude about Y?":

1. Find candidate reports via the browse recipes above.
2. Read the most relevant report. The body answers most questions directly.
3. If the report leaves the question unanswered, dispatch a fresh agent with the report (and optionally the JSONL transcript path) as context.

Direct replay of a past subagent's JSONL into a new agent's context is **not** supported by Claude Code today. The structured report is the canonical consultation medium; the JSONL is defensive storage in case replay tooling lands later or in case the report leaves a question unanswered.

## When to write a termination report

Long-living subagents (running across more than one steward cycle, or working a substantial bounded engagement) get a report. Trivial one-shot dispatches (a single monitor tick, a quick query) do not; their journal `result` entry is enough. The dispatcher (liaison or steward) writes the report when the subagent terminates.

## Current archive

(no terminated agents yet; this section is hand-maintained when worth tabulating, or the directory listing is the index)
