---
ts: 2026-06-02T05:41:47Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/053340Z-dispatch-liaison-d942ee.md
---

Boatman first-time multi-author ferry of endojs/endo-but-for-bots#387 -> **new upstream PR endojs/endo#3294 (DRAFT)** complete (dispatch `d942ee`).

**Upstream PR:** https://github.com/endojs/endo/pull/3294 — branch `kriskowal-3289-wget-engines`, head `e0d7a8622a0eac02a7072bb4f98b37d79abe7a70`, base master, DRAFT. Drops esvu for direct curl download of xs/v8 (esvu hangs on Node 24). Body `Refs: #3289` (one of several attempts; not auto-closing).

**Attribution (the point of this ferry) verified:** the substantive commit `fix(benchmark): install xs/v8 via direct download, drop esvu` carries author **`0xPatrick <patrick@0xpatrick.dev>`** (preserved via `--author=` only, no --reset-author) with committer `Kris Kowal <kriskowal@kriskowal.com>` — the multi-author salvage shape. The yarn.lock chore is fully kriskowal. Trailers empty. The maintainer verified the 0xPatrick author line this session via GitHub-profile lookup (principal `0xpatrickdev`; the source carried his bot identity `patchrick@0xpatrick.dev`, rewritten to his personal `patrick@0xpatrick.dev` used on the equivalent commit endo-but-for-bots#386 / cda0782e9).

**Source-shape note:** the source branch had been rebased to a cleaner 2-commit shape since dispatch (the `.bench-engines`->`.engines` rename folded into the substantive commit), so the ferry was 2 commits, not the dispatch's described 3. Benign; net content matches.

**WEAVE OWED:** #3294 is `mergeable: CONFLICTING` — real, not GitHub lag. Master advanced from the dispatch-pinned `c49fb048b` to `3c5753b6` mid-ferry; #3292 "chore: dependency maintenance" rewrote yarn.lock. The ONLY conflicting path is `yarn.lock` (confirmed via `git merge-tree --write-tree`). Per pr-handoff scope boundary the boatman did not rebase. Next action: dispatch a **weaver** on #3294 to resolve the lockfile collision (regenerate yarn.lock on current master). Low-risk, mechanical.

Garden-side mirror cross-link created on endo-but-for-bots#387 (comment 4599031642). Upstream-side handed to steward via `message: boatman → steward`. Boatman journal entries at tip `dce9026f`.

Fourth ferry of the session; first multi-author one. Endo bare clone + host preconditions reused.
