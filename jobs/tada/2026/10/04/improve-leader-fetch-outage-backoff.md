Completion report: `improve-leader-fetch-outage-backoff`

During a leader-fetch outage, only one leader probe now runs per interval on a host, instead of every leader-gated unit starting its own failing fetch. The fix is pushed to `main2` as aef3d26039f. `main-host-test.sh` passes 52 of 52 after rebasing onto `main2`, and `fallback-warn-dedup-test.sh` passes 14 of 14.

**What changed in `leader_host` (`scripts/jobs/common.sh`)**
- **Marker:** a failed fetch writes a shared retry marker at `$GARDEN_STATE/leader/retry-at`. It holds the time the next probe is due and is replaced atomically.
- **Waiting callers:** until that time, callers past the 30-second cache TTL answer with the last-known leader and skip the fetch. That lookup is now in a new helper, `_leader_last_known`.
- **One probe per interval:** when the probe falls due, exactly one caller claims it under a non-blocking `flock`. It moves the due time a full backoff out before it starts, so a slow probe doesn't let other callers pile in behind it.
- **Backoff length:** set by the new knob `GARDEN_LEADER_RETRY_BACKOFF`, default 60 seconds; setting it to 0 turns the backoff off. If the marker holds a time more than one backoff ahead (a clock jump or garbage), it counts as due, so a bad marker can't stop probing for good.
- **Normal operation:** with no outage there is no marker, so the cost is one `stat`.
- **Recovery and escalation:** a successful fetch deletes the marker and closes the `leader-fetch` warning episode. Escalation is unchanged: every failed probe still calls `fallback_warn`, so an outage that lasts past `GARDEN_FALLBACK_ESCALATE_AFTER` still logs its one ERROR.

**New test section in `main-host-test.sh` (10 checks)**
- A git shim counts fetches.
- A healthy fetch leaves no marker.
- The first failure sets the marker and still answers correctly.
- Eight concurrent callers before the probe is due make 0 fetches; eight once it is due make exactly 1.
- A failed probe pushes the due time out again, and a far-future marker doesn't block probing.
- The ERROR escalation still fires.
- On recovery the marker is cleared, one `recovered:` line is logged, and fetching works normally afterwards.
- I disabled the claim check in the code and confirmed the test then fails with 8 fetches instead of 0 and 1.

**A problem while testing:** my first version of the shim handed off to the fleet wrapper `scripts/jobs/bin/git`. The wrapper treats the first other `git` on PATH (the shim) as the real binary, so the two kept calling each other and spawned runaway processes. I killed them, and they were confined to the test's own directory. The shim now finds the real binary by scanning PATH and skipping `scripts/jobs/bin`.

**Follow-ups**
- The default backoff should stay well under the 900-second escalation window. If a host sets it to 900 or more, `fallback_warn` will treat each probe as a new episode and the ERROR will never fire.
- `designs/leader-follower-determinism.md` §5.5 plans to change `leader_host` again (a stale cache would answer "follower"). The marker works the same way under that change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-leader-fetch-outage-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1936565 cached reads)
- Output: 16327 tokens
- Cost: $1.3812449999999996
- Wall-clock: 780s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
