Inbox empty. Work complete.

---

## Completion report — `garden-continue-ymax0-xs-investigation`

**Outcome: investigation advanced to a decisive answer; findings posted to kriskowal/garden#9 (comment 4825160129).**

### What I did
- **Skipped the multi-hour rebuild** — the prior toolchain survived the redeploy (contrary to the job's assumption): the instrumented `xsnap-worker-rw`, both two-worktree builds, and the bundle were all intact. Verified the instrumented worker still reproduces the overflow trace.
- Established the width baseline by re-running the esbuild flatten (byte-reproducible, 33 ms/build): **beta2 = 2114 top-level functor bindings, beta3 = 2146 → Δ +32**, matching the prior trace estimate.
- **Attributed the +32 bindings per-package** using esbuild's `// path` comments (in the raw outfile; stripped later by bundle-source) grouped against the `--metafile`.
- Confirmed end-to-end on the instrumented worker: same contract source (both worktrees at git `9d518832d`), **beta2 Endo → no overflow; beta3 Endo → exit 12**.
- Ran a confirmatory mixed build (base64+errors→beta3 on the beta2 base) = 2130 bindings, matching prediction.

### Key finding (overturns the job's framing)
The width regression is **not** localized to pass-style/marshal/patterns. It is **diffuse across the low-level Endo utility layer**, led by **`@endo/base64` (+10)** and **`@endo/errors` (+7)**; marshal +3, patterns **+1** (patterns grew ~6 KB of *code* but ~zero width — bytes ≠ closure slots). The ses-2.x bump is a **coordinated, non-bisectable release** (`pass-style@1.8.1` won't link without the newer `@endo/errors`).

### Feasibility assessment delivered
- Endo-side width reduction: feasible but **low-yield** (~32 slots over 8 packages, no single productive target).
- Real levers, both bigger: the **contract-side `hex.js` loop patch** (DRAFT fork #7, ~1000 slots) and the **bundling strategy** (esbuild flattens everything into one ~1986-CLOSURE-slot functor).

### Housekeeping / follow-ups
- I temporarily dirtied beta2's node_modules during single-package swap attempts; **fully restored** (base64@1.0.12, errors@1.2.13 via `npm pack`) and re-verified beta2 rebuilds to exactly 2114. Worktrees left clean.
- Updated the durable memory `reference_xsnap_xs_repro_without_agoric_build` with the per-package attribution method and result.
- All artifacts fork-internal; no upstream `agoric/agoric-sdk` links/comments.
- **One remaining blocked path (maintainer-only):** the v320 swing-store **export** for a production live-rehydration cross-check — flagged in the comment, not attempted.
