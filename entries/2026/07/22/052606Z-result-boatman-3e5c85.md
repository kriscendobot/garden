---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: 3e5c85
refs: [3e5c85, 628707]
project: endo
source_pr: endojs/endo-but-for-bots#259
upstream_pr: endojs/endo#3322
upstream_branch: kriskowal-hardened-text-codecs-shim
upstream_prior_head: 2587b0f8cb19497368d513d30f67e791898a1ac1
upstream_new_head: 7d434b9393776694ba8b4af3033a5761d8a5598f
---

Re-ferry of endo-but-for-bots#259 to endojs/endo#3322 complete. Shape 2
(recompute-from-master, force-push).

- **Shape 2 confirmed necessary**: prior upstream head `2587b0f8c` was not an
  ancestor of the source's new shape (the "tolerate undeletable
  arguments/caller" fix it carried was reverted in the source).
- **Commit collapse**: verified by tree-hash comparison that the source's fix
  (`0b7ab7590`) and its revert (`fa2c5d023`) net to an identical tree, then
  collapsed the 5-commit source series to a clean 3 (feat / test /
  drop-redundant-globalThis). Verified byte-for-byte that the recomputed net
  diff against current master equals the source's full 5-commit net diff.
- **Upstream head after force-push**: `7d434b9393776694ba8b4af3033a5761d8a5598f`.
- **Attribution/trailers**: all 3 commits show `Kris Kowal
  <kriskowal@kriskowal.com>` as author and committer; `interpret-trailers
  --parse` empty on every commit.
- **Post-push approval**: `reviewDecision: APPROVED` unchanged — no
  `dismiss_stale_reviews` on the branch; reviews (gibson042 APPROVED; kriskowal
  ×2, erights COMMENTED) stay anchored to the old commit oid.
- **CI at report time**: fresh run; `build`, `zizmor` pass, rest pending.
- **Garden-side cross-link**: comment `4977431934` on #259 edited in place →
  `Mirror of https://github.com/endojs/endo/pull/3322 (head 7d434b939).` No
  upstream-side comment.

**Open follow-up (introduced by the collapse):** the #3322 body's "Testing
Considerations" section still describes a third commit (the tolerate-undeletable
arguments/caller Chromium-lockdown fix) that was collapsed out with its revert.
The body now promises a fix not present in the diff. The boatman left title/body
unchanged per the dispatch's scoping; a follow-up boatman body edit (per
pr-formation) is owed to correct that paragraph. Surfaced to the maintainer.

Boatman's own detailed result entry: `628707`
(`entries/2026/07/22/052357Z-result-boatman-628707.md`).

Dispatch root `dispatches/boatman--3e5c85` torn down on return.
