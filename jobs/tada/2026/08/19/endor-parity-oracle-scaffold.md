The job is complete. Let me write the completion report.

---

## Completion report — `endor-parity-oracle-scaffold` (Increment 0)

**Re-derivation:** Fresh worktree off `origin/main2`; the prior attempt had committed nothing. The parity **manifest** existed on the PR head branch `feat/endor-run-entry-point-deps` (commit `09e5736da`, the earlier manifest job), but no Increment-0 substrate. Treated as a clean build.

**Delivered** (committed `253d90dba`, pushed to `endojs/endo-but-for-bots` branch `feat/endor-run-entry-point-deps`):

- **`rust/endo/tools/gen-parity-golden.mjs`** — harness-free node reference oracle. Imports `@endo/compartment-mapper` directly (via `mapLocation`, avoiding `@endo/zip` which isn't hoisted to the workspace root) and serialises a stable *structural* projection — compartments by name, per-compartment module specifiers, parser language per module — to `fixtures-<name>/expected-compartment-map.json`. Deterministic; `--check` fails on drift; verified idempotent across re-runs.
- **Structural diff** — `exercised_fixtures_match_node_golden` replaces the compartment-*count* assertion with a full structural diff of the walker's projected output against the committed golden. Verified non-vacuous (corrupting a golden fails the test).
- **Two-tier exclusions** — `Exclude` split into `PendingExclude { capability }` and `DurableExclude { reason }`. The seven §3 durable excludes plus `error-handling` → 8 durable; the remaining 25 pending, each tagged by capability group A–G.
- **Ratchet floor + scoreboard** — `EXERCISED_FLOOR = 7` anti-backslide gate; `scoreboard` test prints **`7 exercised / 25 pending / 8 durable (of 40)`**.

**Gate met:** suite green (5/5), golden regeneration deterministic, scoreboard prints the tally. No fixtures graduate. `cargo fmt` clean on the changed file; `rust/` is eslint-ignored and `*.json` is prettier-ignored, so the new files don't trip lint.

**One documented deviation (not a gate failure), worth flagging for later increments:** 2 of the 7 exercised fixtures cannot use a node golden and carry an `endor-baseline` golden instead:
- `stack` — no `package.json` boundary, so compartment-mapper's upward `search` resolves the entry into the enclosing (version-bearing) `@endo/compartment-mapper` package rather than a standalone graph.
- `no-name` — compartment-mapper *throws* on the nameless dependency (its own `test/no-name.test.js` asserts this); endor extends support via a directory-basename fall-back.

The generator re-verifies these divergences hold on every run. Two projection canonicalisations keep the other 5 green against node: compartments keyed by name (not the version-suffixed id — endor defaults absent versions to `0.0.0`), and ambiguous `.js` modules recorded as language `"js"` (mjs-vs-cjs classification depends on package `type`, which endor's extension-only classifier doesn't yet read — deferred to the CommonJS/dep-classification increments). Both are documented in-code; the golden-diff fidelity is itself ratchetable as endor's conventions converge to node's.

**Local-build note (not committed):** endor needs the gitignored Moddable `xs/` sources (`git submodule update --init --depth 1 c/moddable`, pin `23b4d6b0`) and empty `xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` stubs — both left untracked, as instructed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-parity-oracle-scaffold.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 156 tokens (10285472 cached reads)
- Output: 103081 tokens
- Cost: $9.626969 (2 engagement(s) unpriced)
- Wall-clock: 1531s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
