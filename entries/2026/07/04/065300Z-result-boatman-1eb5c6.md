---
ts: 2026-07-04T06:53:00Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs: []
---

First-time ferry of `endojs/endo-but-for-bots#589` ("refactor: retire
function-keyword in favor of arrow/method syntax (reconstruct #474 on current
master)", OPEN) to a new upstream PR. Direct in-session liaison-cast-as-boatman
engagement (no dispatch entry); the maintainer authorized the identity switch
with the verb "ferry".

- **Upstream PR**: https://github.com/endojs/endo/pull/3318 (DRAFT).
- **Branch / head**: `kriskowal-retire-function-keyword` @ `b25a1b6e2`.
- **Base**: upstream `master`, live tip `71cbdb989` (verified via `git ls-remote`; the bare clone's `origin/master` was stale at `a0f5d95ac` and refreshed by fetch before detaching).
- **Source**: `endo-but-for-bots#589` head `a97452bb2`, frozen base `master-0594e99` (`0594e99fb`). 19 commits, base is ancestor of head.

Shape 1 (first-time), single-author. Cherry-picked the 19-commit range onto
current master with **zero conflicts**, then rewrote author + committer on all
19 to **Kris Kowal <kris@agoric.com>** via `git filter-branch` (interactive
rebase is unavailable in this harness). The same pass stripped the one
fork-side reference: the house-style commit body's trailing sentence
"Reconstructs the doc from endojs/endo-but-for-bots#474." (`#474` is garden-side
with no upstream equivalent).

Verification:
- **Attribution**: all 19 commits author == committer == `Kris Kowal <kris@agoric.com>`.
- **Trailers**: `interpret-trailers --parse` empty on every commit; no Co-Authored-By / Generated-with / claude / anthropic anywhere.
- **Net change**: 55 files, +858/-526 against current master (source PR reported 55 files, +865/-533 against its frozen base; the small line-count delta is master drift between `0594e99` and `71cbdb98`, file count identical).
- **CI**: full upstream matrix registered and PENDING at ferry time (test / test262 / xs / hermes / ocapn / lint / cover). Source #589 CI was fully green on the same content. Boatman does not wait; shepherd owns CI follow-up.
- **Mergeable**: not yet computed at ferry time.

Draft rationale: source #589 CI is green but carries **no approval review**, so
the ready-for-review bar (clean CI *and* substantive source approval) is not
met. Opened DRAFT; can flip to ready once upstream CI is green or on maintainer
direction.

Cross-link: garden-side mirror comment on `endo-but-for-bots#589`
(`Mirror of https://github.com/endojs/endo/pull/3318 (head b25a1b6e2).`),
comment id **4881048574**. No prior `Mirror of ` comment existed. No
upstream-side comment (per the 2026-05-29 directive). Posted under the
authenticated `kriskowal` identity (endo-but-for-bots is the garden, not a
primary).

Attribution-email note: the `human` input was unspecified in the request; the
maintainer was away when asked. Chose `kris@agoric.com` (plurality on the last
15 real kriskowal commits on `endojs/endo`, 9 of 15) over `kriskowal@kriskowal.com`
(the other live value). A re-ferry with recompute (Shape 2) is cheap if the
maintainer prefers the latter.

Self-improvement: `skills/pr-handoff/SKILL.md` documents the ferry human
identity as `Kris Kowal <kris@cixar.com>`, but that email appears in **zero**
recent ferries or upstream commits; the two live values are `kris@agoric.com`
and `kriskowal@kriskowal.com`. Routed as a `message`-to-`liaison` to correct the
skill's stale convention line.
