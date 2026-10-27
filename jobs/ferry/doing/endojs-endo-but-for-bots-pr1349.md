---
downstream: endojs/endo-but-for-bots#1349
downstream_branch: build/hardened-text-codecs-shim
upstream: endojs/endo
upstream_base: master
upstream_pr:
human: Kris Kowal <kris@agoric.com>
identity_switch_authorized: true
convention:
---
Ferry endojs/endo-but-for-bots#1349 ("fix(ses): encapsulate TextEncoder and
TextDecoder behind SES-owned constructors") upstream to endojs/endo (base
master). The downstream PR is based on the frozen master snapshot
`master-6ee3fda`, so it is already master-shaped.

## Authorization provenance

The maintainer (kriskowal) asked for this ferry directly in review
https://github.com/endojs/endo-but-for-bots/pull/1349#pullrequestreview-5672187123
(2026-10-27T18:33:00Z): "@kriscendobot Please ferry upstream." The
`identity_switch_authorized: true` above transcribes that request. It was staged
by the gardener job `endojs-endo-but-for-bots-pr1349-review-51e3944c`. The
maintainer still has the final say by choosing whether to run `scripts/ferry.sh`.

## Precondition: let the in-flight fixes land first

The same review left inline asks on the PR. One of them changes PR content and
must be on the head before ferrying:

- `.changeset/hardened-text-codecs-encapsulated.md:6`, "I believe we narrowed the
  version range, not just all before 138. Please check." This is board job
  `endojs-endo-but-for-bots-pr1349-fix-changeset-range-20261027`.
- A fixer that started earlier is also in flight on the same branch:
  `endojs-endo-but-for-bots-pr1349-fix-maintainer-findings-20261027`.

Before you push anything, check that both jobs are in `jobs/tada/` on journal2,
that the changeset no longer reads as "all Chromium before 138" unless that
thread's reply shows the wording is correct, and that the PR's CI is green at
its current head. If any of these fails, stop with a blocked report naming what
is missing, and leave the directive in `doing/`.

The other two inline asks (a weekly recheck to revert the `ubuntu-24.04` pin in
browser-test.yml, and finding a `tred` alternative so depcheck.yml can unpin) are
follow-ups on the bot repo. They are tracked as schedule
`endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck` and job
`endojs-endo-but-for-bots-depcheck-tred-alternative`, and they do not block this
ferry. Carry the PR's workflow pins upstream as they are, unless the maintainer
says otherwise.

Follow the standard single-author ferry shape: Kris Kowal is the author of
every commit, and Co-Authored-By and Generated-with trailers are stripped.

---
ferry_claim:
  host: kmkmbp2026
  claimed_at: 2026-10-27T20:54:05Z

---
ferry_failed:
  at: 2026-10-27T20:56:07Z
  exit: 0
  marker: absent
  log: /Users/kris/garden/.garden-ferry/logs/endojs-endo-but-for-bots-pr1349.20261027T205407Z.log
