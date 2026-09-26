The work is complete, verified, and landed on `main2`.

## Completion report

**Job:** Fix the hourly `garden-regenerate-sections-index.service` failure — two instances (`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`) run the timer at the same `*:37` minute, so the loser's `BASE_BLOB` goes stale before `land-journal-edit.sh` syncs the producer clone and the base-blob guard refuses (exit 1), Failing the unit and burning a self-heal diagnosis cycle every hour on both hosts.

**What I changed** (`scripts/jobs/regenerate-sections-index.sh`, `land)` branch):

1. **Compose-and-land retry loop.** Wrapped `sync_clone → generate_auto_index → current-check → land-journal-edit.sh` in a bounded loop (default 4 attempts, overridable via `GARDEN_SECTIONS_INDEX_LAND_ATTEMPTS`, `backoff` between passes). On the lander's conflict exit (rc=1) it re-syncs and re-composes against the new tip; the next pass normally hits the `already current; nothing to land` branch and exits 0, because the peer landed the same deterministic projection. Only a conflict surviving every attempt exits non-zero (a real non-idempotent divergence). Never uses `--force`. The lander's rc is captured *directly* — not via `if lander; then …` (which reports rc=0 for a failed lander, a bug my functional test caught) — so a hard rc=2 refusal exits immediately, rc=75 propagates, and the generator's own `die`/rc=2 failures are not swallowed by the retry.

2. **Killed the broken-pipe noise.** Compose `$out` to a temp file once per pass, reused for the `diff -q` current-check and passed to the lander as its `<body-file>` argument. This removes both SIGPIPEs the old `diff -q <(printf …)` + stdin-pipe pattern logged (`printf: write error: Broken pipe`) on every stale/refused run. Cleaned up via a `trap … EXIT`.

3. **Optional hardening** (`scripts/systemd/garden-regenerate-sections-index.timer`): added `RandomizedDelaySec=300` to spread the fleet's `:37` wakeups inside `:37–:42`, still clear of the sibling library cadences (`:00/:30`, `:07`, `:22`), with the `:37`-anchor reasoning preserved. Documented that it only narrows the ~15s collision window and is not a substitute for the retry loop.

**Verification** (throwaway-journal functional tests; `/tmp` is `noexec` so scratch ran under the worktree): stale→lands (no broken pipe); idempotent re-run→no-op; `--check`→exit 0; **conflict-retry→re-sync→converged to already-current→exit 0** (with a shim lander simulating the peer race); exhaustion→4 attempts→exit 1, no `--force`; lander rc=2→immediate exit 2, not retried. `bash -n` and `shellcheck` clean on the new code; timer calendar validated.

**Landed:** commit `1ced89988d` on `origin/main2` (rebased cleanly over the concurrent `land-journal-edit.sh` shared-index-guard change, which scopes to four *other* files and does not touch `library/sections/README.md`).

**Follow-ups:** None. The timer's `RandomizedDelaySec` takes effect on running instances only after the next deploy's `daemon-reload`/units reconcile — normal deploy path, no action needed here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-regenerate-sections-index-land-cas-conflict-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1976274 cached reads)
- Output: 33088 tokens
- Cost: $2.7299130000000003
- Wall-clock: 574s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
