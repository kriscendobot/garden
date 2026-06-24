---
ts: 2026-05-12T20:41:31Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/203640Z-result-liaison-fa2407.md
  - entries/2026/05/12/191816Z-message-liaison-e93eb3.md
---

First adoption from `references/`. Pulled the self-improvement discipline
out of `references/endo-but-for-bots/skills/self-improvement.md` and into
our active library at `skills/self-improvement/SKILL.md`. Committed as
`8dca255`.

What changed:

- New skill file with the six "what to look for" cases, the threshold rules,
  the "nothing this time" meta-signal, the pitfalls list, plus our extension:
  routing structural lessons via journal `message` to liaison, routing
  one-off facts via `project:`-tagged journal entries.
- `roles/COMMON.md` § Improving your role and skills shrank to a 3-line
  pointer to the skill (matches the pattern COMMON.md already uses for
  journal-sync). The Reporting section gained a one-line note about the
  `Self-improvement: ...` output. The "message to coordinator" phrasing was
  corrected to "message to liaison" — drift fix from the period before
  liaison was established as our top-level vocabulary.
- `CLAUDE.md` inventory updated.

What was deliberately *not* carried over from the source:

- Em-dash style rule and relative-paths rule. Both are endo-internal style
  conventions that should not generalize to our garden until/unless we
  decide to adopt them.
- "Update `roles/README.md`" — we have no roles/README.md; CLAUDE.md's
  inventory section serves the same purpose.

Validates the staging-shelf workflow: the `references/` material was
brought across deliberately, with translation of paths and routing, in a
single review-able commit. Took ~10 minutes including the journal entry.
The shelf is paying for itself on the first adoption.

Self-improvement: skills/self-improvement/SKILL.md, roles/COMMON.md,
CLAUDE.md; first reference adoption replaces a less-developed standing
instruction with the version proven in the source garden.
