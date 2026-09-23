The job was already completed and pushed to `main2` by the prior attempt before it was reaped. I re-derived the state, verified the wiring is coherent and the tests pass, and found nothing left to redo.

## Completion report

**Status:** Already done — commit `08a0addc5e` "feat(review): prefer URL path math" is an ancestor of `origin/main2` (current HEAD). No new work or push was needed; my fresh worktree matched the landed state.

**What is in place (verified):**

1. **New style skill** `skills/url-path-math/SKILL.md` — records the "prefer `new URL(...)` module-relative path math over importing node `path`" convention, with the `fileURLToPath(new URL('.', import.meta.url))` form, scope/exceptions (does not forbid `node:path` when the input is already a native path string), enforcement tiers, and the PR #124 `r3548837460` motivating incident.

2. **Reviewer-pool burden added:**
   - `roles/jurors/purist/AGENT.md` — new **URL-relative path math** primary-surface bullet directing the seat to flag added `node:path` / `path.resolve` / `path.dirname` that computes from `import.meta.url`, should-fix, with the URL rewrite cited; plus the skill in its reading list.
   - `skills/panel-hints/probes/C-purist.sh` — probe pattern extended to fire the purist on `import ... from 'node:path'`, `path.resolve(`, and `path.dirname(`.
   - `skills/panel-hints/SKILL.md` updated to match.

3. **Guidance surfaces:** `roles/COMMON.md` § House style indexes the skill; `roles/builder/AGENT.md` carries it when authoring Endo code; `CLAUDE.md` skills inventory lists `url-path-math`.

4. **Test:** `scripts/jobs/test/review-convention-probes-test.sh` — ran it now, **18 passing, 0 failing**, including the three new cases asserting `node:path` import, `path.resolve`, and `path.dirname` deterministically route to the purist.

**Follow-ups:** none. The rule is deliberately review-tier (not a blocking pre-push gate), as the skill notes, since distinguishing a genuine native-path input from URL-relative math needs surrounding context.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-style-url-not-path.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 16 tokens (316994 cached reads)
- Output: 3324 tokens
- Cost: $0.581722 (1 engagement(s) unpriced)
- Wall-clock: 469s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
