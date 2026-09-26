## Assayer verdict: **FAIL — do NOT resume the schedule** (`orchestration-failed: true`)

The orphan-reap fix is **correct in source but NOT deployed**, so a resumed `xs2rust-endor-press` would still meet a leaking fleet. The resume gate must HALT.

### What I did

Independently verified the fix from sibling job `fix-handler-reap-spawned-process-group` (commit `8eb3354a7e`), building my **own** harness — not reusing the author's stubs — that spawns a 6-process endor-shaped tree (1 daemon → 1 manager → 4 `endor-xst`-style workers, uniquely tagged so I could count survivors globally in `ps`).

**Evidence — fix is effective in the landed (main2) code:**
- **Overrun path (rc=124):** BEFORE=0 → PEAK=6 alive mid-run (rc=124 wall-clock overrun confirmed) → **AFTER=0**, 0 reparented to init. PASS.
- **Poison/self-exit path (rc=7):** the true incident discriminator — handler returns on its own, no timeout kill fires. BEFORE=0 → PEAK=6 → **AFTER=0**. PASS.
- Shipped suite `handler-orphan-reap-test.sh`: **15/15 pass** (guards refuse dangerous targets; overrun and self-exit both sweep to zero).
- My harness is a **genuine discriminator, not always-green**: run against the **deployed** scripts, the self-exit path leaked **6 orphans, all reparented to `ppid=199` (`systemd --user`)** — reproducing the exact 2026-07-20/21 incident signature. (All test descendants trap-killed; host left clean — confirmed zero `ASSAY*` residue.)

### The blocker — landed ≠ deployed

The live fleet (20 gardeners) execs `/home/kris/garden/scripts/jobs/gardener.sh` — the **deployed root**, which is NOT advanced by the main2 landing (deliberate `deploy-garden.sh` only). Decisive diffs on the deployed path:
- `gardener.sh:411` still the **old foreground** `timeout --signal=TERM … "$handler_budget" "$GARDEN_JOB_HANDLER"` — no `set -m`, no `--foreground`, no background launch, no post-return reap.
- `common.sh` has **no `reap_process_group`** at all.
- md5sums of deployed vs main2 `gardener.sh`/`common.sh` differ.

A resumed press is claimed by a gardener running this deployed code, which **still leaks on the poison path** (the exact case that leaked 356 procs). Per the job's rigor rule ("if the fix is not effective on the path a resumed press would hit, FAIL"), the gate fails.

### Follow-ups (required before the schedule may resume)
1. **Deploy the fix** to the garden root via the deliberate drained `deploy-garden.sh` (liaison/`garden-upgrade-monitor`), advancing `/home/kris/garden` to include `8eb3354a7e`.
2. **Re-assay after deploy:** confirm deployed `gardener.sh`/`common.sh` carry `reap_process_group` + `set -m`/`timeout --foreground`, then re-run the poison-path check against the deployed scripts to see ZERO survivors.
3. Only then resume `xs2rust-endor-press`.

No code changes were made (this is a verification job); nothing to commit or push. Working tree clean.

**orchestration-failed: true**
