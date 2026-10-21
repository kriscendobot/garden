# Gauntlet FIX round 11: kriscendobot/minion.town#200

I applied both must-fix items from the panel-11 verdict (review 5596123961), pushed them to `feat/beta-settings-simplify` (28d151e → 9cd8a36), and CI came back green (`ci-wait-merge` rc 0, 2/2 Actions runs passed, 0 failed).

## Must-fix items

**1. Sign-out redirect could point at another host** (corner-prober; saboteur and spec-keeper filed the same issue as should-fix). Commit 44d0de2.
- **Problem:** turning the configured path into a URL collapses `.` and `..` segments. So `/.//evil.example` kept the site's origin but became the path `//evil.example`, which a browser reads as another host.
- **Fix:** `src/web/guest-web-router.ts` now also refuses a resolved path that starts with `//`.
- **Tests:** `test/web/guest-settings-http.test.ts` now refuses `/.//…`, `/a/..//…`, `/%2e//…` and `/%2e%2e//…`.

**2. Drop the temporary `web-open-` root name and look guests up by identifier** (decomplector). Commit 9cd8a36.
- **Directory (`src/endo/root-host-socket.ts`):** a new `lookupGuest(formulaIdentifier)` calls the daemon's `lookupById`. It refuses unless the root names the guest's agent and has no deletion marker for it, checked both before and after the lookup. It creates no name, so nothing is left behind.
- **Removed:** the `web-open-` name pattern, `sweepOpenNames`, and the temporary-name path in `bindGuest`. `bindGuest` and `lookup` now accept only deletion-marker names.
- **Service (`src/web/guest-web-socket-service.ts`):** `open` now uses `lookupGuest`. In `removeGuest`, all temporary-name handling and the second removal pass are gone.
- **Also done (decomplector's should-fix #2):** removed the in-process `recentlyDeleted` cache, since the race it covered no longer exists. `deleting` now only lets concurrent callers share one in-flight deletion. This also covers saboteur's should-fix #3 (sweep failures swallowed silently) and corner-prober's request for a test of the 1024-entry eviction, because that code no longer exists.
- **Tests (`test/web/guest-web-socket-faults.test.ts`):**
  - The fake daemon gains `lookupById`.
  - The two race tests now pause at `lookupById` instead of at the bind, and assert that no name is left behind.
  - Three tests that only existed for the temporary name were removed.
  - The name grammar no longer includes `web-open-`.

## Local verification
- `tsc --noEmit` is clean.
- The tests for `test/web`, the accounts tests and the daemon integration test all pass (130 passed). The two tests that need a real daemon, `guest-web-daemon` and `endo-daemon-integration`, skip locally, so they ran only in CI.
- The full `npm test` run had 3 failures, all in `test/git-remote/*`. They come from the local sandbox's git setup, not from this change, and CI is green.

## Not done (should-fix and comment items)
- Breaker #1: a guest reference returned before a deletion can still be used across the cleanup sweep.
- Purist: one name grammar living in two modules, two parallel bond-admin interfaces, and the unused `hasGuestBond`.
- Pruner: the deletion contract is restated in three documents.
- Decomplector #3: the PR body doesn't say why it doesn't reuse `claude-guest-bridge`'s separate-directory approach.
- Saboteur #2 and corner-prober #4: an unguarded `JSON.parse` in `ledgerKeys`.

Per the job, I did not re-run the panel; the driver posts panel-12.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2591102 cached reads)
- Output: 18961 tokens
- Cost: $1.7279363999999997
- Wall-clock: 1934s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
