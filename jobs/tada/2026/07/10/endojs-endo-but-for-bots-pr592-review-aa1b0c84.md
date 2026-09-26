All posted and verified on `origin/journal2`. This was a review-directive triage job: enumerate every ask and route the work. No inbox messages; no `main2` changes to push (routing happens via the journal scripts); the read-only project checkout will be torn down.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #592 (pullrequestreview-4673410829, @kriskowal, CHANGES_REQUESTED).

**Preflight:** `pr-feedback-preflight.sh … 592 4673410829 kriskowal` → exit 0 (no peer resolution). Proceeded.

**Enumerated the whole review** (body + both inline comments tied to the review, treated as untrusted data):
1. **Review body:** "Please dispatch a cleaner to look for opportunities to increase coverage on these new features."
2. **Inline `mount.js:832`** (id 3560627735): "Do we have `@endo/cancel` committed on llm now?" — I verified on the branch: **yes**. `packages/cancel` exists and `@endo/daemon` already depends on `@endo/cancel` (imports `makeCancelKit` in `context.js`). The mount stream-cancellation currently hand-rolls `makePromiseKit()` + `Promise.race`.
3. **Inline `mount.js:848`** (id 3560633818): "`cancelled` can be in the options bag and default to an forever pending promise."

**Routing (serial orchestration — the standing multi-part pattern):** asks 2 and 3 concern the same `watchDirectory` cancellation API and files, so they're one fixer job; the coverage ask must land *after* the API reshape (tests should target the final signature), so a serial pipeline:

- `jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md` — **fixer**: fold `cancelled` into the `watchDirectory` options bag (default forever-pending) across the `@endo/platform` adapter/exports/types + daemon call sites, and adopt `@endo/cancel`'s `makeCancelKit` for the mount-level fold; behavior invariant; reply to both inline comments on completion.
- `jobs/plan/endojs-endo-but-for-bots-pr592-watchdir-coverage.md` — **cleaner**: increase coverage on the new watchDirectory features (adapter + daemon delegation), rebased onto the fixer's result, with a checklist of candidate under-covered paths.
- `jobs/orch/endojs-endo-but-for-bots-pr592-review-orch.md` — **serial, on-child-failure=halt** over those two children.

All three confirmed present on `origin/journal2`. The leader-only `garden-orchestrate` watcher will now promote the fixer child, watch it to `tada/`, then promote the cleaner child.

**Follow-ups:** none for me — the two children carry their own DoD (preflight, eslint/tsc, tests with cited counts, push to the PR head, inline replies citing the resolving commit). No `main2` edits were needed; the read-only project worktree is torn down.
