The temporary worktree is removed. The work is complete: the fix is committed, pushed, and draft PR #1132 is open with the gauntlet set to auto-run.

## Completion report

**Job:** Build a fix for endojs/endo-but-for-bots#1128 — withhold the ambient `@endo` power from non-root (child) hosts.

**What the issue was (verified against `llm` source):** `packages/daemon/src/host.js`'s `makeHost` put `'@endo': endoId` into every host's `specialNames` unconditionally. Since the `endo` facet's `host()` returns the root principal, any `provideHost` child could do `E(child).lookup('@endo')` then `E(endo).host()` and act as the root — making delegated child hosts full-authority peers rather than lower-trust principals. (Confirmed the maintainer's "guests" wording actually means non-root **hosts**; `provideGuest` guests never carried `@endo`, so there was nothing to remove there.)

**Fix (minimal):** The repo's HEAD (`27a892a9`, the `@secrets` confinement) had already introduced an `isRootHost` predicate. I moved `@endo` out of the unconditional `specialNames` literal and now grant it only inside `if (isRootHost)`, exactly mirroring `@secrets`. Because `specialNames` is recomputed from the host formula at every realization and never persisted, this **load-time guard also fixes already-persisted ("old") child hosts** with no migration. The root host keeps a working `@endo`.

**Changes (4 files, PR #1132, branch `1128-confine-endo-to-root-host`, base `llm`):**
- `packages/daemon/src/host.js` — the guard + explanatory comment.
- `packages/daemon/test/endo.test.js` — 3 new tests (child rejects `@endo` via has/lookup/identify; root still resolves `@endo` and reaches itself via `E(endo).host()`; guest unchanged) and updated the existing "only the root host manages secrets" test, which had *documented* the now-closed escape hatch.
- `designs/daemon-secret-manager.md` — updated the trust-model note (withholding `@endo` was listed there as the deferred prerequisite for per-principal secrets).
- `.changeset/daemon-confine-endo-to-root-host.md` — new changeset (`@endo/daemon: minor`).

**Verification:** daemon lint clean (0 errors); full `endo.test.js` passes **237/237**; `channel.test.js` (heavy `provideHost` user) passes. One apparent mount-test failure during iterative runs was traced to stale `tmp/` symlink state (`EEXIST`), not the change — it passes on a clean tree. (Aside: the sandbox worktree path exceeds the Unix socket-path limit, so tests must run from a short path under the garden mount; noted for any follow-up.)

**Follow-ups:** none required — the draft PR auto-runs the gauntlet. The secret-manager design still lists per-principal secret partitioning (owning-principal column) as remaining work, now that its `@endo` prerequisite is satisfied.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-issue1128-omit-endo-child-hosts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 248 tokens (13192774 cached reads)
- Output: 70930 tokens
- Cost: $9.944309000000002
- Wall-clock: 3220s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
