CI is fully green (27/27 SUCCESS) on the current PR head `7ebb7c85`. The branch was rebased and the panel-fix commit is present (`e85632df5b fix(daemon): address hashline panel round 1 must-fix items`), plus a follow-on crc32 refactor. All must-fix items are in the branch and CI is green. The fix stage is complete.

---

## Completion report — Gauntlet FIX round 1, endojs/endo-but-for-bots PR #796

**Status: fix pushed, CI GREEN.**

This attempt resumed after repeated reaper requeues. Re-deriving from committed history and the journal, I found a prior attempt had **already committed and pushed the panel round-1 fixes** to the PR head — so no re-work was needed on the code. My work this run was to drive CI to a terminal green result.

**Panel round-1 must-fix items — all addressed** (commit `fix(daemon): address hashline panel round 1 must-fix items`, now `e85632df5b` after a rebase):
1. **Blank-line anchor seed / bare-digit collision** (saboteur, purist) — blank seed now carries a leading `\n` (`\n${lineNumber}`), a byte content lines can never hold, making the blank-seed hash space disjoint from all content and closing the deterministic collision.
2. **`ambiguous-reapply` dropping the coexisting `mismatches`** (assessor) — the failure payload now carries `mismatches` alongside `ambiguities`.
3. **Inline JSDoc typedefs** (typist) — the nine hashline typedefs moved to `packages/daemon/src/types.d.ts` and `@import`ed back.
4. **PR title/body omitting `@endo/crc32`** (integrator) — title and body now name the `@endo/crc32` extraction.

Cheap should-fix items also landed: `validateEditOp` single-reads each untrusted property; `@endo/crc32` declares `test:xs`. Regression tests were added for the collision and the ambiguous+mismatch coexistence.

**CI drive (my work this run):**
- First terminal result on head `3ff70e6769` was 26 SUCCESS / 1 FAILURE. The lone failure was `test (22.x, macos-15)` on the `component › heat-bar › locked single-hop…` UI test (a `@endo/space-*` package) ending in `Exiting due to SIGINT` — entirely unrelated to the hashline/crc32 diff, and ubuntu-22.x passed the same suite. I re-ran the failed macOS job to clear the flake.
- The branch was subsequently rebased onto a fresh `llm` base and gained one follow-on commit (`refactor(crc32): read bytes through the .at protocol (#796)`); current head is `7ebb7c8563`.
- Final CI on the current head `7ebb7c8563`: **27/27 checks COMPLETED/SUCCESS, zero failures/pending.**

**Follow-ups:** none for this stage. Panel-only should-fix/follow-up items (native-width reapply confirmation, `@endo/errors` in crc32 throws, `EditResult` discriminated union, designs/README crc32 table entry) remain for the driver's next panel round — not in scope for this single fix pass. Per the gauntlet contract, I did **not** re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260821-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 236 tokens (13425808 cached reads)
- Output: 68166 tokens
- Cost: $13.511524
- Wall-clock: 1854s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
