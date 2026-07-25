---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: c71c32
refs: [c71c32, 092114, c4e1a2]
project: endo
source_pr: endojs/endo-but-for-bots#719
upstream_pr: endojs/endo#3332
upstream_branch: kriskowal-hardened-url-shim
upstream_prior_head: 6c50a5fadbb1570e1579ba94511134bac49290a4
upstream_new_head: b43ac9c49afa399687d2d1e0ea297257ec8d7089
---

Re-ferry of endo-but-for-bots#719 to endojs/endo#3332 complete — **Shape 3
(fast-forward append)**, carrying the lint fix (tick c4e1a2).

- **Ancestor check**: `merge-base --is-ancestor origin/kriskowal-hardened-url
  -shim HEAD` → PASS.
- **Push**: `6c50a5fad..b43ac9c49  HEAD -> kriskowal-hardened-url-shim` — no
  leading `+`, a true fast-forward (no force).
- **New upstream head**: `b43ac9c49afa399687d2d1e0ea297257ec8d7089` (matches
  `git ls-remote` and #3332 headRefOid).
- **One appended commit**: `c909775f3 fix(ses): drop redundant globalThis global
  directive` (removes `/* global globalThis */` from url.test.js /
  url-blob-remove.test.js / url-missing.test.js). Rewritten to `Kris Kowal
  <kriskowal@kriskowal.com>` author+committer; `interpret-trailers --parse`
  empty; `git diff c909775f3 HEAD` empty (content byte-identical, metadata only).
- **Approvals**: none before or after (#3332 was REVIEW_REQUIRED); nothing to
  preserve. Fast-forward append would not have dismissed any regardless.
- **Cross-link**: comment `5079090390` on #719 edited in place →
  `Mirror of https://github.com/endojs/endo/pull/3332 (head b43ac9c49).`
- **CI at report time**: freshly triggered, pending. Liaison verifying to green
  (the lint failure from the first ferry — 3 no-redeclare errors — should now
  clear, since bot-side #719 lint is green with this commit).

Dispatch root `dispatches/boatman--c71c32` torn down on return.
