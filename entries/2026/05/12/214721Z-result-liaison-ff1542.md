---
ts: 2026-05-12T21:47:21Z
kind: result
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/12/214455Z-result-liaison-f69ca6.md
---

Recorded the no-PR-for-the-garden posture as a standing convention.
Committed on main as `f043442` and pushed.

Where it landed:
- `CLAUDE.md` § Conventions: the canonical statement, with the GitHub
  "create PR for journal" UI quirk explicitly called out as something to
  ignore.
- `roles/liaison/AGENT.md`: the existing "Meta work goes on `main`" norm
  expanded to "Meta work goes on `main`, no PR" and now references the
  Conventions section.
- `roles/steward/AGENT.md`: a one-line note added to its may-write list
  for journal entries, since the steward's only garden writes are the
  journal and those also go direct.

Mirrors the analogous rule in the reference garden's
`references/endo-but-for-bots/roles/liaison.md` § Output (direct push to
`bots/garden`, no PR), with our own repo and our own journal-orphan
shape rather than their `process/` model. The "generally" wording leaves
room for the rare case where a PR makes sense (e.g., review of a large
structural change before landing); default is direct push.

Self-improvement: nothing this time. The user gave a single rule; it
landed in the canonical home (CLAUDE.md) and was cross-referenced from
the two places that needed it. No process or pitfall worth a Note from
the field surfaced during the change.
