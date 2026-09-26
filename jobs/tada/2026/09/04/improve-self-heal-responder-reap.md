Job complete.

## Completion report

**Task:** Make `scripts/jobs/self-heal-run.sh` run its diagnostic responder in an isolated, tracked process group and reap it on TERM/INT/EXIT — closing the leak where a watcher/unit restart killed the wrapper but left its `claude` responder alive in the unit cgroup ("left-over process" warnings, failed watcher starts).

**What changed** (committed `ef6dbe18ed`, rebased and pushed to `main2` as `ad36c51997`):

- **`scripts/jobs/self-heal-run.sh`** — the responder now launches into its **own process group** (`set -m` + `timeout --foreground`, pgid captured from `$!`), mirroring the proven `gardener.sh` orphan-reap idiom. The wrapper sweeps that whole group — the handler **and** its `claude` grandchild — with the existing guarded `reap_process_group` helper (SIGTERM → grace → SIGKILL) on **every** outcome:
  - a fired responder timeout (which `--foreground` would otherwise leave `claude` orphaned by),
  - a clean return (fast no-op), and
  - a **stop signal to the wrapper mid-diagnosis** — a new TERM/INT trap reaps the group, then still `exit "$rc"` so systemd sees the wrapped service's real failure.
  - Added tunables `SELF_HEAL_RESPONDER_KILL_AFTER` (10s) and `SELF_HEAL_REAP_GRACE` (5s); extended the EXIT-trap `cleanup()` to sweep the group as a backstop.
- **`scripts/jobs/test/self-heal-reap-stub.sh`** (new) + **run-test.sh SUBTEST 21** — two new assertions prove **zero orphaned descendants** on both the timeout-overrun and stop-signal paths, with the wrapped rc preserved.
- **`skills/self-healing-wrapper/SKILL.md`** — documented the process-group reaping behavior.

**Verification (real execution):**
- Full `run-test.sh`: **383 passed, 0 failed**. The four new assertions all PASS (log lines 427/428/431/432): "responder timeout overrun → whole responder group reaped (ZERO orphaned descendants)", "…preserves the wrapped rc (4)", "SIGTERM to the wrapper mid-diagnosis → responder group reaped (no left-over process in the cgroup)", "…preserves the wrapped rc (5)".
- `shellcheck -S warning` clean on the production script (the CI gate covers `scripts/jobs/*.sh`); `bash -n` clean on all three files.
- Confirmed the reap logic and the new stub are present on the pushed `origin/main2` tip.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-self-heal-responder-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 122 tokens (5892229 cached reads)
- Output: 41895 tokens
- Cost: $6.354535500000002
- Wall-clock: 757s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
