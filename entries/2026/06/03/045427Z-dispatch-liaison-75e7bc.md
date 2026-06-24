---
ts: 2026-06-03T04:54:26Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--75e7bc`) for a **Shape-3 fast-forward append** of endo-but-for-bots#351's one new commit onto endojs/endo#2422 (host module exits). No force-push.

State: #2422 (branch `kriskowal-ponyfill-host-module`, head `773f151d4`, 13 commits, **APPROVED by dckc + boneskull**) is the faithful ferry of bots#351's first 13 commits. bots#351 gained exactly ONE new tip commit since: `eadb6c712 style(compartment-mapper): replace Latin shorthand in link.js per kriskowal #351` (endolinbot). It is a trivial self-contained 1-line change (`// cf.` -> `// See` in link.js). Verified the new commit's parent blob for link.js == #2422 head's link.js blob, so the cherry-pick applies cleanly and the append is a true fast-forward.

Boatman brief (pr-handoff § Shape 3): fetch the upstream head `773f151d4` and the new commit `eadb6c712`; detach at `773f151d4` (NOT master); cherry-pick `eadb6c712`; rewrite author+committer to `Kris Kowal <kriskowal@kriskowal.com>` (consistent with all #2422 commits; the bot commit is endolinbot); message -> `style(compartment-mapper): replace Latin shorthand in link.js` (drop the `per kriskowal #351` fork annotation); strip trailers; pre-flight `merge-base --is-ancestor origin/kriskowal-ponyfill-host-module HEAD`; push WITHOUT force (remote must read `773f151d4..<new>`, no leading `+`); verify dckc + boneskull APPROVED persist (a fast-forward never dismisses) and mergeable; edit the existing garden-side cross-link comment 4576217955 on bots#351 to the new head. `identity_switch_authorized: true`.

Expected report: new #2422 head SHA, non-force fast-forward confirmation, the appended commit's attribution (Kris Kowal author+committer, trailers empty), approval-persistence (dckc + boneskull), mergeable, CI status, edited cross-link.
