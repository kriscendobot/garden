**Root cause found: yes** (by the prior attempt of this job; this requeued run re-derived and verified everything from committed history, the journal, and the live host rather than trusting recollection).

**Mechanism.** The host's Claude Code CLI was stale at 2.1.267, which predates `claude-opus-5-5` — the anthropic mentor-tier default. Every mentor claim died 6–17 seconds in with `API Error: 400 ... version 2.1.280 or newer is required`; the generic `api error` transient signature classified each death as a blip, producing the requeue storm (52 claims / 2 completions / 49 "transient handler kills" in 6h). Mentat and minion jobs kept working, masking it, and garden deploys never touch the CLI binary — which is why the 06:55Z force-deploy changed nothing. The CLI was stuck stale because the npm global tree (`/usr/local/lib/node_modules`) was root-owned, so `claude update` silently failed forever.

**Fix (verified live on this host).**
- Host-level: CLI is now **2.1.283** (`/usr/local/bin/claude` → `/usr/local/claude-code-2.1.283/bin/claude`); `/usr/local/lib/node_modules` chowned so future `claude update` works.
- Garden-level: main2 commit `916ab48e206` adds `is_model_unsupported_signature` + a pre-claim health-gate latch that parks a host whose CLI is too old for the tier model, keyed to the installed CLI version and self-clearing on update — so a recurrence parks the host instead of sinking the board.

**Validation evidence (job basenames + outcomes).** Three consecutive mentor-tier (`claude-opus-5-5`, exactly the shape that was dying) probes pinned to this host all completed: `oros-studio-health-probe-20260927-1` (tada 15:43:54Z), `-2` (15:50Z), `-3` (15:53:40Z). Since the cap was restored, ordinary board work has also completed cleanly here: `endojs-endo-but-for-bots-pr1089-review-5bf63a47-retro` and two pr1281 review retros (all tada), with `ironhorse-ocap-frozen-objects` in flight >45 min unkilled. Fleet-wide, the **only** `reap-now` since the 15:01Z fix is this restoration job's own prior attempt (16:01:42Z) — explained by a separate, documented mechanism: a scaler-driven `systemctl --user stop` of a busy monk unit kills the pinned job in its cgroup, which is what cost the prior session, not a recurrence of the 400 epidemic. Host fundamentals are clean: no failed units, 6% disk, 1% inodes, all garden timers ticking.

**`config/worker-leveling` state.** The oros-studio row is **`4 0`** (monk-cap 4, cleric-cap 0), restored from the investigation cap of `1 0` at 15:54:48Z (journal commit `ca154782b97`) after the probes passed. I left it there deliberately: the validation bar (several consecutive successes of the previously-failing shape, plus ordinary work completing) is met, and `4` is the signal for the fleet to resume routing ordinary work here. The cleric cap of 0 matches this host's normal posture.

**Follow-ups (informational, no successor job needed).**
- The deployed root is 27 commits behind main2 (still `586aee8196b`, pre-health-gate). This is not an exposure right now (the CLI is current), and the autonomous rolling deploy is actively converging: the leader issued a fresh canary release token for `e4fe55c740f8` at 16:26Z and `upgrade-ready` refreshed at 17:02Z; it will advance once the host drains (my slot frees on completion). The known "deploy gate times out under host load" issue on this host is documented separately in memory.
- The scaler-stop-kills-pinned-job gotcha that took down the prior attempt is recorded in the project memory (`oros-studio-stale-claude-cli-kill-epidemic.md`, updated this run with the validation outcome) as a candidate for a future garden fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-studio-health-restoration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (905645 cached reads)
- Output: 18911 tokens
- Cost: $3.1173349999999997
- Wall-clock: 718s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
