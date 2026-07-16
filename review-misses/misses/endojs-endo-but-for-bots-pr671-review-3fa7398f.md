---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr671-review-3fa7398f
verdict: miss
category: naming
pr: 671
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/671#discussion_r3575900598
identity: endojs/endo-but-for-bots#671:review:4690597350:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr671-endo-registry-capability
missed_by: stylist
severity: minor
cluster: avoid-name-abbreviations
cluster_pattern: An abbreviated identifier in freshly-authored code (dir, Arg, subDir, Temp, Cmd, Impl) that a panelled PR let through — the maintainer repeatedly asks names be spelled out in full.
---

# Miss: abbreviated identifier `fetchImpl` in panelled new code on #671

kriskowal's CHANGES_REQUESTED review on #671 (review `4690597350`,
`feat(daemon): EndoRegistry capability and required @registry host name`) carried a
design directive plus four inline nits. This record concerns **one** inline
(`discussion_r3575900598`, on `packages/daemon/src/registry-node-backend.js` at the
`requireFetch = fetchImpl => {…}` parameter): the maintainer's terse ask is
paraphrased here as *"spell this abbreviation out"* — `fetchImpl` / `impl` should be
`fetchImplementation` / `implementation`. Verbatim untrusted text at `comment_url`.
(The review's other asks — a Node-power-injection module split, a `fetch`
dependency-injection, and a `%2f` scope-slash simplification — are design/DI
directions handled by the primary loop and its `pr671-fix-registry-power-injection`
fixer; they are not naming misses and are not recorded here.)

## Grounds (miss — a recurrence of a closed, deployed improvement)

This is a **fourth panelled abbreviation miss**, and the first one to land *after*
the `avoid-name-abbreviations` improvement was already deployed to the fleet — which
makes it a genuine recurrence, not a fresh gap:

- **Garden-authored, freshly written code.** `fetchImpl` is a parameter the
  registry-capability build authored in this PR's diff
  (`registry-node-backend.js`, a wholly new file), not inherited legacy.
- **`impl` is on the deployed gate's own blocklist.** The
  `spell-out-identifiers.sh` pre-push gate that closed this cluster carries
  `impl:implementation`; run against the `fetchImpl` line it prints
  `fail: … abbreviated identifier `fetchImpl` (`impl` -> spell out …)`. The rule
  the improvement encoded covers this exact identifier.
- **The improvement was live in the fleet at review time.** The gate + the
  `stylist` never-abbreviate brief landed on main2 at `aa2da527e5` (2026-07-11
  02:04Z) and were **deployed to this PR's host** (`endolin-garden2-5bcdff64`) at
  02:11Z. The gauntlet's 19-seat panel review submitted at 2026-07-11 14:42Z —
  ~12.5h later — so it ran with the never-abbreviate stylist check in force, yet
  still let `fetchImpl` through to the maintainer.
- **A plain, unambiguous abbreviation.** `Impl` for `Implementation` carries no
  domain-vocabulary ambiguity; it is the same spell-it-out preference the cluster's
  three prior members (`dir`/`Temp` #650 ×2, `Cmd` #609) established as consistent
  and long-standing.

Genuine review miss, category `naming`, joining `avoid-name-abbreviations`.

## Why the deployed improvement did not catch it (the recurrence's real cause)

Two sensing surfaces existed and both let it pass, for distinct reasons:

1. **The deterministic gate has an added-lines-only blind spot.** `fetchImpl` was
   introduced in the PR's original `feat(daemon)` commit at 2026-07-10 22:59Z —
   ~3h *before* the gate existed anywhere. The `spell-out-identifiers.sh` gate scans
   only the **newly-added diff lines** of the push in front of it. On every push
   after the line entered the branch (including the 2026-07-11 14:39Z fixer head
   `d863566953`), `fetchImpl` is an unchanged pre-existing line, never in an
   added-line diff again — so the gate, though deployed and though `impl` is on its
   blocklist, structurally never scanned it. Any abbreviation that entered a branch
   before the gate's deployment (or before the branch's first gated push) sails
   through the deterministic net permanently.
2. **The stylist seat is the only backstop for pre-existing lines, and it is
   probabilistic.** The panel read the whole new file (so `fetchImpl` was in scope)
   with the never-abbreviate brief deployed, but the LLM seat missed this one
   identifier. The gate was meant to be the deterministic backstop; its
   added-lines-only design left the stylist seat as the sole net for this line, and
   it did not fire.

## Threshold / recurrence call recorded at this record's tail

The cluster `avoid-name-abbreviations` was `closed` (improvement-dispatched and
closed by `main2 aa2da527e5`: the `spell-out-identifiers.sh` tier-1 gate + stylist
never-abbreviate brief + builder/fixer directives). Recording this miss **reopens**
it (`recurrence=1`). Per `skills/review-retrospective` § 6 a recurrence is escalated
to the maintainer and a second improvement round does **not** proceed on autopilot —
because the right next move is a judgment call the maintainer should own: whether to
widen the gate to re-scan whole changed files / whole new files (catching
pre-existing and pre-deployment abbreviations at the cost of more false positives),
accept the LLM stylist seat as the only net for pre-existing lines, or treat this
single pre-deployment straggler as expected fallout that needs no gate change. The
gate is not broken for the lines it is designed to see; the recurrence exposes a
scope boundary, not a defect. Escalating rather than dispatching.
