Inbox empty. Work is complete.

## Completion report

**Job:** Recheck the kriscendobot/minion.town git-remote / credential resolution gap that stalled `minion-town-clip-content-store-gc-build` on 2026-09-04.

### Diagnosis

- **Root cause & classification:** This was a **per-host, expired/missing token gap**, *not* a wrapper-pin bug and *not* a fleet-wide code defect. The incident host was **`endolin-garden-ece02cb4`** (the leader). On 2026-09-04 its `kriscendobot` gh OAuth login could not be resolved (`gh auth token --user kriscendobot` returned empty), so the fleet `gh` wrapper correctly **failed closed** on `ensure-pr.sh`'s `pr create` rather than acting as the global active account. The unauthenticated REST fallback for reads was also rate-exhausted, so the read path degraded too. The wrapper behaved exactly as designed — the gap was purely credential availability.
- **Current state (verified 2026-09-12, on that same host):** the credential is **restored and healthy**. `gh auth token --user kriscendobot` resolves; authenticated rate limit is 5000/hr; `gh api repos/kriscendobot/minion.town` and `gh pr list` succeed. The originally-blocked deliverable also completed on its own: branch `feat/clip-content-store-gc` advanced (1e4e0e9 → 7374bbe44) and **PR #93 is open**. So the immediate condition is closed.
- **Fleet hosts:** two — `endolin-garden-ece02cb4` (leader, was affected, now healthy) and `endolin-garden2-5bcdff64` (follower). I cannot directly probe the follower's separate gh store from this container; the new guard below covers it automatically on its own scaler ticks.

### Fix (durable, so this stops being silent-until-a-write-trips-it)

Added a deterministic **`scripts/jobs/gh-credential-guard.sh`**, wired as a `gardener-scaler.sh` preflight that runs **every tick, host-level, on every host** (leader and follower). It checks the wrapper's own resolution path proactively and posts **one deduped `kind:error` maintainer-inbox report** (naming the exact host and the `gh auth login` remedy) on a genuine gap. Two false-positive-free conditions:
- **MISSING** — empty local token resolution; network-free, definitive, alarms on tick 1 (the exact 2026-09-04 condition).
- **REVOKED** — token present but authenticated probe returns 401/Bad credentials; persistence-gated past a consecutive-suspect threshold (default 3), since GitHub emits spurious transient 401s. Offline/inconclusive probes never alarm.

It mirrors `identity-drift-guard.sh`'s report/dedup/test-containment machinery exactly. Verified quiet against the real healthy host. Added a 21-subtest hermetic test (`scripts/jobs/test/gh-credential-guard-test.sh`, all passing) and registered it in `.github/workflows/checks.yml` (shellcheck + focused-test run). `shellcheck -S warning` clean on both new files.

**Committed and pushed to main2** (`421473a933..2ff2ca24d0`).

### Follow-ups / what needs maintainer credentials

- Nothing is currently blocked — the credential on the incident host is already restored.
- If the follower `endolin-garden2-5bcdff64` (or any future host) ever lacks a valid `kriscendobot` login, the new guard will now surface it to the maintainer inbox proactively; the remedy is `gh auth login` / `gh auth refresh` on that host (only the maintainer can supply the login) — no code change will be needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mtown-git-remote-credential-recheck-20260912.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2931732 cached reads)
- Output: 32930 tokens
- Cost: $3.236081
- Wall-clock: 459s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
