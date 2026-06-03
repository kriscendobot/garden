---
ts: 2026-06-03T04:56:48Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/045427Z-dispatch-liaison-75e7bc.md
---

Shape-3 fast-forward append onto endojs/endo#2422 (`kriskowal-ponyfill-host-module`). Appended bots#351's one new tip commit (`eadb6c712`, `style(compartment-mapper): replace Latin shorthand in link.js per kriskowal #351`, endolinbot) onto the prior #2422 head `773f151d4`.

Procedure: detached at the PR head `773f151d4` (not master); verified `origin/kriskowal-ponyfill-host-module` tracking ref equalled the live remote tip (`773f151d4`); confirmed the bots commit's parent link.js blob (`6a06dbd1`) equalled #2422 head's link.js blob, so the cherry-pick was clean (no conflict). Rewrote attribution + message via `commit --amend --reset-author` under `Kris Kowal <kriskowal@kriskowal.com>`, dropping the `per kriskowal #351` fork annotation. New commit `25c076b6d`: author and committer both `Kris Kowal <kriskowal@kriskowal.com>`, no trailers (`interpret-trailers --parse` empty), single 1-line diff (`// cf.` → `// See`).

Pre-flight `merge-base --is-ancestor origin/kriskowal-ponyfill-host-module HEAD` succeeded. Pushed without force: remote response `773f151d4..25c076b6d` with NO leading `+` (genuine fast-forward).

Post-push: new #2422 head `25c076b6d`; 14 commits; MERGEABLE; reviewDecision APPROVED. Both prior approvals persist (a fast-forward append never dismisses approvals): dckc APPROVED and boneskull APPROVED both still present on the review record. CI: all 16 checks re-triggered and pending (browser-tests, build, check-action-pins, cover, lint, the test matrix, test-hermes, test-ocapn-python, test-xs, test262, viable-release, zizmor); not waited on (shepherd handles CI follow-up).

Garden-side cross-link: edited comment id `4576217955` on endo-but-for-bots#351 in place from `(head 773f151d4)` to `(head 25c076b6d)`. No upstream-side mirror comment (retired 2026-05-29).

Self-improvement: nothing this time. The blob-equality precondition the dispatch named (parent link.js blob equals head link.js blob) is exactly the check Shape 3 needs and matched cleanly; the skill already covers it via the ancestor check.
