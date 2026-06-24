---
ts: 2026-05-14T04:01:32Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes "add Copilot as a reviewer when dispatching a jury"

Dispatch root: `dispatches/gardener--copilot-as-jury-reviewer--20260514-040131--16273d/`.

Maintainer directive (this session): "When we dispatch a jury to review a PR, let's also add copilot as a reviewer."

GitHub's Copilot PR review feature lets a maintainer (or the bot with reviewer-add permissions) request Copilot's review via `gh pr edit <N> --add-reviewer Copilot` (verify the exact handle; it may be `copilot-pull-request-reviewer`). Once requested, Copilot leaves a `COMMENTED` review automatically. This is now part of the jury panel.

## Task

Encode the convention in the right surface(s):

1. **`skills/pr-creation-flow/SKILL.md`** § Jury composition (or wherever the jury panel is described): the jury panel is now juror + saboteur **+ a Copilot review request**. The Copilot request is fire-and-forget (no follow-up dispatch); Copilot leaves its review autonomously when GitHub schedules it.

2. **`roles/steward/AGENT.md`** § PR-creation-flow scan (the section that landed in `cbd98d0`): when the scan owes a jury dispatch for a PR, the steward also runs `gh pr edit <N> --add-reviewer <copilot-handle>` as part of the dispatch (one shell call, not a separate Agent invocation). Document the exact gh handle for Copilot once verified.

3. **`roles/liaison/AGENT.md`**: the same chaining-responsibility norm extends here. When the in-session liaison dispatches a jury, it also adds Copilot.

4. **Optionally**, on `roles/juror/AGENT.md` or `roles/saboteur/AGENT.md`: note in a `## See also` (or similar) section that Copilot reviews the same PR; the juror and saboteur should consider Copilot's existing review as part of the panel's output when wrapping.

## Verification step

Before landing, verify the Copilot handle: `gh api -X GET search/users?q=copilot+pull+request+reviewer` or read the GitHub docs. The PR review on `endojs/endo#3257` already shows Copilot using the handle `copilot-pull-request-reviewer`; that's the canonical form. If `gh pr edit --add-reviewer copilot-pull-request-reviewer` does NOT work, the alternative is `gh pr edit --add-reviewer Copilot` (the user-facing display name). Document whichever works.

## Out of scope

- Do NOT retroactively add Copilot to existing open garden PRs in this dispatch. The next jury dispatch (the steward's next chain pickup) will add Copilot per the new rule.
- Do NOT modify the juror or saboteur dispatch prompts themselves (the orchestrator does the adding; the per-juror/saboteur dispatch is unchanged).
- Do NOT add Copilot as a reviewer outside the jury-dispatch flow (e.g., not on PRs without a jury).

## Commits

Suggested split on `main`:
- `pr-creation-flow: jury panel includes Copilot reviewer request`
- `steward: add Copilot when dispatching jury in PR-flow scan`
- `liaison: add Copilot when dispatching jury in-session`

Push at end. Journal result entry.

## Report

Files edited, the verified Copilot gh handle, one-line confirmation that the next jury dispatch will request Copilot's review.
