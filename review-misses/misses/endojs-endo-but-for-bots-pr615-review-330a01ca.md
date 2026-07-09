---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr615-review-330a01ca
verdict: miss
category: style-convention
pr: 615
cluster: named-imports-over-namespace
cluster_pattern: A namespace/wildcard import of a Node builtin (import * as fs from 'fs') used where only one or two members are needed — Endo prefers named imports (aids reviewers, narrows ambient authority per POLA) and the node: builtin-protocol prefix; no garden seat brief, skill, or gate encodes this yet.
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/615#discussion_r3546432297
identity: endojs/endo-but-for-bots#615:review:4656996157
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr615-gauntlet
missed_by: locksmith (capability-flow lens) / stylist / purist — and a pre-push lint-style gate (absent)
severity: minor
---

# Review-miss: namespace builtin import where named imports were wanted (POLA / reviewer-aid)

On the shell-capability PR (#615), a COLLABORATOR review left an inline
`suggestion` on the new `packages/host-spawner/src/host-spawner.js`. In
paraphrase (see `comment_url` for the verbatim text): the file's
`import * as fs from 'fs'` should be a named import (the suggestion narrows it to
`import { stat } from 'node:fs/promises'`), with the standing rationale that named
imports aid reviewers and limit the ambient authority a module receives. Two
conventions are bundled: (1) prefer named imports over a wildcard/namespace
import, and (2) use the `node:` builtin-protocol prefix.

## Grounds

**Why this is a miss, not new direction.** This is the mirror image of the
already-dismissed #612 PoLA-lattice ask. #612 was *novel design content* a
maintainer contributes to a design-doc PR — no reviewer could anticipate the
specific attenuators wanted, so it was correctly dismissed as new direction.
Here the ask is the opposite: a **generic, pre-existing, mechanizable
code-hygiene convention** on an implementation file. "Prefer named imports; don't
`import *`" is deterministic (lintable), has one correct answer, carries a
principled security rationale (least authority — a module that binds the whole
`fs` namespace holds more than the single `stat` it uses), and is an established
Endo-wide house style. The reviewer's own phrasing ("please **remember** to
prefer named imports") frames it as a standing expectation, not a fresh request.
By the discriminator's test — *should the review have caught this?* — any
Endo-experienced reviewer would have; that makes it a review-miss.

**Why it is nonetheless not yet enforceable — the gap.** A grep across every
juror seat brief and every skill for `named import` / `import *` / `namespace
import` / `ambient authority` returns nothing: the garden's review apparatus has
**no encoded rule** for this. The nearest conceptual lens is the **locksmith**
seat (capability flow — "who receives a capability, what does each attenuator
narrow"); a module receiving the entire `fs` namespace when it needs only `stat`
is squarely that lens, but the locksmith brief is written for *delivered exo/vat
attenuators* (proxy traps, property descriptors, grants crossing a boundary), not
for narrowing Node-builtin import specifiers, and it did not fire. The `stylist`
and `purist` seats likewise carry nothing on import shape. So this is an
**encode-the-rule-first** situation, not a sense-and-correct failure: there was
no written check to bind.

**Panel history.** The #615 gauntlet (`tada/endojs-endo-but-for-bots-pr615-gauntlet.md`)
ran the full 26-seat code panel over exactly this diff — including
`host-spawner.js`, which the gauntlet's own delta edited — and posted a formal
COMMENTED review; the wildcard import was not among its findings. The primary
loop (`endojs-endo-but-for-bots-pr615-review-330a01ca`, UNCHANGED) is addressing
the suggestion itself. This retro judges only whether the apparatus should have
anticipated it, and concludes it should have but had no encoded surface to do so.

**Severity: minor.** `import * as fs` + `fs.stat` is import hygiene, not an actual
capability leak — the `fs` namespace is a static module binding, not a runtime
capability distributed to an untrusted party, so no side-channel is opened. The
value is reviewer-legibility and POLA discipline, not a closed hole.
