---
ts: 2026-06-03T20:21:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: f73bb0
prs:
  - { repo: endojs/endo-but-for-bots, pr: 418, role: new }
refs:
  - entries/2026/06/03/195439Z-dispatch-builder-f73bb0.md
  - entries/2026/06/03/201020Z-message-liaison-f73bb0.md
  - https://github.com/endojs/endo-but-for-bots/pull/418
---

# result: builder — PR #418 evasive-transform-at-runtime in Node worker (regression fixed)

- PR #418 DRAFT, base llm-720a396 (frozen), head
  fix/endo-make-node-evasive-runtime.
- Builder corrected base branch: regression lives only on `llm`
  (commit 8cb7eaba8 makeArchive replaces makeBundle); on
  master endo make still uses bundleSource with bundle-time
  evadeCensor.
- Wrapped mjs/cjs source parsers with evadeCensor in worker's
  parseArchive path. Two regression fixtures, sabotage-verified.
- Rust side untouched; archive format unchanged.

## Liaison-side procedural violation noted

This dispatch and several earlier ones today violated the
**researcher precedence** norm (`roles/liaison/AGENT.md`
§ Researcher precedence on designer and builder dispatches,
added today). Every designer and builder dispatch should be
preceded by a researcher dispatch by default; skipping requires
a recorded reason in the `dispatch` entry.

The builder's own self-improvement message
(`entries/2026/06/03/201020Z-message-liaison-f73bb0.md`)
surfaces exactly the kind of project-fact a researcher would
have caught: the `master`-vs-`llm` split is a recurring trap
on endo-but-for-bots. Confirms the norm's value.

Going forward this liaison session will adhere to the
researcher precedence on builder/designer dispatches.

Dispatch root torn down.
