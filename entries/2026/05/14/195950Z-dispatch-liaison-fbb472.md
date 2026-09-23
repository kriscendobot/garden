---
ts: 2026-05-14T19:59:50Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes the design-review jury (5 seats, parallel to the 12-seat code panel)

Dispatch root: `dispatches/gardener--fbb472/`. Garden-meta only.

## Maintainer directive

2026-05-14, after the TLA + import-attributes designs landed as draft PRs on llm: *"Designs should be reviewed by a critic, a skeptic, a copy editor, a Chicago Manual style guide enthusiast, and a naïve [reader] who only understands short sentences with clear logical progress."*

This adds a **design panel** alongside the existing 12-seat code panel. The judge already orchestrates panels; it gains a panel-kind discrimination so it dispatches the design panel against design-only PRs and the code panel against code PRs.

## The five seats

The maintainer named the perspectives in framing. The gardener picks the final role names; I will propose names for the gardener to consider:

1. **Critic** (proposed name: `critic`) — substantive critique. Reads the design as someone evaluating whether the proposed approach is the right one: are the tradeoffs correctly identified, are the alternatives correctly rejected, does the design compose with the rest of the system, will the implementation actually work?
2. **Skeptic** (proposed name: `skeptic`) — adversarial. The design's "what would break this" lens. Distinct from the code-panel's `saboteur` (which attacks invariants in shipped code) and `breaker` (which attacks `M.interface()` guards) — the design's skeptic attacks the *premise*: are the assumptions wrong, is the spec misread, will the user's actual workflow trip on this, is the test catalog complete?
3. **Copy editor** (proposed name: `copyeditor`) — prose mechanics. Grammar, sentence structure, consistency of voice, flow between sections, unintroduced jargon. Reads as someone hired to copyedit the document for publication.
4. **Chicago Manual pedant** (proposed name: `pedant`) — formal style. Punctuation, capitalization conventions, citation form, table/figure conventions, em-dash discipline (orthogonally to our existing `em-dash-style` skill), and the things Chicago Manual cares about that copy editors often don't. The naming should signal "professional style nitpicker, not pedantic in the negative sense".
5. **Naïve reader** (proposed name: `novice` — open to `tyro`, `neophyte`, `apprentice`) — clarity. Reads the design like someone new to the project who only understands short sentences with clear logical progress. Flags any place the design assumes the reader already knows X, any place the reasoning skips a step, any place the prose is too dense to follow.

The gardener may pick different names that fit the surrounding voice; the role count and the perspectives are the load-bearing constraint.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/gardener/AGENT.md`, `roles/judge/AGENT.md`, `skills/pr-creation-flow/SKILL.md` § Jury composition, `skills/panel-review/SKILL.md`, the existing code panel's role files (a representative sample: `roles/assessor/AGENT.md`, `roles/saboteur/AGENT.md`, `roles/archivist/AGENT.md`) for the shape, voice, and structure to match.

2. **Author five new role files** under `roles/<name>/AGENT.md` (one per seat). Each role file follows the existing code-panel-juror template (purpose, skills, operating norms with seat-specific lens, external-repo etiquette, definition of done). Each carries the seat's primary surface as a one-line trigger.

3. **Update `roles/judge/AGENT.md`** § Operating norms to encode panel-kind discrimination:
   - The judge reads the PR's kind/shape (a design-only PR — file additions only under `<project>/designs/` and no source changes — gets the design panel; everything else gets the code panel).
   - The two panels' dispatch shape is the same (concurrent Agent invocations per seat; aggregate; submit one formal `gh pr review`); only the seat list differs.
   - The judge's `result` entry names which panel was dispatched (`code-panel` / `design-panel`) plus the mode (`multi-seat-dispatch` / `in-band-fallback`) per the existing audit-trail discipline.

4. **Update `skills/pr-creation-flow/SKILL.md`** § Jury composition:
   - Distinguish the code panel (12 seats) from the design panel (5 seats); name the discrimination rule (PR shape: source changes → code; design-only → design).
   - Note the cleaner step is skipped for design-only PRs (no test surface; no source to delete).
   - Update the flow's ASCII diagram if needed.
   - Carve out the design-only-PR variant explicitly in the *Flow ordering* section.

5. **Update `skills/panel-review/SKILL.md`** to acknowledge the two panel-kind sets. The aggregation discipline (one formal `gh pr review`, in-scope vs out-of-scope, must-fix / should-fix / comment-only verdicts) is the same; only the seat list differs.

6. **Update `CLAUDE.md`** § Current inventory: add the five new juror seats. The total juror count is now 17 (12 code + 5 design).

7. **Note for future dispatch**: once this gardener engagement lands, the steward's per-cycle scan picks up design-only PRs (#249 + the import-attributes one when it lands) and dispatches the judge with the design panel. The first design-panel reviews will be on those two PRs. This gardener engagement does NOT dispatch them itself; that is the steward's job per the per-cycle flow.

## Out of scope

- No re-author of the code panel.
- No edit to existing in-flight panel dispatches.
- No PR edits on external repos.

## Commits

- One commit per new role file (5 total).
- One commit per substantively-revised file (`judge`, `pr-creation-flow`, possibly `panel-review`, `CLAUDE.md` inventory).

Push at end. Journal result entry.

## Report

≤ 400 words: final five-seat list with one-line rationale per seat, one-line rationale for the panel-discrimination rule (design vs code), files added or substantially revised (one line each), one-line `Self-improvement: ...`.
