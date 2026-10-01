All three of kriskowal's review asks on PR #1402 are resolved in the design doc, and the PR is ready to merge. It is mergeable, CI is green on the new head, and a conductor job is queued to un-draft and merge it.

**What changed:** the PR feedback preflight found no peer fix (exit 0). The review body is just "@kriscendobot rsvp"; the real asks were three inline comments on the doc's open questions. I rewrote `designs/daemon-mount-visible-roots.md` in commit `9ae6854838` on `design/daemon-mount-visible-roots`:
1. **Roots keep their prefix (line 256):** each root of the multi-root view now appears at its real absolute host path, so relative and absolute symlinks both resolve unchanged. Any root can be walked directly by that path, so the root-qualified path argument from open question 1 isn't needed. The doc spells out the trade-off: this reveals host paths, where an ordinary mount hides its prefix. Labels and the made-up URL prefixes are gone; `resolve()` now returns the absolute path, and roots are named by their prefix.
2. **Single root; call a root set a "namespace" (line 260):** `provideSubMount` over a namespace now gives a plain single-root mount that hides its prefix. I renamed the concept throughout: `EndoNamespace`, `EndoNamespaceControl`, `namespace`/`namespace-control` formulas, and `EndoHost.provideNamespace`. "Mount" now always means one root.
3. **"Let's try" snapshot roots (line 262):** added a new section and implementation phase 5. `addSnapshotRoot(prefix, tree)` adds a read-only `ReadableTree` at a given path. Because the kernel can't follow links into a snapshot, the daemon resolves them itself, with a loop limit. One prerequisite: `ReadableTree` has no way to record a symlink today, so this phase is blocked until it does.

The open-questions section is now a list of nine design decisions. The test plan, ownership map and dependencies are updated to match. I kept the file name so the review threads stay attached.

**Replies:** I posted one on each thread, linking the commit: r4152120113, r4152120234 and r4152120340.

**Merge:** I posted `conduct-endojs-endo-but-for-bots-pr1402-20261001` for the conductor, without naming a merge method. I then found the approval reconciler had already queued `endojs-endo-but-for-bots-pr1402-conduct` in `todo/`. The two jobs overlap, but whichever conductor runs second does nothing on an already-merged PR. There's no script to withdraw a queued job, so I left both.

**Follow-ups:**
- `endojs-endo-but-for-bots-pr1402-gauntlet-panel-1` is also queued and may review the updated head.
- The PR's base is the frozen `llm-825c598bc`.
- The doc's status is still "Proposed".
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1402-review-141e965e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1159406 cached reads)
- Output: 14635 tokens
- Cost: $1.0532372
- Wall-clock: 1443s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
