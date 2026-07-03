---
model: opus
---
# garden-infra: reaper — don't count PRODUCTIVE requeue cycles toward the poison threshold

**Garden-infra on `main2`** (isolated worktree off `origin/main2`; `git -C` discipline; explicit-pathspec commit; push `HEAD:main2`).

## Problem (surfaced by the xs2rust press-driver, 2026-07-03)

The reaper poisons a job after 5 requeue cycles on the assumption that a handler "fails every time." But a **long builder on the sanctioned resume treadmill** — the "push green commits, exit WITHOUT the completion signal before the ~2400s handler wall, resume next claim" pattern many big jobs mandate — trips the same counter even though **every cycle lands real progress**. Today `xs2rust-endor-build-stage3-arrays` was false-poisoned this way (HEAD advanced `57c3a56 → 52464aa → 5063124` across the "failing" cycles; a DNS outage burned extra ones); the press-driver had to hand-restore it. The threshold cannot distinguish a productive long job from a genuinely failing one.

## Fix

Make the poison threshold count only **NON-productive** cycles. A requeue cycle is **productive** if the handler made real progress that cycle — e.g. it pushed commits to the job's branch / the job's tracked HEAD advanced, or it exited via the sanctioned resume pattern (a recorded "pushed-work / resume, not failure" signal) rather than a hard error/timeout with no work.

Concretely (verify the real mechanism in `scripts/jobs/reaper.sh` + the gardener handler `scripts/jobs/handlers/gardener-claude.sh` + `common.sh`, then choose the cleanest):
- Have the handler record a **per-cycle productivity signal** (e.g. a marker / journal note when it pushed commits or exited via the resume pattern), and
- Have the reaper **reset or not increment** the requeue/poison counter for a cycle flagged productive, so only cycles with **no progress** accumulate toward the poison drop.
- Preserve the genuine-failure case: a job that truly fails every cycle (no commits, hard error) still poisons at the threshold.

Keep it minimal and well-tested: a job that pushes work each cycle never poisons; a job that fails with no progress each cycle still poisons at 5.

## Definition of done

The reaper no longer poisons a job whose handler is making real per-cycle progress (the resume-treadmill false-positive class is gone), while genuinely-failing jobs still poison at the threshold. Cited test/repro per `garden/roles/COMMON.md` § Reporting. Land on `main2`; journal a `result`. Activates on the fleet after a deploy.

---
claim:
  host: endolinbot2
  gardener: 16
  claimed_at: 2026-07-03T11:29:03Z
