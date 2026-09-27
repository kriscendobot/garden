The work is complete and pushed to `main2`. Here is my report.

---

## Completion report: `fix-worktree-sweeper-leader-only-misgating`

**Root cause confirmed.** `garden-worktree-sweeper.service` carried `ExecCondition=is-main-host.sh`, so on every follower the oneshot was skipped every tick (`Result=exec-condition`) while the garbage it collects — `gardener-wt-*` / `project-wt-*` checkouts and garden-root worktrees — is **local to each host**. The timer fires everywhere; only the gate blocked execution. A leader has nothing to do on the fleet's behalf here.

### What I changed (commit `f92ecdb0a3f`, pushed to `origin/main2`)

1. **Ungated it (task 1).** Removed the `ExecCondition=is-main-host.sh` from `garden-worktree-sweeper.service`; it now runs on every host like `garden-sysop` and `garden-state-clone-keeper`. Rewrote the misleading "root-repo worktree administration is leader-owned" comment and the `worktree-sweeper.sh` header ("leader-only" → "per-host, runs on EVERY host") with the rationale. Verified nothing in `worktree-sweeper.sh` consults the leader marker or assumes singleton execution — the journal clone is read-only terminal-record enumeration, and every removal targets this host's own `$GARDEN_SCRATCH`/`$GARDEN_ROOT`; two hosts never contend.

2. **Audited the primary path (task 2).** The primary path is host-local-correct: `complete-job.sh` (doin→tada) and the reaper's doom cleanup (`reaper.sh:1455`) both call `cleanup_terminal_project_worktrees` on the filesystem where the terminal event lands. **No separate primary-path leak.** The follower accumulation is fully explained by the missing net — and critically, **the reaper is a leader-only singleton**, so when it dooms a job whose checkout lives on a follower, its cleanup runs against the *leader's* filesystem and finds nothing; a follower's doom / crash / cross-host-requeue residue can be reclaimed **only** by the follower's own sweep. Ungating restores exactly that. Updated the stale "leader-only safety-net sweep" comment in `complete-job.sh`.

3. **Checked the cap (task 3).** `GARDEN_WORKTREE_SWEEP_MAX=100` counts actual **removals**, not candidates examined (`terminal_worktree_exists` short-circuits before the counter), so it drains any backlog monotonically over `ceil(N/100)` ticks as long as arrival rate < cap. The "exactly 100" was **coincidence** — the sweeper had never run on this follower at all, so the cap never engaged; 100 was just the accumulated count. No defect.

4. **Verified the other keepers (task 4).** `garden-clone-keeper`, `garden-state-clone-keeper`, and `garden-journal-worktree-keeper` are **already correctly un-leader-gated** (per-host garbage; `state-clone-keeper.sh` documents the rationale from the twin inode-exhaustion incidents). None needed a fix. I extended `main-host-test.sh`'s every-host list to pin `garden-state-clone-keeper`, `garden-worktree-sweeper`, and `garden-sysop`, and hardened that check to match an *executable* `ExecCondition` rather than any comment mention.

5. **Regression test (task 5).** New `scripts/jobs/test/worktree-sweeper-follower-test.sh` pins both (a) the unit carries no `is-main-host` `ExecCondition` and its timer is enabled on a follower via `install-units.sh`, and (b) `worktree-sweeper.sh` reclaims a terminal (doomed) worktree with `GARDEN` != the leader marker while preserving a live `doin/` worktree. Wired into `.github/workflows/checks.yml` (shellcheck list + focused-test run). Also updated `WORKTREES.md`.

**Verification:** `worktree-sweeper-follower-test.sh` 6/6, `worktree-teardown-test.sh` 11/11, `main-host-test.sh` 42/42; `shellcheck -S warning` and `bash -n` clean on all touched files; negative-check confirmed the static assertion catches a reintroduced gate.

### Follow-ups
- The fix takes effect on each host at its **next deploy + units reconcile** (rolling deploy re-renders the unit and reloads systemd); until then running hosts keep the old gated unit. Nothing to do manually — it flows through the normal deliberate-deploy path. I did not touch the deployed root (I ran as a follower on the affected host, `endolin-garden2-5bcdff64`).
- CPU-saturation / admission gating remains owned by `design-cpu-back-pressure-job-dispatch-20260918`; not touched here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-worktree-sweeper-leader-only-misgating-20260919.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 124 tokens (5579438 cached reads)
- Output: 34740 tokens
- Cost: $4.790259000000001 (2 engagement(s) unpriced)
- Wall-clock: 582s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
