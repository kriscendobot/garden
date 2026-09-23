CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #988 (`design/daemon-commit-formula`, a design-doc PR).

**What I did:**
- Checked out the PR head from its fork owner (`kriscendobot/endo-but-for-bots@design/daemon-commit-formula`, head `556630f48`) into an isolated per-job worktree. (The head is on the fork, so the base-repo path in the older job body failed the fetch; used the fork owner per the recent `fix(gauntlet): check out fork PR heads from their owner`.)
- Read the panel-4 verdict (all request-changes jurors) and applied every must-fix item to `designs/daemon-commit-formula.md`:
  - **skeptic** — lenient actor-line ingest: `GitActor` parsed fields made optional; a non-conforming actor line now preserves `rawBase64` verbatim with parsed fields absent (matching `git fsck`'s accept-with-warning) instead of whole-object rejection; prose + Test Plan bullet rewritten. Added a nonstandard-header-order round-trip test bullet exercising `headerOrder`.
  - **decomplector** — dropped the per-call `format` argument from `computeOid`; object format is now fixed at store construction from the partition; memoization step and Open Questions updated.
  - **ergonomist** — renamed `FormulaGitObjectStore.resolve` → `resolveTerminal` (removing the overload with `FormulaRefStore.resolve`); `ingestObject` now returns `{ path, oid }` so the round-trip is type-discoverable.
  - **critic** — scoped Phase 2's `resolveTerminal` to direct (empty-path) formula targets and named Phase 3 as the first phase requiring namehub-interface-unification (phase order now matches where the dependency is invoked); justified each method's contract under Strategy A via raw-object intern formulas; clarified daemon-git-remotes is a contrast, not a graph edge.
  - **copyeditor** — eliminated the overloaded "CAS" abbreviation (spelled out compare-and-swap / content-addressed at each use); fixed parallel structure in the dangling-ref condition.
  - **pedant** — wrapped all prose to ≤100 columns (only unavoidable single-URL links and Markdown table rows remain longer); italicized the `*partition*` first-use definition for typographic consistency.
  - Plus the cheap novice should-fixes: disambiguated "this repo," added the § Object formulas forward pointer, linked the RefStore contract.
- Committed as a review-feedback follow-up and pushed via `safe-push-pr-head.sh` (`556630f48..a3f175f77`, advance mode, no rewind).
- Watched CI bounded: **rollup GREEN, 5 checks, 0 failed.**

**Changed:** `designs/daemon-commit-formula.md` (+427/−143), one commit `a3f175f77`.

**Follow-ups:** None from this stage. The driver re-posts panel-5; I did not re-run the panel per instructions.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr988-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (2096446 cached reads)
- Output: 31214 tokens
- Cost: $2.695634
- Wall-clock: 1400s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
