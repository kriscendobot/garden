---
slot: 1
status: in-flight
design_path: designs/familiar-run-apps-vfs.md
pr_number: 241
current_stage: fixer
in_flight_dispatch: b8e551
last_update: 2026-05-15T02:21:00Z
started_at: 2026-05-15T02:11:00Z
host: endolinbot
---

Slot 1 advancing from judge to fixer. Judge `60d499` returned at 02:18Z
with a design-panel verdict of `--comment` (self-authored fallback) and
three in-scope must-fix items plus fifteen should-fix items. PR remains
draft; un-draft authority withheld pending a terminating panel round.

Must-fix items (full body on PR #241 as review `PRR_kwDORRE4FM7__WW7`):

1. `## Purpose` paragraph 1 restructure (split 165-word run-on; move
   sub-case detail into `## Case 1`).
2. Introduce load-bearing terms (`endor`, `XS worker`, `cap-std`,
   `formula`, `Lal caplet`) in Glossary / Vocabulary before first use.
3. Resolve no-lockfile-determinism contradiction.

Next-stage-owed: fixer to address the must-fix and should-fix items in
one revision pass. After the fixer's commits land, a re-convened design
panel verifies; on a terminating round the judge runs `gh pr ready 241`.

Dispatch root: `dispatches/fixer--b8e551`.
