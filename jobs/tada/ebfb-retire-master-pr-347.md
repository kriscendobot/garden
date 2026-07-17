Master base retired successfully. The rebase was a clean focused weave, so I proceeded (the "stale mirror — don't wedge" escape wasn't needed, but I'll flag the staleness for awareness).

---

**Completion report — `ebfb-retire-master-pr-347`**

**Task:** Retire the moving `master` base for `endojs/endo-but-for-bots#347` per the 2026-07-16 directive, following `skills/frozen-base-branch`.

**Preflight confirmed:**
- PR #347 was OPEN and targeting the live `master` branch (no prior `base_ref_changed` events).
- Base SHA taken from **upstream `endojs/endo` master** = `46d4edf3…` (short `46d4edf`), never from the fork master (`fcbb540`).

**Work done:**
- **Reused** the existing reflection branch `master-46d4edf` on the fork — it already existed and correctly points at upstream `46d4edf` (no push needed).
- Rebased the PR head `mirror/3033-ocapn-cbor` (single commit) onto upstream `46d4edf`: **clean, no conflicts** — a focused weave. New head `786d8290d5`, parented directly on `46d4edf`. The diff is intact: the two `/** @type {bigint} */` JSDoc casts on `PositiveIntegerCodec.read`/`NonNegativeIntegerCodec.read` in `packages/ocapn/src/codecs/subtypes.js`.
- Pushed head with `--force-with-lease` (lease against the old `c0f202dad3`).
- Set PR base to `master-46d4edf`.

**Final PR state:** OPEN · base `master-46d4edf` · head `786d8290d5` · 1 commit / 1 file · MERGEABLE (CI status UNSTABLE = checks running, not a conflict). The fork `master` was **not** touched.

**Staleness note for maintainer follow-up (not a blocker):** This is a long-idle mirror. PR #347 last updated 2026-05-23 (~8 weeks); its source `endojs/endo#3033` is a **draft** last touched 2026-01-10 (~6 months). The mirror head carries only a trivial un-replayed JSDoc bit — the substance of #3033 (CBOR codec) already landed on `llm` via PRs #59/#223 per the commit body — even though the PR title still reads "CBOR alternative encoding." The master base is now retired cleanly; whether this near-empty mirror is still worth keeping open is a maintainer call.

No garden (`main2`) changes were required — this job was entirely project-side.
