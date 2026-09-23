CI is **GREEN** (rc 0 — all 25 checks passed, 0 failures). The fix stage is complete.

---

## Completion report — Gauntlet FIX round 1, PR #970

**Re-derived state on resume:** This job was double-dispatched (reaped 3×). Prior/peer attempts had already committed the bulk of the panel-1 must-fixes to the shared branch before I finished:
- `39f66f82` — stack-size pinning, batch-completeness, HTML scope-from-provenance, naming/doc/banner cleanups, baseline README correction.
- `587ddff57` — the **#1 consensus must-fix** (~15 jurors): read the *oracle's own* parse signal (`oracle_parsed`) instead of ironhorse's `bytecode` in `oracle_host_aborted` and `evaluate_negative_early`, making the early-error over-acceptance `Fail` reachable despite the `$DONOTEVALUATE()` runtime throw, and removing the obsolete `runtime-reject` outcome.

I detected the duplicate before pushing my own equivalent oracle-signal commit, so I **dropped it and rebased onto the live head** rather than force a redundant/conflicting change.

**My landed contribution (`ad5805a58`)** — the two panel findings not yet covered:
- `ironhorse_terminates_alone` now treats a worker panic (`Disconnected`) as *terminated*, not a hang — fixing the assessor/wire-watcher should-fix where a prompt panic was mislabeled a bar-forbidden `ironhorse-hang`.
- `panic_message` takes `&(dyn Any + Send)` (clippy `borrowed_box`) and is length-bounded to 200 chars before reaching the published report (typist/locksmith/warden).

All 64 lib + integration tests green locally; pushed via advance-mode CAS.

**After my push**, a peer added `cccc3f4ab` (timeout/baseline doc alignment — surfacer/archivist items). My commit remains in history (verified `ad5805a58` is an ancestor of the live head).

**CI:** watched to terminal on head `cccc3f4ab` — **25/25 checks SUCCESS, 0 failures**.

**Follow-ups for panel-2** (deliberately out of this must-fix round): the `oracle_host_aborted` residual (an empty XS error also covers `throw undefined`/`throw ''` — needs the XS abort exit status surfaced across the FFI); async-case hang attribution missing the `$DONE` prelude; the batch resume/silent-loss hardening; and PR-body/completion-summary hygiene.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-00-report-harness-foundation-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 408 tokens (37820021 cached reads)
- Output: 161242 tokens
- Cost: $27.487491500000008
- Wall-clock: 3588s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
