Pushed to `origin/main2` (45f4630a07) on the first attempt.

## Completion report

**What I built.** Staggered the reaper's requeue behind a per-tick cap so a burst of simultaneously-expiring claims drains gradually instead of dumping into `todo/` in one tick.

**Changes:**

- **`scripts/jobs/reaper.sh`** — new knob `GARDEN_REAP_MAX_PER_TICK` (default **8**) and a new section *1b* between detection and requeue. The detection loop now records each stale claim's age and reap-now status in arrays parallel to `STALE`. Section 1b splits the stale set into reap-now (kept whole) and age-expired, sorts the age-expired set **oldest-first** (`sort -k1,1nr -k2,2` — age descending, basename ascending as a deterministic tie-break), keeps the oldest `cap`, and logs the deferred count. A misconfigured non-positive cap falls back to 8 with a warning.
- **`scripts/jobs/test/reaper-requeue-cap-test.sh`** — new hermetic test (5 assertions, all passing): a 7-claim burst (basename order deliberately uncorrelated with age) drains oldest-first across three ticks with none dropped and a below-floor young claim never touched; the never-reap-earlier invariant (huge cap → floor still governs, young claim held); and reap-now cap-exemption. Existing `reaper-live-handler-guard-test` (3/3), `reaper-poison-park-test` (7/7), and `handler-orphan-reap-test` (15/15) still pass.
- **`designs/job-board.md`** — documented the staggered requeue in the reaper's stale-claim bullet.

**Chosen default (8) and reasoning.** The `garden-reaper.timer` fires every 10 minutes (`OnCalendar=*:03/10`). At cap 8 the observed 42-job backlog drains over ~6 ticks ≈ 1 hour — small waves the pool re-claims spread out, versus one herd — while still clearing even a large backlog far inside the 4h `GARDEN_CLAIM_TTL` window so nothing lingers. "A handful," per the directive.

**The never-reap-earlier invariant.** The cap sits strictly *on top of* the existing `reap_age_threshold` floor: a deferred claim simply stays in `doin/` this tick, exactly as if it had not yet aged. The cap can only *remove* items from the already-floored reap set, never add one — so nothing is reaped earlier than today's code requires. This is asserted directly in subtest 2, not assumed.

**The two interactions:**

- **Reap-now hints are cap-exempt.** A gardener stamps that hint because it *knows* the claim is dead and deliberately bypasses the TTL; such hints are event-driven (a caught transient signal), not TTL-synchronized, so they neither form the burst the cap addresses nor benefit from being held back. They are requeued this tick on top of (never counting against) the capped age-expired selection. Capping them would delay releasing a known-dead claim for no correctness gain.
- **Poison accounting is untouched.** Deferral leaves a claim's `garden-reaped: N` marker in `doin/` unread this tick, so when it is finally requeued the counter still advances by exactly one — a deferred reap cannot skip or double a poison cycle, nor let a poison job escape escalation; it is merely surfaced a tick or two later.

**Recommendation on per-base jitter: I skipped it, deliberately.** The cap already breaks the "reaped-together" property that causes re-herding — a burst is drained in cap-sized waves ~10 min apart, and the pool re-claims each wave independently, so the herd does not re-form even if all 42 cross the floor in one tick. Jitter's stated goal (desynchronize the *threshold crossing*) is therefore largely redundant with the cap's serialization of the *requeue*, while it adds a hash, another knob, more test surface, and a small but real increase in mean time-to-release for genuinely-dead claims. If future evidence shows the *same* set of jobs repeatedly co-expiring cycle after cycle (a standing correlation the cap only partially decoheres), a bounded deterministic `hash(base) mod J` added to the threshold is the right cheap next increment — but it is premature now, and the cap is the mechanism that actually fixes the observed burst.

**Note on effect.** The reaper is a leader-only singleton, so this takes effect only when the leader host deploys the new `main2`; it will not be in place for today's ~16:35 expiry burst (expected).

**Follow-ups:** none required. The reaper test scripts are standalone (not auto-globbed by `run-test.sh`); a future consolidation into a single reaper-suite runner would be nice-to-have but is out of scope here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/stagger-reaper-requeue-burst.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2859709 cached reads)
- Output: 35607 tokens
- Cost: $3.352403499999999
- Wall-clock: 793s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
