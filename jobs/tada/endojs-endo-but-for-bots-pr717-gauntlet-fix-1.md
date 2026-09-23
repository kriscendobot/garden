CI is **GREEN** (6/6 checks, 0 failed). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 1 for endojs/endo-but-for-bots PR #717 (`design: promise debug view`).

**What I did:** Applied the round-1 design-panel must-fix items once, pushed, and watched CI to green.

**Root cause the panel surfaced:** the branch was based on `cc41f42e2`, a commit *before* the parent `designs/pass-style-promise.md` landed on `llm` — so every `[pass-style-promise]` cross-reference was a dead link, and the design used terminology the parent had explicitly rejected. Since the change is purely additive (one new design file + one README roadmap entry) and the branch was 1494 commits behind with a fully-rewritten README, I **rebuilt the branch on current `origin/llm`** (rewrite-mode push) rather than replaying a gnarly 1494-commit rebase. The parent is now present in-tree and the design is self-verifiable.

**Must-fix items applied:**
- **Terminology** (critic/pedant/novice/skeptic): `subscribe`→`listen`, `subscriber`→`listener`, `onFirstSubscribe`→`onFirstListen`, `unsubscribed-rejection`→`unlistened-rejection`, section/principle names, and the corrected future-work quote — matching the merged parent's actual API.
- **First-listener plumbing correctness** (critic): documented that `onFirstListen` is an optional single producer-supplied callback, added a "First-listener arrival plumbing" subsection giving the debug view its own runtime-owned hook that composes with the producer's; resized Phase 2 **S→M**.
- **Stable cross-GC correlation key** (decomplector): added a monotonic serial `id` threaded as the `FinalizationRegistry` heldValue, because a `WeakRef` can't be dereferenced in the finalization callback.
- **`label`/`id` field split** (decomplector).
- **Should-fixes folded in:** `debugView()` → `{ enabled, entries }` (ergonomist); `makePromise({ label })` name match (ergonomist); composite never-delivered-before-GC test in Phase 4 (skeptic); vocabulary recap front-loaded and forever-pending parenthetical untangled (novice/copyeditor); Title-cased Reconciliation heading; four `-ly` adverb hyphens removed (pedant).

**Also:** corrected the PR title's "unsubscribed"→"unlistened"; synced README roadmap entry/table row/totals (49→50 Not Started, 196→197); re-validated the mermaid diagram (`mermaid.parse` OK); posted a fix-round follow-up comment.

**Result:** pushed `b0292dafa…86ebf4ae` to `design/promise-debug-view`; CI terminal **GREEN** (6/6, 0 failed). Stopped without re-running the panel, per the staged-gauntlet contract (the driver re-posts panel-2).

**Follow-up note:** the comment-only ergonomist item (verb/noun naming symmetry between `debugView`/a future `debugTrack`) was addressed proactively inside Open Question 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3053032 cached reads)
- Output: 32363 tokens
- Cost: $3.3617180000000007
- Wall-clock: 965s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
