Fix round 5 for endojs/endo-but-for-bots PR #1407 is pushed and CI is green: 33 of 33 checks passed, `ci-wait-merge` returned rc 0. I fixed both must-fix items from the round-5 panel review (head `62ce1a11a5`, request-changes from the breaker and scribe seats).

**Must-fix items**
1. **Guest sockets now close when the guest is cancelled (breaker).** Before this, only formula collection closed a guest's socket, and collection is off unless `ENDO_GC=1`. `guestBootstrapPath` (`packages/daemon/src/manager.js`) now also closes the socket when the guest's context is cancelled, so `E(host).cancel(guest)` ends it with the default setting.
   - The design doc and the comment in `serve-guest-path.js` now say plainly that removing a guest's last pet name closes nothing while collection is off.
   - A new test runs a real daemon with collection off: `cancelling a guest revokes its bootstrap path without collection`. It fails without the change and passes with it.
2. **Summary comment for the follow-up commits (scribe).** I posted https://github.com/endojs/endo-but-for-bots/pull/1407#issuecomment-5967849233. It lists the four round-4 commits and the three round-5 commits, what each changed, and how each was checked.

**Should-fix items also applied**
- A guest-socket startup failure is now reported only to the caller instead of twice (assessor). The existing test now checks that nothing extra is reported.
- `revoke()` has a comment explaining that the socket name is freed before the listener removes the socket file (breaker #2).
- New `err` parameters are renamed to `error` (stylist).
- A pronoun in the `@endo/claude` README now clearly refers to `runConfinedTurn` (integrator).

**Commits** (pushed with `safe-push-pr-head.sh`, head moved `62ce1a11a5` → `a62e91aca6`): `cd7d03928e`, `2a8a0326ff`, `a62e91aca6`.

**Local checks:** on Node 24, the 19 tests in `serve-guest-path` and `guest-bootstrap-path` pass, eslint reports no errors, and `tsc` and prettier are clean. These tests don't run on this host's default Node 22, because the installed `better-sqlite3` was built for Node 24.

**Not done**
- I left the `/tmp/ect-` temp-directory prefix in the `confined-turn` tests unchanged. The short literal path keeps Unix socket paths within their length limit, and macOS's temp directory path is long enough to push them over.
- Follow-ups not filed as jobs: passing `marshalSaveError` through in `bus-manager-node`, fast-check property tests for socket naming and path length, and a direct test of the `win32` platform check.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2881487 cached reads)
- Output: 13764 tokens
- Cost: $1.5845854000000001
- Wall-clock: 2781s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
