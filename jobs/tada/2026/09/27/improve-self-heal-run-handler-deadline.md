The work is complete and pushed to `main2` (commit `773813fb50`). The inbox drain skipped cleanly (offline — the same degraded-connectivity class this change addresses); nothing pending.

## Completion report

**Job:** Bound the wrapped-handler invocation in `scripts/jobs/self-heal-run.sh` with its own `timeout`, mirroring the responder, so a wedged handler is felled well inside each unit's `TimeoutStartSec` instead of riding systemd's blunt job-timeout + SIGKILL backstop.

**What I did**

1. **`scripts/jobs/self-heal-run.sh`**
   - Added two tunables: `SELF_HEAL_HANDLER_TIMEOUT` (default **600s**, comfortably below the 900s watcher `TimeoutStartSec`) and `SELF_HEAL_HANDLER_KILL_AFTER` (default 20s). `0`/empty/`none`/`infinity` disables the bound.
   - Wrapped the handler at (former) line 104 in `timeout --signal=TERM --kill-after=… <bound>` when enabled and `timeout` exists, tracking `handler_timeout_applied`. Confirmed empirically that GNU `timeout` **forwards** a received SIGTERM to the child, so the existing clean-shutdown (systemd-stop) path is unchanged.
   - Classified a resulting **rc=124** (timed out, TERMed) or **rc=137** (SIGKILLed after the grace) as a CLEAN exit 0 — no responder burn, no `Failed` unit — placed right after the `is_nonattributable_rc` normalization. Gated on `handler_timeout_applied` *and* `got_signal -eq 0`, so a handler that exits 124/137 on its own (or a genuine systemd stop) is unaffected.
   - Updated the header docs with a "Handler deadline" paragraph.

2. **Opt-outs (`Environment=SELF_HEAL_HANDLER_TIMEOUT=0`)** — the shared wrapper protects every rider by default, but I disabled the deadline for callers whose handler is a **long-lived loop** or a **legitimately long tick**, each with a rationale comment:
   - `garden-worker@.service.in` (Type=exec gardener loop — a 600s cap would fell every job mid-flight; it already bounds each job internally via `GARDEN_HANDLER_TIMEOUT`)
   - `garden-bulletin.service` (Type=exec loop), `garden-watcher@.service` (Type=simple loop)
   - `garden-ironhorse-fuzz.service` (3600s), `garden-root-repo-guard.service`, `garden-state-clone-keeper.service`, `garden-worktree-sweeper.service` (1800s each)

3. **`skills/self-healing-wrapper/SKILL.md`** — added a "Handler deadline" bullet documenting the tunables, the rc=124/137 clean classification, the opt-out guidance, and the grounding incident.

4. **`scripts/jobs/test/run-test.sh`** — SUBTEST 21 cases (11)–(13): a wedged handler felled at the deadline (rc=124) and a TERM-ignoring one SIGKILLed after the grace (rc=137) both exit clean with zero responders; `=0` disables the deadline while leaving the normal failure/diagnosis route intact.

**Verification**
- `bash -n` clean on both scripts; `shellcheck -S warning` clean on `self-heal-run.sh`.
- Ran all three new scenarios plus three regressions (clean exit, SIGTERM mid-run, genuine failure) against a throwaway journal with the real responder stub: rc=124→exit0/0 responders, rc=137→exit0/0 responders, `=0`→rc6/1 responder, clean→0/0, SIGTERM→0/0, failure→3/1. All as asserted.

**Design note (why not a blanket 600s everywhere):** the incident-class services are fast network-bound oneshot watchers for which 600s is ample, but several riders legitimately run longer (the Type=exec worker loop most critically — a 600s cap would tear the pool down since Type=exec treats the normalized exit 0 as success and won't restart). Hence default-on with explicit opt-outs for loops/long-compute, documented so a future long-running unit knows to opt out.

**Follow-ups:** none required. The 600s default may occasionally cut short a pathological 600–900s single LLM tick on an LLM-invoking watcher (mentor self-bounds its own claude; gauntlet is no-`claude`); this fails open cleanly to the next cadence rather than the prior 900s `Failed`/SIGKILL, so it's a net improvement — flagging only for awareness.

(Aside: the initial `git rebase` onto the freshly-advanced `main2` landed in a stuck interactive-edit state twice; recovered by aborting and cherry-picking the single commit onto `origin/main2`, then pushed clean on the first attempt.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-self-heal-run-handler-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 110 tokens (6950255 cached reads)
- Output: 54403 tokens
- Cost: $6.461962500000001 (2 engagement(s) unpriced)
- Wall-clock: 1201s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
