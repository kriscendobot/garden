---
ts: 2026-05-29T14:23:05Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/141848Z-dispatch-liaison-b2e87a.md
---

Shape-2 re-ferry of `endojs/endo-but-for-bots#351` (branch `mirror/2422-host-module-exits`, source head `fd214c1f`, 13 commits) onto the existing upstream PR `endojs/endo#2422` (branch `kriskowal-ponyfill-host-module`). Recompute-from-master + `--force-with-lease`; no new PR opened.

**Force-push:** `+ 1bf012f0b...773f151d4 HEAD -> kriskowal-ponyfill-host-module (forced update)`. Prior tip `1bf012f0b` matched the lease.

**Upstream PR #2422 post-push:**
- head: `773f151d454916de6daf65f8b06af457f6d9f16c` (short `773f151d4`).
- state OPEN, non-draft, `mergeable: MERGEABLE`.
- `reviewDecision: APPROVED`. **Both prior approvals persist**: dckc APPROVED and boneskull APPROVED both still on the record after the force-push (endo master is not branch-protected with dismiss_stale_reviews, as expected). No approval was unexpectedly lost.
- Title/body left unchanged (same feature; recompute did not make the existing title misleading).

**Attribution + trailers:** all 13 commits rebuilt via commit-tree on `origin/master` (`c49fb048b`) with author AND committer normalized to `Kris Kowal <kriskowal@kriskowal.com>` (source was a mix of `Kris Kowal <kris@agoric.com>` and `endolinbot <main.barn5084@fastmail.com>`; all normalized). Original author dates preserved. Per-commit `interpret-trailers --parse` is empty on every commit (no Co-Authored-By, no Generated-with-Claude-Code). `(#351)` subject suffixes stripped; "Raised by ... on PR #351" and "per garden/skills/..." process-commentary body fragments dropped.

**Net diff matches source:** recomputed `origin/master..HEAD` diff content (646 lines) is byte-identical to `gh pr diff 351 -R endojs/endo-but-for-bots` on all added/removed content lines and the file set. The only deltas were `@@` hunk-header line numbers, expected because the mirror was built on an older endo base (`6804b7dc` vs current master `c49fb048b`).

**CI at re-ferry time:** fresh run triggered by the push; all 18 workflow checks pending (browser-tests, build, check-action-pins, cover, lint, test matrix x22/24 on macos/ubuntu, test-async-hooks, test-hermes, test-ocapn-python, test-xs, test262, viable-release, zizmor). dependabot config check passed. Shepherd handles CI-driven follow-up; boatman does not wait.

**Garden-side cross-link:** posted on `endo-but-for-bots#351` (no prior `Mirror of` comment existed, so created): `Mirror of https://github.com/endojs/endo/pull/2422 (head 773f151d4).` Comment id `4576217955`, URL https://github.com/endojs/endo-but-for-bots/pull/351#issuecomment-4576217955 .

**Upstream-side cross-link:** routed to steward via the `message: boatman → steward` entry (companion to this result). Not posted under kriskowal (primary upstream).

Self-improvement: nothing this time. The Shape-2 procedure, attribution discipline, and two-way-mirror norm all applied cleanly as documented; the older-base hunk-header divergence is already anticipated by the dispatch's "verify content, not hunk headers" framing.
