All done. The gauntlet sandbox is restored clean and my inbox is empty.

## Completion report — `xst-latest-test-lane`

**issue_spine:** issue-kriskowal-garden-33 · **Target:** fork PR `kriscendobot/agoric-sdk#13`, branch `xst/integrate-variant-bump` (fork-only; upstream Agoric untouched).

### What I did
Built the variant-gated `latest` test lane in `packages/xsnap` that the `xst-gauntlet` run named as the one architectural follow-up gating full validation of the **latest** (XS 16.7.1 / Moddable 5.5.0) train. Pushed as commit `2dc7ed735` (fast-forward over `04180a18d`).

Reused the completed `xst-gauntlet` worktree — fully installed at my exact branch tip with both engine binaries built — as the test sandbox, sparing a from-source Moddable rebuild. Restored it clean afterward.

### The mechanism
One documented env var, `XSNAP_TEST_VARIANT` (`legacy` | `latest`, default `legacy`), selects **both** which worker binary the tests spawn (threaded into `xsnap()` via the existing `variant` option) **and** which golden set the engine-sensitive tests assert against — plumbed through `test/message-tools.js` (`TEST_VARIANT`; `options()` now sets `variant`).

### What changed (4 files)
- `test/message-tools.js` — export `TEST_VARIANT`; `options()` sets `variant`.
- `test/xs-perf.test.js` — per-variant `meterGoldens` (legacy: compute `1_380_185`/heap `103_930`/REDOS `140`; latest: `1_300_705`/`104_407`/`127`); metering-switch off/on carries an honest `test.failing` marker under `latest` only (genuinely diverges `20_174` vs `20_196`), plain `test` under legacy.
- `test/xsnap.test.js` — snapshot-hash goldens: legacy keeps ava's byte-stable `t.snapshot()`; latest asserts its own recorded `latestGoldenSnapshotHashes` (`b403c468…`, `c91d5575…`) rather than overwriting the shared ava snapshot — honoring the test's own "special accommodation, not new hashes" guidance.
- `README.md` — documents the switch and the byte-stable default.

### Verification (real execution, Linux x64, both engines built)
- **default (legacy) lane** — `xs-perf` + `xsnap`: **33 pass / 2 skip / 0 fail**
- **latest lane** — `xs-perf` + `xsnap`: **32 pass / 1 known failure / 2 skip** (the known failure is the honestly-marked metering-switch)
- **Invariant confirmed:** the ava snapshot goldens in `test/snapshots/` are byte-identical (md5 + `git status` clean) before/after runs of *either* lane — a plain `yarn test` has zero golden churn.

A subtlety caught mid-flight: XS compute metering is **source-text sensitive**, so goldens had to be harvested from the *real* test source under each engine, not a reformatted probe. The two pre-existing *full-suite* failures (`install.test.js` `spawn yarn ENOENT`, `xsnap-eof` parent-kill timing) reproduce identically on the committed baseline — environmental, independent of this change.

Lint (0 errors) and prettier (clean) pass on all touched files.

### Delivered
- Fork branch `xst/integrate-variant-bump` advanced to `2dc7ed735`.
- Summary comment on PR #13: issuecomment-4933306591.

### Follow-ups (unchanged from gauntlet, not in scope here)
Full-chain `force:integration` on a capable host; the two environmental full-suite failures are host-config, not code.
