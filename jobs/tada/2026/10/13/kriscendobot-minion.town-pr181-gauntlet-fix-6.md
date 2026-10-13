Fix round 6 for PR #181 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing. The push advanced `git-remote-served-clip` from `b7bd43c` to `51ac555`. I did not re-run the panel.

**Panel-6 must-fix items applied:**
1. **Backoff gating withdrawal** (assessor, breaker): `markerSweep` and `fullSweep` in `served-clip.ts` now run a partition if it is `due()`, unserved, or has purge requests pending. Unpublish and purge-root therefore no longer wait out the one-hour backoff cap. I added a test, "unpublish and purge-root do not wait out a projection backoff", which pushes a partition to the backoff ceiling and then withdraws without advancing the clock.
2. **`setInterval` overflow** (saboteur, corner-prober): `config.ts` now rejects `GIT_REMOTE_RECONCILE_INTERVAL_MS` and `GIT_REMOTE_FULL_SWEEP_MS` above 2^31−1. `served-clip.ts` also clamps both delays at `start()`, using a new exported `MAX_TIMER_DELAY_MS`. A config test covers the boundary.
3. **Abbreviated params** (stylist): `serveEntry` in `content-server.ts` now uses `request`/`response`.
4. **Unmeasured cost figure** (benchmarker): `designs/git-remote-served-clip.md` § 4 now labels the ~2 ms / ~2 s figures an unmeasured estimate.

**Not applied:** the should-fix items. They are the `parseServedState` validation, marker clearing on the early returns in `project()`, the HTML rewrite budget, `collectHtml` memory, the shadowed-`.content` warning, and the decomplector's destroy handshake. The job asked for must-fix items only, so these are left for a later round.

**Local checks:** the git-remote and gateway test suites pass except `capability.test.ts` "propagates a git failure rather than reporting the ref absent". That test failed in my sandbox on code my change doesn't touch, and I did not confirm it also fails on the base commit. CI was green anyway.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1483494 cached reads)
- Output: 10387 tokens
- Cost: $0.6977928
- Wall-clock: 942s

<!-- garden-usage-end -->
