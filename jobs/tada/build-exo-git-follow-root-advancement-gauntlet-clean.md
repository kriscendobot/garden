The clean stage is complete. Let me write the completion report.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #1080 (`feat/exo-git-follow-root-advancement`), gauntlet `build-exo-git-follow-root-advancement-gauntlet`.

**What I did**

1. **Coverage pass** on the touched packages (`@endo/exo-git`, `@endo/git`) via `c8`. The exo-git follower logic already has a dedicated 267-line `root-follow.test.js` (8 tests) covering follower semantics, failure stickiness/recovery, unborn HEAD, and metadata-only chains. Found one genuinely-uncovered public behavior in the **native backend**: `rootAdvancements()` distinguishes a fast-forward advance (walked commit range) from a **non-descendant root replacement** (single explicit transition), but the exo-git tests drive `watchRoot` through a fake backend, so the native replacement branch (1846–1856) was covered nowhere.
   - Added an integration test (`native watcher reports a non-fast-forward root replacement as a single transition`) to `packages/git/test/root-follow.test.js` that resets the tip to a sibling of the observed root and asserts a single replacement transition. This brings `rootAdvancements` to full coverage. The one remaining uncovered line (1815, the defensive re-throw of an unexpected git error) is an adversarial branch left uncovered per the skill (no contortion test). Verified locally: eslint/prettier/tsc clean.
2. **No orphaned dead code** — the `filesystemAt` → `filesystemForTree` refactor kept all paths live; `rootAdvancements` is live (called by `watchRoot`).
3. **Fixed two pre-existing generated-artifact drift defects** in the PR (both surfaced only once CI ran; the PR author added deps + public methods to exo-git without regenerating downstream artifacts):
   - **Composite tsconfig drift** (`lint` job): regenerated `packages/exo-git/tsconfig.composite.json` — it gained `@endo/exo-stream`, `@endo/pass-style`, `@endo/pubsub` references.
   - **Stale code-mode git declarations** (`test`×4 + `cover`×2 jobs): regenerated `packages/agent-tools/generated/code-mode-globals/git-declarations.js` to reflect the new `followRootChanges`/`followLatestRoot` methods.
   - Confirmed `help-text-data.js` was already current (no drift).

**What changed (pushed to PR head)**
- `d2d8cad0` `test(git): cover non-fast-forward root replacement in native watcher`
- `a2e8e5ec` `chore: regenerate downstream artifacts for exo-git followRoot`

**CI result:** GREEN — all 25 checks terminal, 0 failures at head `a2e8e5ecdc62` (`ci-wait-merge … failed=0 → CI GREEN`, rc 0). PR remains draft (clean does not un-draft; the panel stage owns that).

**Follow-ups:** none. Recorded the code-mode-types drift gate alongside the existing composite-tsconfig memory for future exo-git public-surface changes.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-exo-git-follow-root-advancement-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (7873434 cached reads)
- Output: 40546 tokens
- Cost: $6.187331
- Wall-clock: 2809s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
