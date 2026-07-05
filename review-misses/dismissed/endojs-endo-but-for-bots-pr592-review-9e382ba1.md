---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr592-review-9e382ba1
verdict: not-a-miss
category: new-direction
pr: 592
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/592#pullrequestreview-4631951294
identity: endojs/endo-but-for-bots#592:review:4631951294:retro
producing_role: builder
producing_job: factor-watchdirectory-to-endo-platform
severity: minor
grounds: >
  kriskowal's third CHANGES_REQUESTED review on PR #592 (review 4631951294,
  garden-authored: the builder job factor-watchdirectory-to-endo-platform
  factored the watchDirectory primitive out of @endo/daemon into @endo/platform)
  had an empty body and carried a single inline comment on
  packages/platform/src/fs-node/watch-directory.js (paraphrased): add a test
  covering two SEPARATE instances so they must communicate through the
  underlying platform's notification system, and mark that test conditionally
  `failing` for the test:xs case because Rust's cap-std is incomplete. This
  retro judges whether the garden REVIEW PROCESS should have anticipated the ask
  and concludes it could not have, on four grounds drawn from the PR's actual
  history. (a) SAME PR, SAME direction already dismissed: review 4629031768
  (dismissal da7fef5e) on this very PR already asked broadly for "adequate tests
  covering watchDirectory under all platforms including test:xs and test:go" and
  was recorded as new-direction; review 4631951294 is the maintainer REFINING
  that same first-stated test-coverage ask into a concrete spec (cross-instance
  delivery through the platform notifier, plus an XS test.failing marker), not a
  newly surfaced defect. (b) The requested coverage NEVER EXISTED: the PR is a
  faithful refactor that moved makeWatchDirectory and its pre-existing node unit
  tests verbatim, but the sibling coverage exercises only the initial snapshot,
  which never fires the watcher — the maintainer is asking to EXPAND coverage to
  a scenario (two instances observing each other purely via fs.watch, and the
  XS/cap-std graceful-degradation counterpart) that the original #277 code
  lacked too. Scope expansion first stated in the comment, not a violated
  standing bar or lost coverage. (c) NO encoded review element knows this and
  failed to bind: the prior retro's grep across every juror seat brief and every
  skill for test:xs / test:go / cross-platform / platform-parity returned
  nothing, and the adjacent node-parity-test skill is Node-vs-SES linker parity,
  not the daemon supervisor matrix; the specific ask here — "prove the watcher
  actually delivers a peer instance's write through the platform notifier, and
  pin the XS case failing because cap-std has no capability-safe directory-watch
  primitive" — is rooted in the maintainer's own domain knowledge of cap-std's
  capability surface, which no corner-prober / fast-checker / prover lens
  encodes. (d) NO panel/gauntlet ran on #592 — the builder correctly left the PR
  DRAFT and flagged it ready for the gamut; the maintainer is reviewing the draft
  first and steering it, which is normal early direction, not a skipped-panel
  process miss. The primary loop (review-9e382ba1) already handled it correctly:
  it added a live cross-instance delivery test and a pinned XS test.failing
  counterpart (commit ce2cf14bc) and replied on the thread with a top-level
  summary. This is maintainer direction refining the cross-platform test bar on a
  faithful refactor, on the same PR, with a first-stated requirement grounded in
  cap-std knowledge — new direction, not a garden review-process miss. Recorded
  as a durable dismissal so the same review is never re-litigated. GUARDRAIL
  OBSERVED: PR #592 has now drawn three related test-coverage / cap-std asks, but
  all from ONE PR; the floor is >= 2 distinct PRs, and da7fef5e explicitly
  reserved miss-recording for a SECOND garden-authored PR later drawing the same
  "cover all platforms" ask on a daemon primitive. Minting a
  daemon-cross-platform-coverage cluster off this single refactor PR would be the
  one-PR-masquerading-as-systemic pitfall. No cluster minted; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #592 review 4631951294 (retro)

kriskowal's third review on the watchDirectory-into-@endo/platform refactor
carried one inline comment asking for a test that proves two separate instances
observe each other's directory changes purely through the platform's underlying
notification system, and to mark that test `failing` for the test:xs case because
Rust's cap-std lacks a capability-safe directory-watch primitive. Not a garden
review-process miss: it is the same maintainer refining, on the same PR, the same
first-stated cross-platform test-coverage direction already dismissed as
new-direction in da7fef5e (review 4629031768). The PR is a faithful refactor that
moved its pre-existing node tests verbatim; the requested cross-instance /
XS-degradation coverage never existed and is scope expansion rooted in the
maintainer's own knowledge of cap-std's capability surface — no juror seat, skill,
or standing instruction encodes a cross-instance-notification-coverage convention
(the prior retro's grep for test:xs / test:go / cross-platform / platform-parity
is empty; node-parity-test is Node-vs-SES linker parity, not the daemon supervisor
matrix), and no panel ran because the builder correctly left the PR DRAFT and
flagged the gamut. The primary loop already added the live cross-instance test and
the pinned XS test.failing counterpart (ce2cf14bc) and replied on the thread. All
three of #592's test-coverage asks come from one PR, so the >= 2-PR floor is not
met and no cluster is minted. New direction, not a miss. See comment_url for the
verbatim review.
