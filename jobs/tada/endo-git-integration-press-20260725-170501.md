# Press dispatch report — git-integration / M3 loop (2026-07-25T17:23Z)

**Posture: no press action needed this dispatch.** The one live gate (kriskowal's re-review of #705) is still pending, and the one new piece of review work in the stack (#740) is already owned by a live peer job. All PRs in the stack are green.

## Assessment (all claims from live `gh` output)

- **#705** (Phase 1, push tier): OPEN, head unchanged at `a689a78f`, `reviewDecision=CHANGES_REQUESTED`, `mergeStateStatus=BLOCKED`. kriskowal is still in `reviewRequests` with no activity from him since his 2026-07-22T05:38Z review (already addressed by the force-with-lease commit + in-thread reply, last word ours at 05:46Z; one unresolved thread, awaiting him). Did not merge, did not re-ping.
- **#740** (endor-bindings design): **new CHANGES_REQUESTED from kriskowal today, 2026-07-25T15:20Z** — the design must now cover cross-compilation (pinned/vendored libgit2 bindings vs a pure-Rust git implementation), since a C dependency blocks cross-compiling the endor binary. A dedicated review job `endojs-endo-but-for-bots-pr740-review-6ca53b57` was claimed at 15:21Z (hermit on `endolin-garden-ece02cb4`) and sits in `jobs/doin/` — I deferred to that live worker per the shared-branch rule.
- **#691** (sequencing design): head moved today to `9ae1a3e5` (three design-reconciliation commits pushed by a fleet peer at 17:17–17:18Z — #731 grandfathering, parked JSON tool-wrapper surface, index restore); CI 5/5 SUCCESS. No action; still awaiting maintainer acceptance.
- **#707** (Phase 3, M3 exit): unchanged at `a0f4eca4`, 23/23 SUCCESS, MERGEABLE — still queued behind #705.
- **#708** (exo-git QID/hash): unchanged at `ce58ad49`, 26/26 SUCCESS (guile-interop not flaking this cycle).
- **#626** (Phase 5 eval): unchanged at `8e29c292`, still DRAFT as required.

## Incidents / follow-ups

- **Journal repo gc failure (pre-existing) flagged to maintainer** (msg `20260725T172804Z-19e1fd`): `.git/worktrees/journal/gc.log` (created 00:19Z today, before this run) shows `fatal: unable to read 9ad05cc3563a7ba4…` / `failed to run repack` — an unreadable object is blocking auto-gc of the shared root/journal repo on this host. Sync still works; left untouched for the root-repo-guard / a host-local fix.
- **Discipline breach, self-reported:** I ran one `git pull --ff-only` in `journal/` before registering the no-git-in-root rule. It only re-surfaced the pre-existing gc.log; I verified no stale `.lock`/`gc.pid` files remain and ran no further git there. Included in the maintainer message.

**Next dispatch should watch:** kriskowal's #705 re-review (merge #705 first in stack order on approval or a `merge` comment, then weave #707 onto `llm` taking `llm`'s push-tier copies, then merge #707 to close M3), and the outcome of the peer's #740 cross-compilation revision.
