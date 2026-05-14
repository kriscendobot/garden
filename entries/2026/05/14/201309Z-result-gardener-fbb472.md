---
ts: 2026-05-14T20:13:09Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/14/195950Z-dispatch-liaison-fbb472.md
---

# Result: gardener fbb472 encoded the five-seat design-review jury

## Five seats (final names, one-line rationale each)

1. **critic** (substantive critique): the design panel's equivalent of the code panel's assessor. Reads the design as someone deciding whether to greenlight the proposed approach: are the tradeoffs honest, are alternatives correctly rejected, does the design compose with the rest of the system, will the implementation actually work?
2. **skeptic** (adversarial premise attacks): the panel's "what would break this?" lens at the *premise* level. Distinct from the code-panel's `saboteur` (which attacks input shapes) and `breaker` (which attacks `M.interface()` invariants): the skeptic attacks the design's assumptions, spec reading, workflow framing, and test-catalog completeness.
3. **copyeditor** (prose mechanics): grammar, sentence structure, paragraph flow, voice consistency, jargon introduction, transitions between sections. Reads as someone hired to copyedit the document for publication.
4. **pedant** (formal style, Chicago Manual): a professional style nitpicker in the non-pejorative sense. Punctuation, capitalization, citation form, table conventions, list discipline, hyphenation, plus the garden's own layered rules (em-dash discipline, relative paths). Where the project's rules conflict with Chicago Manual the project wins.
5. **novice** (top-down clarity, naïve reader): reads the design as someone new to the project who only understands short sentences with clear logical progress. Flags every place the design assumes the reader already knows X, every skipped reasoning step, every too-dense paragraph.

## Panel-discrimination rule

The judge picks the panel from the PR's file list at dispatch time: every changed path under `<project>/designs/` (no source, no tests) routes to the five-seat design panel; otherwise the twelve-seat code panel applies. Mixed PRs (source plus design) get the code panel with the design content riding as supplementary context. The rule lives in `roles/judge/AGENT.md` § Panel-kind discrimination and is mirrored in `skills/pr-creation-flow/SKILL.md` § Jury composition.

## Files added or substantially revised

- `roles/critic/AGENT.md` (new): substantive critique seat.
- `roles/skeptic/AGENT.md` (new): adversarial premise attacks seat.
- `roles/copyeditor/AGENT.md` (new): prose mechanics seat.
- `roles/pedant/AGENT.md` (new): formal style seat (Chicago Manual plus garden rules).
- `roles/novice/AGENT.md` (new): top-down clarity seat (naive reader).
- `roles/judge/AGENT.md` (revised): added panel-kind discrimination section; split *Default panel composition* into *Code panel* and *Design panel* subsections; updated operating norms to pick the panel before dispatch, fire `@copilot` only on code-panel rounds, name the panel kind in the `result` entry; updated in-band fallback and definition of done to carry the panel kind.
- `skills/pr-creation-flow/SKILL.md` (revised): added the design-only-PR variant under *Flow ordering*; split *Jury composition* into code-panel and design-panel subsections; updated *Concurrency* and the Copilot section to scope to the code panel; updated *Designs versus implementations* to say design PRs run the design-only flow rather than skipping the chain entirely (superseding the same-day earlier "no flow" stance from commits `2b8c67b`, `5314685`, `df46501`, `fdd3618`); updated the next-stage-owed heuristic to route design-only PRs to the judge with the design panel.
- `skills/panel-review/SKILL.md` (revised): two-panel framing in composition section; aggregated-body word range for the design panel (600 to 1000 words); added notes-from-the-field entry.
- `roles/steward/AGENT.md` (revised): per-cycle PR-flow scan dispatches the judge against design-only PRs instead of skipping them; removed the "skip entirely" step that landed in the prior gardener engagement (3159ab) before this dispatch took effect.
- `CLAUDE.md` (revised): inventory updated to list the five new seats and the two-panel framing; total juror count is 17 (12 code + 5 design).

## Commits on main

```
8540383 design-panel sweep: judge picks panel by PR shape; design-only PRs run the design panel rather than skip the chain
dfa67da novice: new design-panel seat for top-down clarity (naive reader)
97631e9 pedant: new design-panel seat for formal style (Chicago Manual)
c0edd1b copyeditor: new design-panel seat for prose mechanics
a2d56b6 skeptic: new design-panel seat for adversarial premise attacks
1a61586 critic: new design-panel seat for substantive critique
```

Pushed to `origin/main` at the timestamp above.

## Resolution of the concurrent-gardener conflict

A prior gardener dispatch (`3159ab`, result at `a276f62`) landed four commits between 20:00:42 and 20:00:48 encoding "design-only PRs are not in the flow chain (no cleaner, no judge, no jury)". My dispatch (`fbb472`, dispatched at 20:00:28) carries a maintainer directive that contradicts that stance: design-only PRs *do* get a panel review, by the five-seat design panel. I resolved in favor of the dispatch I was given (the more recent maintainer expression of intent) and explicitly noted the supersedence in the sweep commit's message and in `skills/pr-creation-flow/SKILL.md` § Notes from the field. The base-branch split rule (designs on `llm`, implementations on `master`) is preserved; only the "no panel" element was replaced.

## Note for the next steward cycle

This dispatch does not itself fire the design panel against #249 or the import-attributes design PR. The steward's per-cycle scan now routes design-only draft PRs to the judge; the next cycle will be the first one to dispatch the design panel in action.

Self-improvement: when two concurrent gardener dispatches land overlapping changes (here: 3159ab and fbb472 ran in parallel and reached contradictory conclusions on the same surface), the second-to-land must resolve explicitly rather than silently overwrite, and the resolution note belongs in the affected skill's notes-from-the-field and in the sweep commit message so the audit trail records which directive superseded which. The liaison can prevent this by serializing gardener dispatches that touch the same skill file, or by inlining the conflict-resolution rule in the second gardener's dispatch prompt when overlap is anticipated.
