Done. Let me summarize.

## Completion report — `fix-endo-daemon-test-teardown-leak-pr626`

**Re-derived state (clean restart):** Nothing was committed by a prior attempt (branch HEAD was still the eval commit; no PR carried the job marker). PR #626's head is `feat/agentry-eval-scenario-multifile`; its diff touches **only** `packages/agentry`. The daemon/cli shared test helpers (`_daemon-context.js`, `manager-node.js`, `index.js`) are **byte-identical on `origin/llm`** — so I confirmed this is a **pre-existing gap in the shared daemon-test lifecycle**, not specific to #626's stack-surgery changes. It recurs on every host that runs the suite.

**Root cause:** Every daemon test starts its own daemon (`start` / `endo start`), which `packages/daemon/index.js` spawns **detached + `unref()`'d** so it deliberately outlives the short-lived `endo start` call — correct for a real daemon. But when a test worker is **hard-killed before teardown runs** (ava timeout, CI/host reaper `SIGKILL`, OOM), the `afterEach`/`finally` `endo purge`/`stop` hooks never fire and the daemon survives as a PID-1 orphan. That's how ~150 `manager-node.js` daemons accumulated.

**Fix (branch `fix-daemon-test-orphan-watchdog`, PR #1049 → `llm`, ready for review):**
- `packages/daemon/src/manager-node.js`: opt-in **orphan watchdog** — when `ENDO_DAEMON_OWNER_PID` is set, the daemon polls that process (`kill(pid,0)`, 1s, `unref`'d) and shuts down gracefully via the existing `cancel()`/SIGTERM path once the owner is gone. **Inert in production** (var unset).
- `packages/daemon/test/_setup-owner-pid.js` + `packages/cli/test/_setup-owner-pid.js`, wired via each package's ava `require`: publish the worker's own pid as `ENDO_DAEMON_OWNER_PID`, which flows to every spawned daemon (through execa and past the daemon's `ENDO_`-prefixed env filter). No per-test daemon can outlive its owner even when no teardown runs.

**Verification:** End-to-end — started a real daemon with a sentinel owner, `SIGKILL`'d the sentinel, daemon self-terminated ~3s later; disarmed when the var is unset. `eslint` 0 errors, `prettier --check` clean, ava `require` wiring loads cleanly in a worker.

**Follow-ups:** None required. PR CI will exercise the full daemon/cli suites. The fix targets `llm` so it benefits every gardener host, not just #626.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-daemon-test-teardown-leak-pr626.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 130 tokens (6242433 cached reads)
- Output: 53484 tokens
- Cost: $5.635484500000001 (3 engagement(s) unpriced)
- Wall-clock: 877s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
