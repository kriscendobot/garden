---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:43:07Z
---
role: prosecutor
project: endo
repo: endojs/endo-but-for-bots

Review-retrospective (second loop) on endojs/endo-but-for-bots PR #475,
directive identity `endojs/endo-but-for-bots#475:review:4998441893`
(erights, inline review comment on `packages/immutable-arraybuffer/src/lib.js`).

Verdict: **not-a-miss (new-direction)**. erights requested a novel cross-package
commutativity test -- proving that immutable-arraybuffer's wrapping of
`DataView.prototype.setFloat*` commutes with the ses-shim's independent wrapping
of the same methods for the NaN side-channel repair -- to be placed in `@endo/ses`
and run on XS. The requirement rests on domain knowledge held by the NaN-repair
author (that a separate package wraps the identical methods and the two must
compose), first stated in the comment; no juror seat, skill, gate, or standing
instruction encodes "demand a cross-package commutativity test when a diff
touches a method another shim also wraps." The gauntlet did run on #475
(`jobs/tada/endojs-endo-but-for-bots-pr475-gauntlet-20260819.md`), so this is not
an avoidance/process gap.

Grounded in the world, not the primary report: confirmed the primary loop's
deliverable exists -- real commit `313e0ba42b` ("test(ses): cover DataView
wrapper commutativity (#475)", 8 files) added both-order tests in `@endo/ses`
plus XS generation. No false-peer no-op.

Recorded via review-miss-record.sh:
`review-misses/dismissed/endojs-endo-but-for-bots-pr475-review-90ef14d6.md`. A
dismissal mints no cluster; no threshold evaluation, no improvement job.

Self-improvement: nothing this time.
