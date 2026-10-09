I did not weave kriscendobot/minion.town#130. I stopped before force-pushing because current `main` already contains a different fix for the same daemon health-probe race, and the conflicts are a design choice between two fixes, not a mechanical rebase.

**What I did**
- Checked the PR: it is open, not a draft, mergeable on its stale frozen base `main-b32291d`, with one commit at head `d24effe`. Current `main` is at `c9a073c`.
- In a separate checkout for this job, I tried rebasing `d24effe` onto current `main`. It conflicted in `deploy/aws/scripts/deploy-endo-daemon.sh` (3 places) and in `test/endo-pin-drift.test.ts`.
- I aborted the rebase. Nothing was pushed, and the PR's head and base are unchanged.

**Why I stopped**
Since the frozen base, `main` has landed `6a3555d` ("endo daemon probes must not auto-start a stray daemon") and `a880de0` ("reap the endo-daemon manager-node orphan that wedges CD"). Those fix the same 2026-09-29 race this PR targets, in a different way:
- **Health probe:** `main` adds an `endo_probe` that runs only once the socket actually accepts a connection, and sandboxes anything the CLI might auto-start away from the real state and port 8920. The PR only checks that the socket file exists.
- **Stopping the daemon:** `main` stops the unit, then kills stray daemon processes and anything still holding the port. The PR adds a `stop_endo_daemon` helper that runs `endo stop` instead.

If I resolved toward `main`, the PR would be close to empty. Keeping the PR's side would undo the newer, stronger fix on `main`. Combining them would mean redesigning the deploy logic, which is more than a weave.

**Follow-ups**
- I recommend the arc supervisor (kriscendobot/garden#58) or the maintainer close #130 as superseded by `6a3555d` and `a880de0`. The one part that might still be worth keeping is the `endo stop` cleanup of daemon workers. If so, re-land it as a small change on current `main`, together with its pin-drift test assertions.
- The minion.town proxy screen should not merge #130 as it stands, since it is based on stale `main-b32291d`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-minion-town-pr130-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (281794 cached reads)
- Output: 2039 tokens
- Cost: $0.46034679999999994
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
