Completion report:

## Builder job: `@endo/hex` platform benchmark table — DONE (re-aimed per mid-job redirect)

**Deliverable:** DRAFT PR **endojs/endo-but-for-bots#580** (base `master-0594e99`, a frozen snapshot of `endojs/endo@master`).

### What happened
The job premise ("build `@endo/hex` with a Buffer tier + map-table") was **superseded by a maintainer redirect** (2026-06-30T23:41Z) that arrived in my inbox mid-job. I drained it at a checkpoint **before committing or pushing anything**, so there was no divergent DRAFT to close.

The redirect: `@endo/hex@1.1.1` already ships on the mirror's `master`; adding a Buffer/map tier to it is exactly the forbidden divergence. **Do not modify the published package.** Instead deliver the table as a **standalone benchmark report**, driving XS via `@agoric/xsnap`'s `xsnap()` export.

I had already built (and locally verified: eslint/tsc/prettier clean, 21 ava tests green across all 3 configs) a full package enhancement. I **reverted every `packages/hex/` edit** (confirmed pristine vs upstream) and re-shaped the work into a standalone report.

### What landed (5 files, `packages/` untouched)
- `benchmarks/hex-decode-codec-comparison/` — `REPORT.md` + engine-agnostic core + Node runner + XS runner (`xsnap()` export).
- `.eslintignore` — one line for the new top-level `benchmarks/` dir (also carries `/* eslint-disable */` per file; outside prettier's `packages` check, so CI-safe).

### The table (real measured data)
**Node (v22.23, V8 12.4, no native) — MB/s:** Buffer wins ≥256 B (1044/1426/1669); char-code/lut win at 8 B (251); map is *slowest* (35–55).
**XS (`@agoric/xsnap` 0.15.0 via `xsnap()`) — metered compute/decode:** **map wins every size** (467/12371/49235/786514), ~2.2–2.6× cheaper than char-code; 484-entry table amortized after ~660 B.

Both #7 premises **confirmed**: map fastest on XS, Buffer fastest on Node for non-trivial sizes. XS numbers cross-checked identical between the `xsnap()` export and a raw netstring pipe to the same worker (metered compute is deterministic).

### Notes / follow-ups
- **Node-old / native columns not separately benched**: only Node v22 (no native intrinsic) was available on the host; the report is explicit that v22 represents the "Node without native" regime and that the native tier supersedes where present (Node ≥24).
- The report surfaces `native → Buffer → map/char-code` as a candidate **upstream `@endo/hex` proposal** for a later human/boatman ferry — not a mirror edit.
- Sent a confirmation to the maintainer (via liaison) that the pivot is done and no divergent DRAFT exists.
- Cleaned up: removed the manual project worktree and scratch dirs; frozen base + head remain pushed (intended).
