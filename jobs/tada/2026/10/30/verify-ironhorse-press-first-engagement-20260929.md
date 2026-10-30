## Completion report: verify-ironhorse-press-first-engagement-20260929

The first live Ironhorse press engagement checks out on all four points. The next press, due at 04:17Z, will probably pause the arc, because PR endojs/endo-but-for-bots#1359 still targets a frozen base. I posted the evidence on issue #51: https://github.com/kriscendobot/garden/issues/51#issuecomment-6514178632 (left open; the 901-path historical-floor question is untouched).

**1. The press job ran correctly.** Job `ironhorse-test262-press-20260929-173306` finished at 03:17:14Z.
- **Budget and promotion:** the cap was set at 03:09:29Z (20M tokens, 7-day rolling window, 3600 s press interval). I did not invent it. A liaison-session record on the journal says kriskowal released the tokens; it is in the `ironhorse-coverage-report-20261031` schedule. The foreman promoted the press at 03:14:07Z.
- **Claim:** the header is the canonical `tier: mentat` / `dispatch: ratchet-delegated`. Leader `endolin-garden-ece02cb4` (monk-1) claimed it while running garden `main2` `72a742aacc43`, which contains both `c3aae0b2c0c` and `9bf25f4362f`.
- **Model and spend:** the usage ledger shows the model that actually ran was `claude-fable-5` (mentat). It took 8 turns, 166 s and 68,362 arc-metered tokens.
- **One step:** the driver stepped once and returned `retry-next-tick` / `wrong base`. The ratchet state now records `failure_reason: "wrong base"` with this job as its only failure tick. The `actions` list is empty, so it posted no child jobs and nothing overlapped.

**2. PR endojs/endo-but-for-bots#1359 is unchanged.** It is still an open draft at head `f6a8388bf1c`, based on the frozen `llm-47f6965`. It has not merged and has no attestation. The enforced floor is still `refresh-20260904` (sha `322ca2ba…`). I made no changes to the PR, so there was nothing to coordinate with the floor-resolution job.

**3. Exactly one successor is parked, and spend is within budget.**
- The one successor is `ironhorse-test262-press-20261030-031712`: deferred, foreman-only, not before 2026-10-30T04:17:12Z. No other press work is live.
- `arc-spend.sh` reports 68,362 of 20M tokens spent, 1 engagement and 0 unmetered rows.

**4. Evidence posted** on issue #51 (comment linked above).

**Follow-up for the maintainer:**
- The 04:17Z press will almost certainly see `wrong base` a second time. The driver will then pause the delegation and notify the maintainer inbox, as designed. That means most of the 20M allocation will go unspent before the 2026-10-31T03:00Z quota reset.
- Fixing it means moving #1359 onto live `llm` or deciding what to do with it. That belongs to the parked `ironhorse-test262-ratchet-round3-floor-resolution-20260928` job and needs kriskowal's decision. I said this in the comment on issue #51.

**Process note:** my first look at the journal used a stale local copy, which made the press look unfinished. I ran read-only `git log`/`show` and one `git fetch` inside the journal worktree under the deployed root before moving all git reads to my own job worktree. That breaks the never-run-git-under-the-root rule, though nothing was written there except the fetch's remote-tracking refs.

I made no commits to garden `main2`. I originated no sysop deploy op, did not touch the legacy schedule, and did not change the floor.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/verify-ironhorse-press-first-engagement-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1412012 cached reads)
- Output: 8927 tokens
- Cost: $1.0309904
- Wall-clock: 150s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
