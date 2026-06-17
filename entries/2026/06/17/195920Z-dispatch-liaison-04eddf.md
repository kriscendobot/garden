---
ts: 2026-06-17T19:59:20Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--04eddf`) for a **first-time ferry of bots#435 to a NEW endojs/endo PR, authored by Mark S. Miller (erights)** rather than kriskowal. Maintainer-directed; maintainer confirmed: tight logical series + erights@users.noreply.github.com.

Source: kriscendobot/endo-but-for-bots#435 (MERGED 2026-06-17), head `b1eceee2b`, base `master-4a04d07` (= endo master ancestor `4a04d078b`), 29 commits all endolinbot. "feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic" - immutable ArrayBuffers now inherit directly from ArrayBuffer.prototype (collapsing the lib-free-functions vs shim-methods two-surface story); drops the %ImmutableArrayBufferPrototype% ses intrinsic; aligns pass-style byteArray brand check. 22 files. No existing upstream PR; not on master; first-time. erights reviewed the bot-side design.

**Conflict surface = ZERO**: none of the 22 touched files changed on endo master since 4a04d078b, so restaging the net diff onto current master `a0f5d95ac` applies clean.

**Attribution (maintainer-confirmed):** ALL commits authored `Mark S. Miller <erights@users.noreply.github.com>` (the dominant GitHub-linked form, 26-27 endo commits), committer `Kris Kowal <kriskowal@kriskowal.com>` (the one pushing). This is the multi-author salvage shape: do NOT --reset-author to kriskowal.

Boatman brief (Shape 1 + retcon-style restage): fetch the source net diff (`refs/pull/435/head` == b1eceee2b; base 4a04d078b); detach at current master `a0f5d95ac`; apply the full base..head net diff to the working tree (clean, zero overlap); RESTAGE into a TIGHT LOGICAL SERIES (~3-4 commits) - suggested: (1) feat(immutable-arraybuffer): drop the pseudo-prototype; inherit directly from ArrayBuffer.prototype [packages/immutable-arraybuffer/* + .changeset + packages/bytes/src/to-immutable.js consumer], (2) feat(ses): drop %ImmutableArrayBufferPrototype% permits and intrinsic [packages/ses/*], (3) fix(pass-style): align byteArray brand check with the new immutable-ArrayBuffer prototype shape [packages/pass-style/*]; finalize grouping from the diff. EACH commit: author `Mark S. Miller <erights@users.noreply.github.com>` (via `-c`/GIT_AUTHOR_*), committer `Kris Kowal <kriskowal@kriskowal.com>`; conventional-commit subjects; write bodies in files (avoid inline -m). VERIFY final HEAD tree == master + the 22-file net diff (i.e. `git diff a0f5d95ac..HEAD` content == `git diff 4a04d078b..b1eceee2b`). TRAILER GATE: no Claude/Generated-with/Refs/Co-Authored anywhere (you write fresh messages, so clean - confirm). New branch `erights-immutable-arraybuffer-drop-pseudo-prototype`; open the upstream PR **ready-for-review** (source is MERGED/done) with a pr-formation body (the redesign behavior; reference DESIGN.md; NO fork-side Refs to endo-but-for-bots#430/#417); create garden-side cross-link on bots#435 (--paginate; none exists). `identity_switch_authorized: true`.

Expected report: new upstream PR URL + number, branch, the logical-series commits with author=erights/committer=kriskowal verified, no-trailer confirmation, tree==net-diff, mergeable, CI, created cross-link.
