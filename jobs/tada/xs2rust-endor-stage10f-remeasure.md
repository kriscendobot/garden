The re-measure is complete. All artifacts are durable under `~/tmp/s10f-results/`, nothing was committed or pushed (measurement-only), and every class matches the stage-10 Rust anchor.

---

# stage10f child 3/3 — 52-file daemon sweep re-measure — TADA

**Measured tip:** `408ef16683e8aefa7f6c309162c798c9090d3f32` (branch `xs2rust-endor`, PR #600, DRAFT — untouched, no comments). Re-confirmed as the live remote tip after the sweep — no drift. Prior s10e tip `5e26986bd3` advanced by 15 stage-10d/e/f engine commits (interp.rs "runtime-interned string keys are name-resolvable" is the tip commit); the re-measure was genuinely warranted. **No daemon test files changed between the two tips — only the worker engine.**

**Environment:** reused short-path env `~/tmp/s10e` (AF_UNIX limit). Synced its 14 changed source files to the tip, `cargo clean -p endor-compile -p endor-vm -p endor-oracle` then fresh `cargo build --release -p endo --bin endor` (endor-vm + endo recompiled, BUILD_EXIT=0), all 3 XS bundles regenerated, `c/moddable` clean at pin `23b4d6b0a65f`. Daemon-boot smoke (context.test.js) 10/10 green before the sweep.

**Outage hardening honored:** all artifacts under `~/tmp/s10f-results/` (measured-tip.sha, per-file TSV appended live, raw logs, SUMMARY.md); sweep run detached via `setsid nohup`. It survived **two reaper requeues** mid-run without loss — the detached process ran to completion (finished 07:20:30Z) independent of the handler kills.

## Totals (per-file sweep, `--concurrency=1 --timeout=25s`)

| Scope | pass | fail | skip | pending |
|---|---|---|---|---|
| All 52 files | 765 | 91 | 65 | 102 |
| Excl. endo.test.js (storm artifact) | 760 | **14**\* | **20** | **6** |
| **stage-10 Rust anchor** | — | **14** | **20** | **6 + error-trace hang** |
| C-XS anchor (reference, not re-run) | 530 | 19 | 20 | 0 |

\* The raw excl-endo fail count is 15; one is error-trace's `✘ Timed out while running tests` pseudo-mark (the 6-pending-hang manifestation), not a real test. Real daemon failures = **14, matching the anchor exactly.**

## Per-file delta vs stage-10 Rust anchor — every divergent file

| File | Verdict | Class |
|---|---|---|
| content-store-gc-invariants (3 fail) + content-store-gc (6 fail) = **9** | UNCHANGED | daemon-side marshal decode `cannot configure property` — engine-independent |
| git.test.js (**3** fail: cherryPick noCommit, status merge-conflicts, reword) | UNCHANGED | daemon-side git ops — engine-independent |
| git-remote.test.js (**2** fail: provideGitClone ×2) | UNCHANGED | daemon-side git clone — engine-independent |
| **error-trace.test.js (finish-line pin): 1 pass + 6 pending HANG** | **UNCHANGED — pin did NOT move** | same 6 tests hang (evaluate-rejection trace, @daemon stub, recent(), clear(), lookup-unknown, two-workers-collide); "host exposes a traces facet" is the lone pass |
| endo.test.js: 5/76/45/96 (s10e was 83/72/45/22) | KNOWN ARTIFACT | self-overload harness-throughput storm |

Every other file: **byte-identical** pass/fail/skip counts to the s10e baseline. skip=20 breakdown unchanged (channel-relay 4, invite-retention 10, iroh-network 1, ws-relay 5).

**endo.test.js classification (rigorous):** all 76 fails + 96 pendings are timeout-cascade `Rejected promise returned by test` — **zero** clean assertion failures (grep for Difference/expected/deepEqual = 0). Completing tests take 8–10 s each (worker spin-up); ~217 tests ≫ the 180 s self-overload-bounding outer budget, so it always storms. The 83→5 pass swing vs s10e is pure timing noise in how many tests finish before the pending-timeout cascade (skip=45 stays stable). Not an engine regression.

**Environment artifacts encountered:** none of the three failure classes (AF_UNIX path length, provisioning-race asserts, stale seeded target/) — the short-path env + fresh rebuild was clean. One incidental note: error-trace ran at load1=352 (heavy concurrent fleet load mid-sweep), yet still produced the identical 1-pass/6-hang result, reinforcing that the hang is deterministic, not load-induced.

**C-XS re-run:** not performed — procedure gates it on a changed class, and **no class changed** vs the Rust anchor. The C-XS anchor 530/19/20/0 stands as the reference; the Rust-vs-CXS delta (Rust 14 fail + 6 pending vs CXS 19 fail + 0 pending) is the pre-existing error-trace-hang divergence, unchanged.

## Finish-line statement

**No `test:rust` daemon class fails on the Rust engine at tip 408ef16683 beyond the expected-divergence ledger.** The ledger, all pre-existing and either engine-independent or a known harness artifact: **content-store-gc (9), git (3), git-remote (2)** — daemon-side, engine-independent; **error-trace** 6-pending-hang finish-line pin (unmoved); **endo.test.js** self-overload throughput storm. The stage-10f engine advance introduced zero new daemon-class regressions.

**Follow-ups:** none required from this measurement. The error-trace 6-test hang remains the open finish-line pin for a future round-trip child to move; it has not moved as of this tip.
