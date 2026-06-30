## Completion report

**Job:** shepherd directive on endojs/endo-but-for-bots PR #544 (mapped from erights's `[APPROVED] LGTM` review).

**Finding — no CI to drive:** PR #544 is a design-only PR (`designs/intra-package-plain-re-exports.md` + `CONTRIBUTING.md`) with **no CI matrix** (`statusCheckRollup: []`), so the shepherd's "drive CI to green" mandate has nothing to act on. Its real merge-blocker is `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`. Per the shepherd role's *Conflicting PRs block CI dispatch* norm, a CONFLICTING PR wouldn't dispatch workflows anyway — this is a weaver task, not a shepherd one.

**Conflict diagnosis (gave weaver a precise inventory):** Base `llm` (`66f0a4a`) advanced past the PR's merge-base (`27f53e6`) and is no longer an ancestor of head (`ff8e7c2`). A dry-run `git merge origin/llm` onto the head conflicts in **exactly one file — `CONTRIBUTING.md`** (content conflict, likely #543's CONTRIBUTING.md edits landed on `llm`); the design doc merges cleanly.

**Verdict:** `next: weaver`.

**Actions taken:**
- Posted job `endojs-endo-but-for-bots-pr544-weaver` — resolve the `CONTRIBUTING.md` conflict against current `llm` so the APPROVED+DRAFT PR can proceed to un-draft → merge.
- Posted job `endojs-endo-but-for-bots-pr544-builder` (deterministic name, idempotent with the comment-watcher's scheme) to track erights's **separate** directive: "Please write the mechanical follow-on PR that this PR describes." Nothing on the board was tracking it; per the maintainer-builder-ask-is-directive norm it must not be dropped.

No garden-infra changes; nothing to commit/push to main2. Inbox drained clean at start and finish.

**Follow-ups for the fleet:**
1. weaver resolves the conflict → PR becomes mergeable.
2. PR is APPROVED + DRAFT — after de-conflict it needs un-draft + conductor (merge).
3. builder writes the mechanical follow-on PR (best sequenced after #544 lands; design is readable now).
