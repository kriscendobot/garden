CI is GREEN against my pushed head `bd7e57aa0b8` (17 success, 15 skipped, 0 failed). The job is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1304 — gauntlet FIX round 2 (read-only directory attenuation, slice 1/3 of #1125).

**What I did — applied the round-2 panel's must-fix items:**

The panel's dominant must-fix cluster (warden, saboteur, breaker, wire-watcher, engine-realist, purist) was that `EndoDirectory.readOnly()` minted a fresh worker per call and pinned it with no release path — a holder of `makeDirectory` could loop `readOnly()` into unbounded, unreclaimable worker + formula growth. I **converted the view from a worker-hosted `eval` formula to a plain local in-daemon exo**, minted through a new shared `makeReadOnlyDirectoryView()` factory that the mailbox and message hub views now also use. This structurally eliminates the amplification vector (no worker, no formula, no pin) and retires the forgeable `isReadOnlyDirectoryFormula` recognizer that shipped ahead of any consumer (locksmith/wire-watcher/breaker).

Also addressed:
- **typist:** `ReadableNameHub` referenced via the top-of-file `@import`, no inline `import()` types.
- **fast-checker / corner-prober:** null-prototype `help` fallback and five-method guard rejection now unit-tested directly against the factory (no daemon fork) in the renamed `directory-read-only-view.test.js`.
- **prover:** all three read-only views share one unit-tested factory, so a per-view binding bug is structurally impossible.
- **pruner:** changeset trimmed to summary + the shallow-attenuation caveat.
- **spec-keeper:** mutator-rejection assertions now pin "no such method" by name.
- **warden / purist:** all three views share one `ReadableNameHub`-specific `help`; none self-describes as the full `EndoDirectory`.
- **curator / migrator / spec-keeper:** `types.d.ts` now documents the async-vs-sync divergence from `EndoMount.readOnly()` and its rationale.
- **locksmith / wire-watcher:** `types.d.ts` states the reachability condition (self/ancestor references) under which the shallow narrowing is void.
- **integrator:** PR body rewritten to the repo template (Refs / Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade).

**Files changed:** `directory.js`, `manager.js`, `interfaces` usage, `types.d.ts`, `help.md` (+ regenerated `help-text-data.js`), changeset, `endo.test.js`, and the renamed `directory-read-only-view.test.js`.

**Verification:** daemon `tsc` clean, root `tsc -p tsconfig.json` (checkJs) clean, eslint clean, the 4 new unit tests pass. The first push went RED on CI `lint` — a **Prettier** `--check` failure on three files; I ran `prettier --write`, re-verified types/tests, and pushed the format-only fixup (`bd7e57aa0`). Daemon-fork integration tests can't run in-sandbox (socket-path ENOENT limit; the untouched `mount readOnly()` test fails identically), so they were covered by code reasoning + CI.

**Result:** fix pushed to PR head `bd7e57aa0b8`; CI terminal **GREEN** (32 checks, 0 failed). Stopped without re-running the panel, per stage contract — the driver re-posts panel-3.

**Follow-up for a later #1125 slice:** if network discovery needs a first-class formula identity for the read-only view, introduce it in the slice that consumes it (not shipped here).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 320 tokens (21133596 cached reads)
- Output: 87806 tokens
- Cost: $15.984039000000001
- Wall-clock: 2244s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
