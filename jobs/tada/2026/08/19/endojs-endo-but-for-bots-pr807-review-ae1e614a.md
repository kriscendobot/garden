## Completion report — endojs/endo-but-for-bots #807 review

**Review addressed:** kriskowal's review [#pullrequestreview-4976974870](https://github.com/endojs/endo-but-for-bots/pull/807#pullrequestreview-4976974870) on the docs-only design PR #807. Preflight returned PROCEED (no prior peer resolution). Enumerated the review: **1 inline comment + 1 body question** — both resolved.

### The two asks

1. **Inline, `daemon-git-capability.md:336` — "We do not need to contort for backward compatibility. This can be a rename."**
   Collapsed the `tree(ref)` / `filesystemAt(ref)` "two projections + migration compatibility surface" framing into a **single historical-read method, `filesystemAt(ref)`**, presented as a straight rename of the earlier `tree(ref)`. Removed the parallel/retained `ReadableTree` surface; the `ReadableTree` → `Filesystem` shape change now travels with the rename (no backward-compat window). Updated the Summary, "What Changes" table, `Git` interface sketch, Sample Use, § Git-Tree Backend Read Surface, the § Alternatives Considered historical note, Phase 5 record, Design Decision 3, and the roadmap item in `daemon-git-next-steps.md`.

2. **Body — "What is a Git 'history'? … an invention for the daemon."**
   Confirmed it: Git plumbing has no "history" object, and the capability I'd named `PinnedGitHistory` / `historyAt(ref)` never touched commit ancestry — it pins a ref to its immutable **tree** OID and exposes a filesystem view + tar archive. Renamed `PinnedGitHistory` → `PinnedGitTree`, `historyAt(ref)` → `treeAt(ref)` (parallel to `filesystemAt`), dropped "pinned-history"/"bulk history" prose in both docs, and renamed the section heading to "…Agent Projection and Platform **Tree**."

### Artifacts
- **Commit** `7f08e2587` on `origin/docs/git-capability-reconcile-filesystem-at` (2 files, +44/−64).
- **Inline reply** [r3817103680](https://github.com/endojs/endo-but-for-bots/pull/807#discussion_r3817103680) confirming the rename.
- **PR comment** [#5348633970](https://github.com/endojs/endo-but-for-bots/pull/807#issuecomment-5348633970) answering the "history" question, noting the platform-facet name is still provisional and inviting a different spelling.

PR stays draft (design doc under review) — no un-draft/merge was in scope. Untrusted review text was treated as data throughout. Follow-up: the `treeAt`/`PinnedGitTree` spelling is offered as provisional pending kriskowal's preference.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr807-review-ae1e614a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 93 tokens (4540080 cached reads)
- Output: 40307 tokens
- Cost: $4.340437 (2 engagement(s) unpriced)
- Wall-clock: 597s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
