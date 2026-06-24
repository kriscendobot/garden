---
ts: 2026-06-03T17:19:21Z
kind: result
role: gardener
host: endolinbot
to: liaison
---

# Result: researcher role landed (precedes designer + builder)

## Maintainer directive

> I would like to explicitly inject library research as an explicit
> role and step that precedes designer and builder in our workflows.
> The researcher would refine the prompt for the designer or builder
> by adding links to relevant documents in the library.

Plus follow-up clarifications:
- Scope: just preceding designer and builder for now.
- Library scope: anything relevant in `journal/library/` (using the
  indexes for discovery), plus relevant project information.
- Integration depth: "land as a complete integration with the workflow
  state machine such that new subagents immediately begin using these
  instructions."
- Implementation shape: dispatchable role that takes a proposed
  downstream prompt and returns a refinement on it, used by the
  orchestrator as a step in the dispatch workflow.

## Files touched and commit

Commit `5c3a5dad` on `origin/main` — 7 files, +154 / -12:

- **`roles/researcher/AGENT.md` (new, 102 lines)** — role contract:
  purpose, when-to-enter, dispatch inputs, skills, procedure (read
  prompt → walk library → walk project → synthesize → write result),
  operating norms (refinement is additive; do not invent references;
  half-line relevance notes; index on the fly is mandatory; read-only
  on project material; one-to-three-minute budget; self-improvement
  applies normally), output shape (one-paragraph summary, fenced
  refinement block, library writeback paragraph, open questions,
  Self-improvement line), external-repo etiquette (journal-only),
  definition of done, 2026-06-03 notes-from-the-field row.
- **`roles/designer/AGENT.md`** — Skills bullet for library-lookup
  extended: the researcher's `## Library and project references`
  section is the starting point; independent library-lookup calls
  still apply for terms the researcher did not surface.
- **`roles/builder/AGENT.md`** — same edit shape.
- **`roles/liaison/AGENT.md`** — new section *Researcher precedence
  on designer and builder dispatches* before *Vocabulary: the gamut*.
  Names the workflow (compose prompt → dispatch researcher → extract
  refinement → inline → dispatch downstream), enumerates the four
  surfaces (direct designer/builder, design-to-PR pipeline,
  job-board claims), enumerates the not-applicable roles (fixer,
  weaver, shepherd, conductor, judge, panel-juror), and codifies the
  two legitimate skip reasons (re-application of a prior refinement,
  immediate chain continuation).
- **`roles/steward/AGENT.md`** — new section *Researcher precedence
  on designer and builder dispatches* before *PR-creation-flow scan*.
  Cites per-cycle scan, design-to-PR pipeline, maintainer-feedback
  response, and job-board claims as the four steward surfaces where
  the precedence applies. Subordinate-roles list now includes
  `researcher` as a top-level entry, and the `builder` /
  `designer` entries note the precedence.
- **`roles/general-contractor/AGENT.md`** — new section *Researcher
  precedence on designer and builder dispatches* before *Per-cycle
  procedure*. Cites slot-refill builder dispatches, per-stage builder
  dispatches, and slot-design-walk designer dispatches as the three
  contractor surfaces. Subordinate-dispatches bullet now includes
  `researcher`.
- **`CLAUDE.md`** — inventory updated with `researcher` and a
  one-sentence pointer to the precedence rule.

Frontmatter `updated:` bumped to 2026-06-03 on every edited file.

## Workflow integration end-to-end

For an orchestrator (liaison, steward, or contractor) about to
dispatch a designer or builder:

1. Compose the proposed downstream dispatch prompt as usual.
2. Prepare a researcher dispatch root via
   `skills/dispatch-worktree/dispatch-prepare.sh researcher
   <purpose-slug>`.
3. Write a `dispatch: researcher` entry naming
   `downstream_role` (`designer` or `builder`),
   `proposed_prompt` (the body of the proposed downstream prompt
   verbatim), and `project_slug` / `repo` when applicable.
4. Invoke `Agent` with the researcher prompt template, citing
   `roles/researcher/AGENT.md` as the role file.
5. On the researcher's return: read the `result` entry,
   extract the fenced `## Library and project references` block
   from the result body, inline it into the downstream dispatch
   prompt body (before the *Acceptance* and *Report* sections).
6. Prepare the downstream dispatch root, write the downstream
   `dispatch` entry, invoke `Agent` with the now-refined prompt.
7. Tear down both dispatch roots on the downstream's return per the
   standard procedure.

The researcher's dispatch root is no project worktree — its work is
journal-side only.

## Scope and skips

Applies to: designer, builder. Includes the design-to-PR pipeline's
builder, the maintainer-feedback-response designer (on design-only
PRs), and any job-board-claimed `build` / `design` verb.

Does not apply to: fixer, weaver, shepherd, conductor, judge,
panel-juror. These read PR state directly.

Legitimate skips, recorded in the downstream `dispatch` entry:

- The proposed prompt is itself the researcher's refined output from
  a prior dispatch the orchestrator is re-applying.
- The downstream role is an immediate chain continuation whose prior
  step already inlined a researcher refinement and the chain's
  context has not changed.

Every other skip is a procedural shortcut queued for the gardener.

## Out of scope

- **Researcher precedence on fixer, weaver, etc.** Today the
  precedence is designer + builder only. A future engagement can
  extend if the pattern earns it (the user's framing on 2026-06-03
  was "just preceding the designer and builder for now").
- **Synchronous orchestrator-script shape.** The user specified a
  dispatchable role; the synchronous-bash shape would have been the
  alternative. Not implemented.
- **Retroactive backfill** of existing in-flight dispatches. The
  precedence applies to new dispatches from this commit forward.
- **Researcher-side test harness.** No bash test analogous to the
  driver test suite. The role is dispatched as an LLM subagent; its
  contract is the AGENT.md file plus library-lookup behavior.

Self-improvement: `roles/researcher/AGENT.md` (new) plus integration
into the three orchestrators and the two downstream-role briefs. The
workflow is wired end-to-end so the next designer or builder dispatch
in any orchestrator's session begins with the researcher pre-step.
