Both records are on `origin/journal2`; inbox is empty. The job is complete — this was a record-and-hold retro, so no `main2` changes were warranted.

## Completion report — prosecutor retro on endojs/endo-but-for-bots #615

**Idempotency:** No pre-existing `misses/` or `dismissed/` record for the primary base — a fresh judgment, not a no-op.

**The comment (untrusted → paraphrased):** A COLLABORATOR (`0xpatrickdev`) `suggestion` on the new `packages/host-spawner/src/host-spawner.js` — change `import * as fs from 'fs'` to a named import (`import { stat } from 'node:fs/promises'`), because named imports aid reviewers and limit ambient authority.

**Verdict — MISS** (`style-convention`, minor). Distinguished from the already-dismissed #612 PoLA-lattice ask: #612 was novel design content nobody could anticipate; this is a generic, mechanizable, one-correct-answer code-hygiene convention with a POLA rationale that any Endo-experienced reviewer would anticipate (the reviewer even frames it as "please *remember*"). Grounded in the actual #615 history: the gauntlet's 26-seat panel reviewed this exact file and didn't flag it, and a grep across every seat brief/skill for named-import/ambient-authority conventions is empty — a genuine unencoded gap (the locksmith's capability-flow lens is the nearest, but it's written for delivered exo attenuators, not Node-builtin import specifiers).

**Recorded:** `review-misses/misses/endojs-endo-but-for-bots-pr615-review-330a01ca.md`; minted cluster `named-imports-over-namespace` (count=1, prs={615}, status=open, recurrence=0).

**Threshold — HOLD, no dispatch.** Below the K≥3-across-≥2-PRs floor; severity bypass inapplicable (severity minor, and no standing garden rule pre-existed to fail-to-bind — this is an encode-the-rule-first gap, not a sense-and-correct failure). No `review-improve-*` builder job posted; cluster stays open to accumulate. No recurrence → no maintainer escalation. Rationale captured in the miss grounds and the `result` entry.

**Artifacts:** miss + cluster on `origin/journal2`; `result` entry `entries/2026/07/09/192928Z-result-prosecutor-a7d9f3.md`. Inbox drained (empty).

**Follow-up (latent):** if named-import / `node:`-prefix feedback recurs on a second PR, the floor trips and the natural improvement is a deterministic pre-push lint-style gate (both halves mechanizable) plus a stylist/locksmith seat-brief line.

Self-improvement: nothing this time.
