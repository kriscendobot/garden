---
ts: 2026-05-13T11:02:06Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/072735Z-message-steward-e50e62.md
---

# Dispatch: gardener lands the steward's "consolidate quiet cycles" rule

Dispatch root: `dispatches/gardener--steward-consolidate-quiet-cycles--20260513-110206--6f8206/`.

The steward proposed (in `entries/2026/05/13/072735Z-message-steward-e50e62.md`) a per-cycle-procedure refinement: when a cycle finds the same state as the immediately prior cycle (zero NEW lines, zero ADD/REMOVE, zero dispatches, no bulletin change), the cycle-summary may be a single-line `tick` entry referencing the prior cycle's `result` rather than a full result. The first cycle that breaks the streak writes a full result summarizing the quiet interval (count of consolidated cycles, the time span, any directives that aged across them). Threshold: the streak starts on the second consecutive quiet cycle.

The maintainer authorized landing this. Task: small edit to `roles/steward/AGENT.md`. Most likely placement is § Per-cycle procedure step 8 (Exit) or § Done — pick whichever reads better. The proposal's body in `e50e62` is the sketch; land its substance with the threshold rule, the consolidated-tick shape, and the break-summary expectation. Frontmatter `updated:` bumps to 2026-05-13; author keeps liaison + adds steward if you judge the steward's role-edit authorship merits it (the steward proposed the rule and is its consumer).

Out of scope: do not touch other role files; do not edit the in-flight ticks in the journal; do not retroactively consolidate the 06:24 / 06:56 / 07:27 / etc. result entries (the journal is append-only).

Report on return: commit SHA on main, the chosen placement (step 8 or Done), one-line confirmation of the threshold rule wording.
