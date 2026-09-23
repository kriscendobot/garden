---
ts: 2026-05-14T21:09:21Z
kind: result
role: gardener
project: garden
to: "*"
refs:
  - entries/2026/05/14/210534Z-dispatch-liaison-4b04a5.md
---

# Result: gardener encodes "the gamut" vocabulary

Dispatch root: `dispatches/gardener--4b04a5/`. Garden-meta only.

## Files revised

Three commits on `main` at `origin/main` HEAD `3339a2d`:

- `roles/steward/AGENT.md` — added *Vocabulary: the gamut* section before *PR-creation-flow scan*. The steward's per-cycle scan IS the gamut in autonomous form; an inbox "run the gamut on PR #N" rate-limits the scan onto that PR until un-draft.
- `roles/liaison/AGENT.md` — added *Vocabulary: the gamut* section before *Operating norms*. "Run the gamut on #N" in a user prompt means dispatch the next-owed stage, await its result, dispatch the subsequent stage, iterate until the judge un-drafts; one engagement, not across cycles.
- `skills/pr-creation-flow/SKILL.md` — added *Vocabulary: "the gamut"* subsection near the top introducing the synonym (procedure unchanged); appended a notes-from-the-field row dated 2026-05-14 with the maintainer directive verbatim as precipitating evidence.
- `CLAUDE.md` — added an *Orchestrator vocabulary* subsection under *Dispatch contract* with the one-line glossary entry for "the gamut" and "run the gamut on #N", cross-linking the two role files.

## Carve-outs encoded in all four files

The gamut does **not** mean:

- Bypass the chain's discipline (cleaner still runs before the jury except on tiny-PR / design-only variants; judge still runs the panel; fixer-loop still iterates until in-scope must-fix is clear).
- Skip maintainer review (the gamut terminates at the judge's un-draft).
- Auto-merge (the conductor is a separate role; the gamut stops at ready-for-review).

## Commit map

- `f034aa6` steward: 'the gamut' vocabulary
- `11e7e09` liaison: 'the gamut' vocabulary
- `3339a2d` pr-creation-flow + CLAUDE.md: 'the gamut' as maintainer-supplied synonym

One commit per substantively-revised role file (steward, liaison), one combined commit for skill + CLAUDE.md, per the dispatch's commit shape. Pushed to `origin/main`.

Self-improvement: nothing this time. The dispatch was a vocabulary-encoding pass; the carve-outs and per-role placement followed the dispatch brief directly with no observed structural drift between current rules and what landed.
