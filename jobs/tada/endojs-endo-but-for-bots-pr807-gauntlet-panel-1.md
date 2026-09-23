The panel verdict is posted as a comment review on PR #807. The panel completed in single-round mode with disposition **must-fix**, and I've stopped here as instructed (no fix, no un-draft, no loop).

## Completion report

**Job:** Gauntlet PANEL round 1 for endojs/endo-but-for-bots PR #807 (`docs(designs): reconcile tree(ref) and filesystemAt(ref) into one historical-read vocabulary`).

**Re-derivation on clean start:** Confirmed no prior attempt had posted a panel verdict (only a kriskowal comment and an empty kriscendobot comment existed). No committed work to resume — ran the stage fresh.

**What I did:**
- Resolved PR head (`endojs:docs/git-capability-reconcile-filesystem-at`, base `llm`) and created an isolated project worktree.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` against base `origin/llm`. Seven seats fanned (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice); four requested changes. Disposition: **must-fix**.
- Posted the aggregate as a `gh pr review` on PR #807. `--request-changes` is forbidden by GitHub on our own bot-authored PR, so it went as a **comment** review (the standard fallback for bot-authored PRs); the authoritative signal for the gauntlet is the stage-result marker below.

**Verdict substance (must-fix):** The doc-only PR asserts the `tree(ref)`→`filesystemAt(ref)` rename as already-shipped fact, but `origin/llm` still ships `tree(ref)` as a live method (and it's the only path to the archive fast path); the intra-file rename sweep is incomplete (Architecture diagram, Bulk Tree Data Plane, GitBackend contract still show `tree(ref)`/`ReadableTree`); the new `PlatformGit`/`treeAt`/`PinnedGitTree` capability lacks a provenance/minting story and a vocabulary-table row; plus em-dash/arrow-glyph style violations and several should-fix ergonomics/cross-reference items.

**Stopped here** — no fix, no un-draft, no loop, per single-round stage contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr807-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 45 tokens (1292850 cached reads)
- Output: 9528 tokens
- Cost: $1.443085 (3 engagement(s) unpriced)
- Wall-clock: 516s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
