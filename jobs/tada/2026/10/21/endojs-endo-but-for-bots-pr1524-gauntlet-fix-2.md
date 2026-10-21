# Gauntlet fix round 2: endojs/endo-but-for-bots#1524

I applied the panel's must-fix items, pushed three commits to the PR head, and CI is green (35 checks, 0 failed). I could not retitle the PR: this host's PAT lacks PR write on endojs (403).

The job had no deterministic pre-pass block, so I worked from the latest panel verdict (review 5605718197, "Must-fix before merge", 2026-10-21T20:21Z). I pushed `71cdb7b54..2eff08001` to `daemon-debug-worker-restart-phase-2` with `safe-push-pr-head.sh`.

## Commits
1. **`70d5a1dab` fix(daemon): debug session records `<login>` receipt.** Answers typist. `waitForLogin()` now tracks a `loggedIn` flag, so a `<login>` that arrives without attributes still resolves later calls immediately.
2. **`345e6f9a5` fix(daemon): `debugWorker` rejects workers that cannot resume under the debugger.**
   - **Process workers no longer hang.** Raised by assessor, curator, saboteur, breaker, spec-keeper, wire-watcher, engine-realist and corner-prober. Before, `debugWorker()` waited forever on a `node` or `separate` worker.
     - When `debug-flag` carries a nonce, the supervisor now replies. It sets the flag and answers `debug-flagged` only for a shared (in-process) XS worker. It answers `error` for any other platform, for a store-backed worker, or for an unknown handle.
     - The new `Supervisor::arm_debug_flag` makes that check. A `debug-flag` without a nonce still behaves as before.
     - The restart order is now flag → suspend → ping, so an unsupported worker is rejected before anything suspends it.
     - A new `debug-unflag` verb withdraws the flag if the suspend then fails.
   - **Concurrent calls (saboteur, breaker, corner-prober):** a handle is reserved before the first `await`. A second call on the same worker gets an "already restarting" error.
   - **Reply correlation (saboteur, wire-watcher):** a reply must match the expected source handle (supervisor `0` or the target worker) as well as the nonce.
   - **purist:** `debugFlag` is no longer exposed on `controlPowers` or in the types. Raw `Error` construction is replaced with `makeError`/`X`/`q`.
   - **Handle range (spec-keeper, corner-prober):** `encodeHandleRequest` now covers every positive safe integer, including the 8-byte CBOR form. The narrowing from Rust's `i64` is documented.
   - **stylist:** renamed `buf` → `bytes`, and `sup`/`msg` → `supervisor`/`message` in `forward_to_manager`. In the tests, `opts`/`n`/`dbg` are spelled out; `dbg` became `workerDebugger` because `debugger` is a reserved word.
   - **Tests:**
     - CBOR boundary vectors and invalid inputs.
     - Rejection of `separate` and `node` workers with no suspend sent.
     - Flag withdrawal when the suspend fails.
     - Concurrent calls.
     - Replies from the wrong source.
     - A `<login>` with no attributes.
     - A Rust unit test for `arm_debug_flag`.
     - Removed the file-level comment the pruner flagged.
3. **`2eff08001` docs(daemon): `debugWorker` supports only shared XS workers.**
   - The help text, `help-text-data.js` and the types now say that only shared XS workers are supported and that other workers are rejected (archivist).
   - The public parameter name is `workerNameOrPath` everywhere (stylist).
   - The changeset is one sentence on one line (changeset-auditor).
   - The design's duplicated implementation summary is trimmed and the Phase 2 checklist matches the new order (pruner).
   - The `designs/README.md` index row is updated (integrator).

## Verification
- Daemon `debug-worker-restart` tests: 9 passed. ESLint shows no new warnings; I saw no `tsc` errors in the changed daemon files (output filtered to those files).
- `cargo test --lib supervisor::tests`: 5 passed. Clippy is not installed on this host, so I didn't run it; CI is green.
- The XS manager bundle (`daemon_bootstrap.js`) builds.

## Not done, or follow-ups
- **Process workers can't use the feature at all.** The XS manager never sends a platform when it spawns a worker, so the Rust supervisor treats every manager-spawned worker as `separate`. In practice, `debugWorker` now rejects every worker cleanly instead of hanging. Making it usable needs the manager to spawn shared workers, or debugger support across the process boundary.
- **PR title:** the integrator's request to drop "(debug worker restart, Phase 2)" failed with the 403 above. It needs a host with PR write access. I also didn't trim the PR body (pruner, comment-only).
- **End-to-end tests (prover, coverage-auditor):** an XS test through `EndoHost.debugWorker` against the real Rust supervisor is not added. That harness doesn't exist; this needs its own job.
- **fast-checker:** the property test with a new `fast-check` dev dependency was marked follow-up by the juror and is not done.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1524-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (5970966 cached reads)
- Output: 35088 tokens
- Cost: $2.926233200000001
- Wall-clock: 2902s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
