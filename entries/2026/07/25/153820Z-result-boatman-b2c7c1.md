---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: b2c7c1
refs: [b2c7c1, b9a5ae]
project: endo
source_pr: endojs/endo-but-for-bots#719
upstream_pr: endojs/endo#3332
upstream_branch: kriskowal-hardened-url-shim
upstream_head: 6c50a5fad
---

Ferry of endo-but-for-bots#719 (`feat(ses): permit URL and URLSearchParams as a
vetted shim (%URL%/%SharedURL% split)`) upstream complete. First-time ferry,
Shape 1. Split-role completion: the boatman did all git work; the liaison
opened the upstream PR (see below).

- **Upstream PR**: <https://github.com/endojs/endo/pull/3332> — open,
  ready-for-review, base `master`, MERGEABLE.
- **Upstream branch/head**: `kriskowal-hardened-url-shim` @ `6c50a5fad`
  (6 commits, one per logical change, none collapsed).
- **Attribution/trailers**: all 6 commits `Kris Kowal
  <kriskowal@kriskowal.com>` author+committer; `(#719)` subject suffixes and
  `Co-Authored-By` trailers stripped; `interpret-trailers --parse` clean except
  the legitimate `Refs: endojs/endo#2635`.
- **Conflicts the boatman resolved** (current master diverged from the source's
  frozen base `master-6ee3fda`): (1) `permits.js` — URL permit block landed at
  the same list position as the already-upstream TextEncoder/TextDecoder block
  (from #3322, merged 2026-07-22); kept both additive blocks. (2) modify/delete
  on `text-encoder-decoder.test.js` — never existed upstream (master named the
  codec tests `text-codecs*.test.js`); dropped the inapplicable comment edit,
  kept the URL test renames. Repo-wide grep confirmed no dangling `url-shim*`
  references.
- **Body discipline**: stripped the fork-side "Relationship to
  endo-but-for-bots#263" paragraph and the bot-side design-branch reference;
  corrected identifiers to final post-rename form (`urlBlobTaming`/`retain`,
  `url*.test.js`); kept `Refs: endojs/endo#2635` and all substantive sections.
- **Garden-side cross-link**: comment `5079090390` on #719 —
  `Mirror of https://github.com/endojs/endo/pull/3332 (head 6c50a5fad).`
- **CI at report time**: pending (`zizmor` pass, rest running). Given the
  non-trivial conflict resolution, the liaison is verifying CI to green rather
  than deferring entirely to the shepherd.

**Harness gate encountered (self-improvement, ref b9a5ae).** The subagent
boatman's `gh pr create -R endojs/endo` was denied by Claude Code's auto-mode
permission classifier: a dispatch prompt's `identity_switch_authorized: true`
(agent output) is not the *live user's* consent to open a PR against a public
external repo. The liaison, holding the user's direct "Ferry #719" instruction
in a live turn, opened the PR. Worth encoding in `roles/boatman/AGENT.md`: a
boatman under auto mode should expect the PR-open step to require either a live
user turn or a pre-granted permission rule, and should hand the drafted
title/body back to the liaison (as this boatman did) rather than attempting
tool workarounds. Queued for the gardener.

Competing #263 (universal placement) stays open; the maintainer chose #719's
split design and closes the loser separately.

Dispatch root `dispatches/boatman--b2c7c1` torn down on return.
