---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T08:00:36Z
---
---
project: endo
repo: endojs/endo-but-for-bots
---

# Gauntlet backfill panel on https://github.com/endojs/endo-but-for-bots/pull/779

PR https://github.com/endojs/endo-but-for-bots/pull/779 was opened non-draft on
2026-07-17 with zero reviews of any kind and never went through the scripted panel.
Live state verified before acting: OPEN, non-draft, MERGEABLE/CLEAN, 0 reviews,
0 comments, a single commit `55330da29b` on the frozen base `master-46d4edf`
(`46d4edf317`), and all 15 CI checks green.

Ran a panel review pass against that head. Disposition: MUST-FIX, 9 of 10 seats
request-changes.

The headline finding, which I confirmed independently by running both revisions
before the seats reported and which 7 of the 10 seats then reproduced on their own:
the PR regresses module-namespace enumeration order from spec-required sorted order
to declaration order. Three new eager `defineProperty(exportsTarget, ...)` calls in
`packages/ses/src/module-instance.js` create the own properties before the
pre-existing sorted late pass runs, and `defineProperty` on an existing property does
not reorder it, so the sorted pass became a no-op for ordering.
`module-proxy.js`'s `ownKeys` trap forwards `ownKeys(exportsTarget)` verbatim, so the
insertion order is directly observable. The three new code comments assert the
opposite of what the code does. Observed with a four-export module and no cycle at
all: head gives `["zeta","alpha","mu","beta"]`, base gives `["alpha","beta","mu","zeta"]`,
and Node native ESM agrees with the base. Every SES module namespace is affected, not
only the cyclic star-export case the PR targets.

Two further must-fix classes: a genuinely-absent re-export (`export { nope } from 'm'`)
now becomes a phantom export whose getter throws ReferenceError forever instead of the
spec-required link-time SyntaxError; and the changeset omits `@endo/module-source`
despite a runtime change to its emitted functor.

Nothing in `packages/ses/test/` asserts namespace key ordering and the test262 job's
SES surface does not cover it, which is how a spec regression reached a non-draft,
CI-green PR with 15 passing checks. Greenness was not evidence here.

Routed per the normal chain: fixer job `endojs-endo-but-for-bots-pr779-fix-namespace-order`
posted with the ordering regression and its reproduction, and the full panel aggregate
sent to that job's inbox. No PR comment was posted; the fixer owns the PR-side summary.

Scope limit, stated plainly: this was a REDUCED 10-seat panel, not the full 28-seat code
panel. `panel.sh` fans its seats sequentially and the first seat alone ran over three
minutes, so the full panel cannot fit the default 2400s gardener handler budget. Job
`endojs-endo-but-for-bots-pr779-panel-remaining-seats` carries the remaining 18 seats with
a `handler-timeout: 10800` stamp.

Self-improvement: two structural lessons routed to the liaison in a separate message
(panel.sh's sequential fan-out versus the handler budget; /tmp being noexec on this host).
