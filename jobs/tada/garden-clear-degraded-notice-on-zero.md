Inbox empty. Work complete.

---

## Completion report

**What I did:** Fixed the backend-degraded notice never clearing when a worker class is throttled to `declared=0`, and added regression coverage. Landed on `main2` as `2e9b0a33a2`.

**What changed:**
- `scripts/jobs/common.sh` (`backend_effective_count`, ~line 1230): added a `declared == 0` clearing branch between the alert branch and the recovery branch. Standing a class down to zero now **clears** the outstanding notice with distinct stand-down wording ("stood down … throttled to zero (nothing left to run) — this is a stand-down, not a backend recovery"), so the inbox never conflates a stand-down with a genuine backend recovery. The trailing recovery branch is now `elif [ "$eff" -ge "$declared" ]` (the `declared > 0` guard is redundant since the zero case is handled above). The root bug: the `else` branch resets `$degraded` (silencing the alert branch) while the recovery clear was gated `declared > 0` — so a stood-down class's notice could never fire again *nor* clear, sitting outstanding forever and re-amended every tick.
- `scripts/jobs/test/backend-autotune-test.sh` (new §3d): pins all four required cases on the worker-kind abstraction (using `mystic`). Verified **case 3 goes red without the fix** (33/36) and the whole suite is green with it (36/36). Existing §3c and the set-workers gate suite still pass.

**`alert_maintainer_clear` guard:** none needed — it already early-returns when no `.last` marker exists (`common.sh:1364`), so throttling an already-quiet class to zero raises no spurious clear. Case 4 pins this.

**Scope:** notification logic only. This is a general worker-kind fix; fireworker merely motivated it. I did **not** change any host's declared worker counts.

**Important — the current notice stays outstanding:** this fix does *not* silence the live `watchdog-backend-degraded-endolin-garden2-5bcdff64-fireworker` notice. `endolin-garden2-5bcdff64` still declares `fireworkers: 4`; the clear only fires once that host's fireworker count is actually set to 0 (a separate maintainer `set-workers` operation, out of scope here). Until then the notice remains and continues re-amending. A landed fix ≠ a quiet inbox.

**Out of scope (untouched, as directed):** `comment-watcher.sh:1602` `retro_eligible` gate; the fireworker backend itself; any worker-count change.

**Verification:** `bash -n` clean; the one shellcheck SC2261 error is pre-existing at line 2416 in an unrelated function, not introduced by this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-clear-degraded-notice-on-zero.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (839658 cached reads)
- Output: 12595 tokens
- Cost: $1.2929320000000002
- Wall-clock: 198s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
