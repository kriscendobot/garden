No drift — remote tip equals the measured tip `d911a958947b`. All artifacts durable, inbox empty. The measurement is complete. This was measurement-only: PR #600 untouched, no commits or pushes.

---

# stage10h child 2/2 — 52-file daemon sweep re-measure — TADA

**Measured tip:** `d911a958947b8678a79ef44268620bb87d51c5fa` (branch `xs2rust-endor`, PR #600 DRAFT — untouched, no comments, no pushes). Re-confirmed as the live remote tip after the sweep — **no drift**. The prior s10f anchor tip `408ef16683` advanced by **7 engine commits** (s37 F1 Object.assign integrity, s37 F2 sort receiver-mutating comparator, 3× array gopd/ownKeys gaps, END value-stack reset, `hostGetDaemonHandle` bind). Dispatch named `12d997c9fecc`; the branch moved one further to `d911a95` by claim time. **No daemon test files changed between the tips — only the worker engine (interp.rs, compartment.rs, sidetable.rs, rust_worker.rs).** Re-measure genuinely warranted; not skipped.

**Environment:** reused short-path env `/home/kris/garden/tmp/s9r` (TMPDIR AF_UNIX limit). Synced 10 changed source files to the tip, `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, fresh `cargo build --release -p endo --bin endor` → **BUILD_EXIT=0** (endor-vm + endo recompiled). All 3 XS bundles regenerated — **byte-identical** (no JS changed). `c/moddable` clean at pin `23b4d6b0a65f`. Daemon-boot smoke context.test.js **10/10** green before the sweep.

**Outage hardening honored:** all artifacts under `~/tmp/s10h-results/` (MEASURED-TIP.txt, build-exit.txt, per-file TSV appended live, raw per-file logs, SUMMARY.md); sweep run detached via `setsid nohup`. It **survived one reaper requeue mid-run** — the detached process ran through the handler kill (finished 10:14:16Z), the resume found the sweep already advancing and had nothing to restart.

## Totals (default ava reporter — TAP crashes on timed-out tests; `--concurrency=1 --timeout=25s`, 52 files excl. endo.test.js)

| metric | s10h | stage-10 Rust anchor |
|---|---|---|
| fail | **14** | 14 |
| skip | **20** | 20 |
| hang | **1** (error-trace pin) | 1 |

## Per-file delta vs anchor — every divergent file classified

| File | Verdict | Class |
|---|---|---|
| content-store-gc-invariants (3 fail) + content-store-gc (6 fail) = **9** | UNCHANGED | daemon-side marshal decode `cannot configure property` (decodeErrorCommon) — engine-independent |
| git.test.js (**3** fail: status merge-conflicts, cherryPick noCommit, reword) | UNCHANGED | daemon-side git ops — engine-independent |
| git-remote.test.js (**2** fail: provideGitClone destMount / allowLocalFileTransport / url) | UNCHANGED | daemon-side git clone validation — engine-independent |
| **error-trace.test.js: 1 pass + 6 pending HANG** | **UNCHANGED — pin did NOT move** | same 6 tests hang (evaluate-rejection trace, @daemon stub, recent(), clear(), lookup-unknown, two-workers-collide); "host exposes a traces facet" the lone pass |
| channel.test.js: 87 pass / 0 fail / clean exit | IMPROVED READOUT (not a regression) | ran to completion under the 900s window; anchor's `hang=1` was a TAP+320s throughput undercut, not an engine hang |

Every other file: **byte-identical** fail/skip counts to the anchor. Skip=20 breakdown unchanged: channel-relay 4, invite-retention 10, iroh-network 1, ws-relay 5.

**Pass-total note:** the s10h pass total (618) differs from the `--tap` anchor (690) purely by reporter mechanics — the default reporter omits the "N tests passed" line on files that abort via failures or a timeout (content-store-gc, git, git-remote, error-trace), and channel completed instead of being TAP-cut. The **measured metrics (fail/skip/hang) are byte-identical**; the pass delta reflects no engine behavior change.

## error-trace finish-line pin status: **DID NOT MOVE**

The END value-stack reset + handleCommand registration did **not** materially change worker behavior for these tests. Identical to the s10f anchor: 1 pass ("host exposes a traces facet") + the same 6 pending-hang tests, byte-for-byte. The pin stands.

**Environment artifacts:** none of the three ruled-out classes appeared — AF_UNIX path length, uniform provisioning-race asserts, stale seeded `target/`. The short-path env + fresh rebuild was clean.

**C-XS re-run:** not performed — procedure gates it on a changed class, and **no class changed** vs the Rust anchor. C-XS anchor **530/19/20/0** stands as the reference; the Rust-vs-CXS delta (Rust 14 fail + 6-pending error-trace hang vs CXS 19 fail + 0 pending) is the pre-existing error-trace-hang divergence, unchanged.

## Finish-line statement

**No `test:rust` daemon class fails on the Rust engine at tip `d911a958947b` beyond the expected-divergence ledger.** The ledger — all pre-existing, engine-independent or a known artifact: **content-store-gc (9), git (3), git-remote (2)** daemon-side; **error-trace** 6-pending-hang finish-line pin (unmoved); **endo.test.js** self-overload throughput storm (excluded). The 7-commit stage-10h engine advance introduced **zero new daemon-class regressions**.

**Follow-ups:** none required from this measurement. The error-trace 6-test hang remains the open finish-line pin for a future round-trip child to move; it has not moved as of tip `d911a958947b`.
