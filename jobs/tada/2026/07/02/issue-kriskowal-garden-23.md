Comment posted (did not close the issue — the submitter closes it). Work complete.

## Completion report

**Job:** kriskowal/garden issue #23 — "activate the foreman and authorize loading up the work in progress to three active concurrent jobs."

**What I found:** The `garden-foreman` service is already enabled fleet-wide (`enable-services` auto-derives it) but is a leader-only singleton gated by `ExecCondition=is-main-host.sh`, so it only pumps on the designated leader. Substantively, the foreman pumped only when the board was *fully idle* (`todo` + `doin` both empty), keeping effectively **one** job in flight — there was no concurrency/WIP knob to raise to three.

**What I changed (landed on `main2`, commit `f7dccc8`):**
- `scripts/jobs/foreman.sh` — replaced fully-idle detection with a **work-in-progress target** `GARDEN_FOREMAN_WIP`. The pump fires while in-flight work (`todo` + `doin`) is *below* the target, posting one milestone step per settle window, then goes silent at capacity. Debounce, anti-flap, deferred-plan promotion, and the weekly token gate are all preserved. Default is **1** (behavior-preserving).
- `scripts/systemd/garden-foreman.service` — sets the fleet default `GARDEN_FOREMAN_WIP=3` per the maintainer's authorization, with a comment citing issue #23.
- `scripts/jobs/test/run-test.sh` (SUBTEST 14a) + new `foreman-stub-counter.sh` — assert the board tops up 0→3 with three *distinct* steps and stays silent at capacity; existing SUBTEST 14 still covers the `WIP=1` default.

**Verification:** An isolated harness driving the real `foreman.sh` (the full suite's shared `/home/kris/.garden-test` was colliding with a concurrent fleet-invoked run-test and aborted early at unrelated SUBTEST 6) passed all 6 checks: WIP=3 climbs 0→1→2→3 one-per-window, three distinct bases (no anti-flap), silent at capacity; and default WIP=1 stays silent on a busy board and pumps exactly one when empty.

**Replied on the issue** (`#issuecomment-4870503296`) explaining the above and the operational rollout: the change goes live when the leader deploys the new `main2` (the deploy-on-upgrade Monitor does this automatically once `main2` is ahead), provided a leader is designated. I ran this from the follower `endolinbot2`, which cannot deploy or flip leadership, so I did not attempt the operational activation myself.

**Follow-ups:** None required for rollout (the upgrade-monitor path carries it). If the fleet currently has no leader marker set, the reply notes `set-main-host.sh <host>` as the prerequisite. Did not close the issue (submitter closes when satisfied).
