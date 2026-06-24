---
ts: 2026-05-14T05:03:55Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener restructures jury/judge, moves cleaner earlier, and adds a merged-PR feedback watch

Dispatch root: `dispatches/gardener--jury-judge-redesign-and-feedback-watch--20260514-050355--76d07a/`.

Four maintainer directives, one engagement:

1. **Merged-PR feedback watch.** Add a recurring gardener duty: monitor PRs after they merge, extract feedback patterns that apply more generally, track trends across engagements, look for contradictions in current rules, and seek automatic and permanent solutions that can be applied in future builds, reviews, and fixes. Maintainer's framing: this is the gardener's standing remit, not a one-off.

2. **Carve juror into individual jurors with partially-overlapping inquiry areas.** Maintainer's framing: "each kind of review is conducted more than once, but a wide variety of concerns are evaluated. The size of the jury is negotiable as it has already grown to include a saboteur." Today there is one generic `juror` role plus a `saboteur` role. The redesign breaks `juror` into several named jurors, each with its own area of inquiry, with overlap so the same concern is touched by more than one juror. The saboteur stays — its adversarial / invariant-attack lens is already a distinct juror seat in this scheme. Sizing is the gardener's judgement; expect the panel to settle in the 3 to 6 seats range; the gardener writes a brief rationale for the size it picks. Reasonable inquiry areas to consider (gardener picks the final cut): correctness / types, API stability / public surface, naming / diff hygiene / changeset content, docs / regression evidence, adversarial / invariants (saboteur), security / capabilities, performance / complexity. Each new juror gets its own `roles/<juror-name>/AGENT.md`. Skills (`panel-review`, `regression-evidence`, etc.) are shared.

3. **Cleaner moves between builder and jury.** Maintainer's exact words: "I don't see the cleaner as a juror since it both writes and runs tests, which is to say, it should continue to stand between the builder and the jury." Today the cleaner is the *last* role (it un-drafts and is the only role to do so). New ordering: builder → cleaner → jury → fixer-loop → judge un-drafts. The cleaner's remit shrinks: it writes and runs tests, but no longer un-drafts. Update `roles/cleaner/AGENT.md` and `skills/pr-creation-flow/SKILL.md` accordingly. The cleaner is explicitly *not* a juror; its tests-and-coverage work runs before the jury sees the PR.

4. **Make the judge role explicit.** Maintainer's exact words: "Consider making the judge's role explicit, dispatching the jury and aggregating their feedback and issuing the verdict." Author `roles/judge/AGENT.md`. The judge:
   - Dispatches the panel (each juror as its own `Agent` invocation, plus the `gh pr edit --add-reviewer @copilot` call).
   - Aggregates the individual juror reports into one panel verdict (in-scope / out-of-scope split, must-fix / should-fix / comment-only).
   - Submits the formal `gh pr review` on behalf of the panel.
   - Reads the fixer's result and decides whether to re-dispatch the panel or to declare the loop done.
   - Un-drafts when the loop is done (this authority moves from cleaner to judge).
   
   The judge is *not* itself a reviewer; it is the panel's foreperson. Its role file says so explicitly so future redesigns do not erode the line between judge and juror.

The redesigned flow becomes: **builder → cleaner → judge (dispatches jury) → fixer-loop (judge re-dispatches jury after each fixer) → judge un-drafts**.

## Per-action authorization

Standing on the garden repo (commit + push to `main`, edit `roles/`, `skills/`, top-level docs). No project-side actions.

## Task

1. **Read first.** `skills/pr-creation-flow/SKILL.md`, `roles/juror/AGENT.md`, `roles/saboteur/AGENT.md`, `roles/cleaner/AGENT.md`, `skills/panel-review/SKILL.md`, `roles/gardener/AGENT.md`, `roles/liaison/AGENT.md` § PR-creation-flow chaining, `roles/steward/AGENT.md` § PR-creation-flow scan. Skim 2-3 recent jury / fixer / cleaner result entries in the journal so the redesign lands on observed reality, not abstraction.

2. **Restructure the jury.** Decide the final juror-seat list (likely 3 to 6 named jurors with partially-overlapping inquiry areas; the saboteur is one of the seats). Author one `roles/<juror-name>/AGENT.md` per seat. Mark the existing `roles/juror/AGENT.md` as deprecated (keep the file, redirect to the new seats with a top-of-file note explaining the split) OR remove it and ensure every reference is updated; pick whichever is cleaner for future readers. State the rationale for the panel size and inquiry-area split in `skills/pr-creation-flow/SKILL.md` § Jury composition.

3. **Move the cleaner.** Update `roles/cleaner/AGENT.md` to (a) place itself between builder and jury, (b) drop un-draft authority (transfer to judge), (c) keep its coverage / dead-code remit. Update `skills/pr-creation-flow/SKILL.md` § Flow ordering, § Cleaner placement, § Maintainer entry point, and the ASCII flow diagram. The cleaner-skipped tiny-PR variant still applies, but now skipping the cleaner means the orchestrator dispatches the judge directly after the builder.

4. **Author the judge.** Create `roles/judge/AGENT.md`. Sections: purpose, skills used (`panel-review`, `pr-creation-flow`), operating norms (dispatches each juror as its own `Agent` invocation; runs `gh pr edit --add-reviewer @copilot` once per round; aggregates reports; submits the formal `gh pr review`; un-drafts on loop completion), external-repo etiquette (the judge's panel verdict is a formal review on an upstream PR; per-action authorization for the verdict ride along in the dispatch), definition of done.

5. **Update orchestrator role files.** `roles/liaison/AGENT.md` and `roles/steward/AGENT.md` reference the new dispatch chain: builder, cleaner, judge (in place of "jury"), fixer. The steward's per-cycle PR-creation-flow scan reads the next-stage-owed heuristic the same way, but the "next stage" enum changes; rewrite the heuristic in `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic to match the new flow. The orchestrator no longer dispatches a juror; it dispatches a judge.

6. **Add the merged-PR feedback-watch duty to the gardener.** Edit `roles/gardener/AGENT.md` § When dispatched (or add a § Standing duties section). The new duty: periodically (cadence: gardener's call, but at minimum on each gardener dispatch) read recently-merged PRs from `endojs/endo-but-for-bots` and `endojs/endo` over the last 1-2 weeks, extract feedback patterns the maintainer left in inline comments and review bodies, look for recurring themes, contradictions in current rules, and "automatic and permanent solutions" (i.e., rule additions to a skill or role that prevent the feedback from recurring). The gardener authors a "merged-PR digest" journal entry per pass: `kind: digest`, `role: gardener`, with the patterns extracted, the contradictions found, and the rule changes landed (or proposed if the gardener decides to land them later). Recurring detection beats single-sample reaction; the digest's threshold for "land a rule" is "appeared in 2+ merged PRs in this window". Single-sample observations go in `## Notes from the field` rather than `## Operating norms`.

7. **Author a skill for the merged-PR watch.** New file `skills/merged-pr-feedback-watch/SKILL.md`. Sections: purpose, when to run, inputs (the repos to watch, the time window, the comment-fetch commands), procedure (the pattern-extraction pass), output shape (the digest entry's frontmatter and body), state (where to record what was already digested, to avoid re-digesting the same PR). Cite this skill from `roles/gardener/AGENT.md`.

8. **Find contradictions.** As part of #7's procedure, the gardener also reads the existing `skills/` library and looks for contradictions across files. Where two rules disagree, the gardener resolves to one (with the maintainer's prior framing as the tie-breaker when explicit, otherwise leaves the contradiction surfaced in the digest for the maintainer to resolve). One sweep this engagement: read the now-updated `pr-creation-flow` plus the named-juror files for contradictions before declaring done.

9. **Update the inventory.** `CLAUDE.md` § Current inventory adds the new juror seats, the judge role, and the new skill. Drop the generic `juror` line if the role is removed.

## Out of scope

- No PR edits on any external repo. This engagement is garden-meta only.
- No retroactive re-dispatch of jury / cleaner on existing draft PRs. The orchestrator (liaison or steward) picks up the new flow on the next dispatch; existing in-flight chains continue with whatever roles they started.
- No new merged-PR digest pass *this* engagement (that is a separate gardener cycle; this engagement adds the duty and the skill).
- No edits to project-side files (`worktrees/...`).

## Commits

Reasonable split on `main`:

- One commit per new role file (each juror, the judge). Authoring is the substantive change.
- One commit per substantially-revised existing file (`pr-creation-flow`, `cleaner`, `liaison`, `steward`).
- One commit for the new `merged-pr-feedback-watch` skill and the gardener role's citation of it.
- One commit for the `CLAUDE.md` inventory bump.

Push at end. Journal result entry.

## Report

- The final juror-seat list with one-line rationale per seat and the panel-size rationale.
- Files added or substantially revised (one line per file).
- The new flow's ASCII diagram (one block).
- One-line confirmation that the next orchestrator dispatch (in-session liaison or per-cycle steward) reads the new flow and dispatches builder → cleaner → judge.
- The cadence the gardener proposes for the merged-PR watch (with a sentence on why that cadence).
- One-line self-improvement note per `skills/self-improvement/SKILL.md`.
