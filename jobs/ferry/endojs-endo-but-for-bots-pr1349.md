---
downstream: endojs/endo-but-for-bots#1349
downstream_branch: build/hardened-text-codecs-shim
downstream_base: master-ebc7904
downstream_head: 2262b4bafa9f06177b311869b91c71d4fcd2ac96
upstream: endojs/endo
upstream_base: master
upstream_base_sha: ebc7904d87b130922a6ead072075420d507843e4
upstream_pr:
human: Kris Kowal <kris@agoric.com>
identity_switch_authorized: true
convention:
---
Ferry endojs/endo-but-for-bots#1349 ("fix(ses): encapsulate TextEncoder and
TextDecoder behind SES-owned constructors") upstream to endojs/endo (base
master).

The PR was re-woven on 2026-10-27 (job
`endojs-endo-but-for-bots-pr1349-weave-20261027`) onto the frozen snapshot
`master-ebc7904`, which equals upstream `endojs/endo` `master` at
`ebc7904d87b130922a6ead072075420d507843e4`. The woven head is
`b122ff91ef98ac3e151852b58d2cb1110060fb26` (46 commits ahead of
`master-ebc7904`, 0 behind; only this PR's files). It is master-shaped. Weave
summary: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453887493

The PR was then retconned on 2026-10-28 (job `retcon-endo-pr1349-20261028`).
The retcon autosquashed the `fixup!` commits and split the workflow edits out of
this PR into endojs/endo-but-for-bots#1582
(`ci/browser-tests-any-base-ubuntu-24.04`, base `master-ebc7904`). The
new head is `2262b4bafa9f06177b311869b91c71d4fcd2ac96`, 51 commits ahead of `master-ebc7904` and 0 behind. Its tree
differs from the pre-retcon head `991f8af47e` only in having no
`.github/workflows/` changes. Retcon summary:
https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479099635

After that retcon, a stray commit `28177349d0180f4a515e2bb17833ffcbe2ad6749`
temporarily reintroduced only the `depcheck.yml` Ubuntu 24.04 runner pin. Job
`fix-endo-pr1349-stray-depcheck-20261028` verified that its parent is exactly
`2262b4bafa9f06177b311869b91c71d4fcd2ac96`, verified that the commit's entire
diff is `.github/workflows/depcheck.yml`, and force-restored the branch to that
parent. PR #1582 already carries the runner pin.
**#1349 no longer touches `browser-test.yml` or `depcheck.yml`. Do not carry
any workflow edits upstream with this ferry.** #1582 is a separate PR with no
ferry authorization.

If upstream `endojs/endo` `master` has moved past `ebc7904d87b1` when you run,
that is fine as long as the head still rebases cleanly; if it does not, stop with
a blocked report rather than resolving conflicts under the maintainer's identity.
If the PR head is no longer `2262b4bafa`, stop with a blocked report: the head
moved after this directive was staged and needs a fresh review.

## Authorization provenance

The maintainer (kriskowal) asked for this ferry directly in review
https://github.com/endojs/endo-but-for-bots/pull/1349#pullrequestreview-5672187123
(2026-10-27T18:33:00Z): "@kriscendobot Please ferry upstream." The
`identity_switch_authorized: true` above transcribes that request. It was staged
by the gardener job `endojs-endo-but-for-bots-pr1349-review-51e3944c`.

The maintainer then asked for a weave and a re-staged ferry in
https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453429130
(2026-10-27T21:00:17Z): "@kriscendobot weave and send back to the ferry." This
re-staging was done by the gardener job
`endojs-endo-but-for-bots-pr1349-ferry-restage-20261027` (orchestration
`endojs-endo-but-for-bots-pr1349-weave-ferry-20261027`), which kept the
maintainer-transcribed authorization unchanged. The 2026-10-28 retcon
(job `retcon-endo-pr1349-20261028`) re-staged it again against the new head,
with the same maintainer-transcribed authorization. The maintainer still has the
final say by choosing whether to run `scripts/ferry.sh`.

## Prior attempt

A first run from host `kmkmbp2026` claimed this directive at
2026-10-27T20:54:05Z and exited at 20:56:07Z without the completion marker (log:
`/Users/kris/garden/.garden-ferry/logs/endojs-endo-but-for-bots-pr1349.20261027T205407Z.log`
on that host). That was against the old base `master-6ee3fda`, before the
maintainer asked for the weave. The directive is moved back from
`jobs/ferry/doing/` to `jobs/ferry/` so the next `scripts/ferry.sh` pass picks it
up.

## Preconditions (checked at re-staging, 2026-10-28)

- The 2026-10-27 preconditions still hold: both fix jobs are in `jobs/tada/`,
  and `.changeset/hardened-text-codecs-encapsulated.md` keeps the measured
  Chromium range.
- PR #1582 is green at `55f7733e83fc94b140259b61436e8c364a8e123a` and
  carries the Ubuntu 24.04 depcheck runner pin. A fresh run on #1349 after
  restoring `2262b4bafa` fails only the dependency-cycle workflow because its
  intentionally restored `ubuntu-latest` runner lacks `tred`; the main CI
  workflow completed successfully. Do not run this ferry until the maintainer resolves
  that CI/precondition conflict without reintroducing workflow edits to #1349.
- The head has no `fixup!` commits left.

Before you push anything, re-check that the PR head is still `2262b4bafa` and CI
is green at it. If not, stop with a blocked report naming what changed, and
leave the directive in `doing/`.

The `ubuntu-24.04` runner pins and the any-base Browser Tests trigger now live
only in #1582. Follow-ups on the bot repo cover the pins: schedule
`endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck`, job
`endojs-endo-but-for-bots-depcheck-tred-alternative`, and open PRs #1556, #1578,
#1566, and #1546 against `llm`. None of them block this ferry.

Follow the standard single-author ferry shape: Kris Kowal is the author of
every commit, and Co-Authored-By and Generated-with trailers are stripped.
