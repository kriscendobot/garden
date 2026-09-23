---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-09T19:29:30Z
---
# result: review-retrospective on endojs/endo-but-for-bots #615 (prosecutor)

**Job:** `endojs-endo-but-for-bots-pr615-review-330a01ca-retro`
**Retro identity:** `endojs/endo-but-for-bots#615:review:4656996157:retro`
**Primary (unchanged):** `endojs-endo-but-for-bots-pr615-review-330a01ca`
**Surface:** pr-review-comment (`suggestion`) by 0xpatrickdev (COLLABORATOR),
`discussion_r3546432297`, on new file `packages/host-spawner/src/host-spawner.js`.

## Verdict — MISS (`style-convention`, minor)

Paraphrased ask: the file's `import * as fs from 'fs'` should be a named import
(suggested `import { stat } from 'node:fs/promises'`), because named imports aid
reviewers and limit the ambient authority a module holds. Two bundled
conventions: prefer named over wildcard/namespace imports, and use the `node:`
builtin-protocol prefix.

Judged a **review-miss**, not new direction. It is the mirror image of the
already-dismissed #612 PoLA-lattice ask: #612 was novel design content nobody
could anticipate; this is a generic, pre-existing, *mechanizable* code-hygiene
convention on an implementation file, with one correct answer and a principled
POLA rationale. The reviewer frames it as standing ("please *remember*"). Any
Endo-experienced reviewer would anticipate it → the review should have caught it.

But it is **not encoded anywhere** in the garden's review apparatus: a grep over
every juror seat brief and skill for `named import` / `import *` / `namespace
import` / `ambient authority` is empty. The nearest lens is the **locksmith**
(capability flow), but that brief is written for delivered exo/vat attenuators,
not Node-builtin import specifiers, and did not fire. The #615 gauntlet
(`tada/endojs-endo-but-for-bots-pr615-gauntlet.md`) ran the full 26-seat panel
over exactly this diff — including `host-spawner.js` — and did not flag it.

## Cluster & threshold — HOLD, no dispatch

Recorded via `review-miss-record.sh record`:
`review-misses/misses/endojs-endo-but-for-bots-pr615-review-330a01ca.md`.
Minted cluster **`named-imports-over-namespace`** (count=1, prs={615},
status=open, recurrence=0).

Threshold **not met → HOLD.** Floor is K≥3 misses across ≥2 distinct PRs; this is
one miss on one PR. The severity bypass cannot apply: it fires only for a
`major` miss whose grounds cite a *standing rule that already existed and did not
bind* — here no garden rule pre-existed (this is an encode-the-rule-first gap,
not a sense-and-correct failure), and severity is minor (import hygiene, not a
capability leak: `fs.stat` via a namespace binding opens no side-channel). No
`review-improve-*` builder job dispatched; the cluster stays open to accumulate.
If named-import / `node:`-prefix feedback recurs on a second PR, the floor trips
and the improvement job's natural shape is a deterministic pre-push lint-style
gate (both halves mechanizable) plus a stylist/locksmith seat-brief line.

No recurrence (fresh cluster), so no maintainer escalation.

Self-improvement: nothing this time.
