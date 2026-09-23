Press dispatch complete. Writing the report.

## Completion report — endo-git-integration-press-20260720-145005

**Assessed the full M3 stack; verified the outstanding CI question from the last press; landed the roadmap's one unblocked work item as a new docs PR.**

**Verifications (real output cited):**
- **#626** (Phase-5 stack-surgery eval): the fairness-follow-up head `8e29c292` that was PENDING at the last press is now **22/22 SUCCESS** (`gh pr view 626 --json statusCheckRollup` → `{"conclusion":"SUCCESS","n":22}`). No fixer needed. PR remains DRAFT as required.
- **#705** (Phase 1, remote-push tier): OPEN, un-drafted, `mergeStateStatus: CLEAN` at head `76371cb1`. The merge-directive ask `20260717T002451Z-cb5a1b` still sits **unread** in `inbox/maintainer/unread/` — did not merge, did not re-send, per standing instruction.
- **#707** (Phase 3, worked loop / M3 exit): green, CLEAN, still based on the frozen snapshot of #705's head — blocked behind #705's maintainer-gated merge. The stale parked gauntlet job and the moot parked #626 weave in `jobs/plan/` were left untouched.
- **#708** (exo-git QID/hash): OPEN, un-drafted, CLEAN at `ce58ad49` on `llm-41cb580`. **#740** (endor bindings design) and **#691** (sequencing design): OPEN, CLEAN, no new maintainer comments since 2026-07-18 (only our own weave note on #691, 2026-07-19). No live peer workers on any git-integration branch (`inbox-list` shows only other arcs' presses).

**Work done — opened PR #807 (DRAFT, base `llm`):** the M3 roadmap's item 4, "reconcile `tree(ref)` and `filesystemAt(ref)` into one canonical vocabulary," was undone and unowned — `designs/daemon-git-capability.md` had **zero** mentions of `filesystemAt` even though the method shipped on `llm` (`packages/exo-git/src/types.ts` already documents the projection relationship). Commit `437b7f48` edits the canonical doc (Summary, primitives list, Dependencies, What-Changes table, the `Git` interface sketch, a new **§ Historical Read: One API, Two Projections**, Sample Use with the shipped `root()`/`lookup()` call shape, Git-Tree Backend read surface, Design Decision 3) and ticks the roadmap item. The section carries both documented trade-offs (path-based QID, `sha256` BlobRef) and is worded branch-agnostically around #708's restoration, deferring currency to `endo-fs-from-git` § Status — correct on both sides of #708's merge. Docs-only; disturbs no stack order. https://github.com/endojs/endo-but-for-bots/pull/807

**CI on #807:** `build` and `zizmor` already **pass** (33s/21s); `lint`/`test`/`browser-tests` pending at press close. Failure risk is nil-adjacent: `*.md` is in `.prettierignore` and lint covers only `.github packages`, so `designs/` is out of lint scope and no code changed.

**Follow-ups for the next dispatch:** (1) confirm #807's remaining three checks went green (cite output); (2) re-check the #705 directive ask — still do not merge or re-send while unread; (3) after #705 lands, #707 needs its weave onto `llm`, then its merge closes M3.
