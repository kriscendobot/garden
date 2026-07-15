---
ts: 2026-07-15T06:07:33Z
kind: result
role: boatman
host: kmkmbp2026
short_id: 0e08d8
dispatch_root: dispatches/boatman--a7d440
project: endo
repo: endojs/endo-but-for-bots
source_pr: 259
upstream: endojs/endo
upstream_pr: 3322
upstream_branch: kriskowal-hardened-text-codecs-shim
upstream_head_sha: 2587b0f8cb19497368d513d30f67e791898a1ac1
refs:
  - entries/2026/07/15/060135Z-dispatch-boatman-a7d440.md
---

Ferried endo-but-for-bots#259 (`feat(ses): permit TextEncoder and
TextDecoder as universal intrinsics`) upstream to endojs/endo as
[endojs/endo#3322](https://github.com/endojs/endo/pull/3322). First-time
ferry, pr-handoff Shape 1.

## Precondition re-verification

`gh auth status` showed `kriskowal` active on this host; `gh api
repos/endojs/endo --jq .permissions` showed `push: true, admin: true`.
Dispatch prompt carried `identity_switch_authorized: true`. The
`origin/master` tracking-ref precondition check briefly flagged a false
positive: an ambiguous `git ls-remote origin master` pattern matched both
`refs/heads/master` and `refs/heads/changeset-release/master` and a naive
`cut -f1` grabbed the wrong line. A targeted `git ls-remote
https://github.com/endojs/endo master` confirmed the local
`origin/master` (`2708cacca`) was in fact current; no re-fetch was needed.
Worth tightening the skill's example command to disambiguate with
`refs/heads/master` explicitly.

## Mechanics

Detached at `origin/master` (`2708cacca`), cherry-picked the exact
3-commit range `3f601bc5f..7de74b4cd` from
`endojs/endo-but-for-bots:feat/hardened-text-codecs-shim` (clean
cherry-pick, no conflicts), then an interactive rebase with
`--reset-author --no-edit` on all three commits under `git -c
user.name='Kris Kowal' -c user.email='kriskowal@kriskowal.com'`.

Pushed to a fresh branch `kriskowal-hardened-text-codecs-shim` (verified
free upstream before push) and opened
[endojs/endo#3322](https://github.com/endojs/endo/pull/3322) ready-for-
review (not draft) against `master`, using the upstream PR template. The
source PR's body already followed the template cleanly with no fork-side
references to strip (`Refs: endojs/endo#2635` is already
upstream-equivalent and was kept verbatim); I added one paragraph to
Testing Considerations describing the third (Chromium-only) fix commit,
which the original body predated.

## Per-commit attribution + trailer verification

All three commits (`488411b5e`, `57524d5e1`, `2587b0f8c`) show `Kris
Kowal <kriskowal@kriskowal.com>` as both `Author` and `Committer` per
`git log origin/master..HEAD --pretty=fuller`. `git interpret-trailers
--parse` on every commit body returned empty (no `Co-authored-by`, no
`Generated-with-Claude-Code`, no other bot trailer): the source commits
were already clean, so the rebase only needed to rewrite attribution, not
strip trailers. No `(#N)` fork-side subject suffixes were present either.

## Upstream CI status at report time

`gh pr checks 3322 -R endojs/endo`: all checks `pending` except `zizmor`
(`pass`); the run had just triggered off the push. Boatman does not wait
for CI convergence per the standing discipline; shepherd territory if
follow-up is needed.

## Garden-side cross-link

Posted the single tagged comment on `endo-but-for-bots#259`:
`Mirror of https://github.com/endojs/endo/pull/3322 (head 2587b0f8c).`
Comment ID `4977431934`
(https://github.com/endojs/endo-but-for-bots/pull/259#issuecomment-4977431934).
No comment posted on the upstream PR, per the 2026-05-29 directive.

Self-improvement: nothing landed this dispatch (garden/ is read-only from
a dispatch root). Flagging for a future gardener pass on
`skills/pr-handoff/SKILL.md` § Preconditions: the example verification
command `git ls-remote origin master` is ambiguous against branches like
`changeset-release/master` that contain "master" as a path component and
should read `git ls-remote origin refs/heads/master`. One vivid
observation, no incorrect push resulted (caught with a disambiguated
re-check before acting), so a `message`-to-liaison felt heavier than
warranted; this note is the record.
