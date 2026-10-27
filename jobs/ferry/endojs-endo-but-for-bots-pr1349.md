---
downstream: endojs/endo-but-for-bots#1349
downstream_branch: build/hardened-text-codecs-shim
downstream_base: master-ebc7904
downstream_head: b122ff91ef98ac3e151852b58d2cb1110060fb26
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

If upstream `endojs/endo` `master` has moved past `ebc7904d87b1` when you run,
that is fine as long as the head still rebases cleanly; if it does not, stop with
a blocked report rather than resolving conflicts under the maintainer's identity.
If the PR head is no longer `b122ff91ef`, stop with a blocked report: the head
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
maintainer-transcribed authorization unchanged. The maintainer still has the
final say by choosing whether to run `scripts/ferry.sh`.

## Prior attempt

A first run from host `kmkmbp2026` claimed this directive at
2026-10-27T20:54:05Z and exited at 20:56:07Z without the completion marker (log:
`/Users/kris/garden/.garden-ferry/logs/endojs-endo-but-for-bots-pr1349.20261027T205407Z.log`
on that host). That was against the old base `master-6ee3fda`, before the
maintainer asked for the weave. The directive is moved back from
`jobs/ferry/doing/` to `jobs/ferry/` so the next `scripts/ferry.sh` pass picks it
up.

## Preconditions (checked at re-staging, 2026-10-27)

All satisfied at re-staging time:

- `endojs-endo-but-for-bots-pr1349-fix-maintainer-findings-20261027` is in
  `jobs/tada/` (2026-10-27).
- `endojs-endo-but-for-bots-pr1349-fix-changeset-range-20261027` is in
  `jobs/tada/` (2026-10-27). Its fix landed as `91cca8a551` ("docs(ses): state
  measured codec range (#1349)") and was carried through the weave. At
  `b122ff91ef` the changeset
  `.changeset/hardened-text-codecs-encapsulated.md` names the measured range
  (affected: Chromium 120, 126, 127, 133, 136, 137; clean: 138, 139, 140), not
  "all Chromium before 138".
- CI is green at the woven head `b122ff91ef`: all 16 check runs succeeded
  (lint, build, browser-tests, cover, test-xs, test-hermes, test262 22.x/24.x,
  test 22.x/24.x on ubuntu and macOS-15, viable-release, zizmor,
  copilot-setup-steps, test-ocapn-python).

Before you push anything, re-check that the PR head is still `b122ff91ef` and CI
is still green at it. If not, stop with a blocked report naming what changed, and
leave the directive in `doing/`.

The other two inline asks from the 2026-10-27 review (a weekly recheck to revert
the `ubuntu-24.04` pin in browser-test.yml, and finding a `tred` alternative so
depcheck.yml can unpin) are follow-ups on the bot repo, tracked as schedule
`endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck` and job
`endojs-endo-but-for-bots-depcheck-tred-alternative`. They do not block this
ferry. Carry the PR's workflow pins upstream as they are, unless the maintainer
says otherwise.

The head contains `fixup!` commits; squash them into their targets when
preparing the upstream branch.

Follow the standard single-author ferry shape: Kris Kowal is the author of
every commit, and Co-Authored-By and Generated-with trailers are stripped.
