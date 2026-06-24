---
ts: 2026-05-15T05:16:04Z
kind: result
role: judge
project: endo-but-for-bots
worktree: dispatches/judge--37d061
prs:
  - repo: endojs/endo-but-for-bots
    pr: 264
    role: target
refs:
  - entries/2026/05/15/044924Z-result-judge-da12e0.md
  - entries/2026/05/15/050920Z-result-fixer-6e81ac.md
to: liaison
---

# Result: design-panel re-convene on #264, loop terminates

PR: endojs/endo-but-for-bots#264, `design(compartment-mapper): import-attributes propagation proposal`, branch `design/compartment-mapper-import-attributes` against `llm`, head `e79247c80` (round 1 ran against `a2f4d7f48`; fixer pushed six commits). Stacked on PR #248 (sibling SES import-attributes design).

Panel kind: design-panel (5 seats: critic, skeptic, copyeditor, pedant, novice). Panel execution: **in-band-fallback**. Each seat's per-juror block was written in-band against `garden/roles/<seat>/AGENT.md` one at a time, then aggregated.

## Verdict

`COMMENTED` (self-PR fallback; `gh pr review --request-changes` blocked because `kriscendobot` is the PR author). The body's terminating-round shape is "Must-fix before merge: None / Should-fix: None"; no dispatch matrix should key on this round for further fixer-loop work. Review submitted at 2026-05-15T05:15:49Z.

Counts:
- must-fix: **0** (verified all 4 round-1 must-fix items addressed)
- should-fix: **0** (verified all 5 round-1 should-fix items addressed)
- out of scope: 5 (3 carried forward from round 1, 2 new this round)

## Verification of round-1 items

**Must-fix (4 of 4 verified addressed):**

1. *`resolvedImports` / `FileModuleConfiguration` today-shape claim.* The new `## Per-import attribute record` framing (design lines 174 to 188) accurately states today's schema records only `location`, `parser`, `sha512`, and names `resolvedImports` as an in-memory/execution-side construct walked by `bundle-lite.js`, `parse-cjs.js`, `policy.js`. Cross-checked against `packages/compartment-mapper/src/types/compartment-map-schema.ts` lines 233 to 238. Schema-bump diff at design lines 491 to 504 frames `imports` as net-new.
2. *Sibling-anchor citations.* All seven sibling-anchor citations (lines 41, 151, 170, 307, 312, 337, 589) point at headings live in PR #248 at its current head `375a3af6`. Verified against the sibling text fetched at the start of this dispatch.
3. *`Status: Draft` not sanctioned.* Now `Proposed` in both the design metadata (line 8) and `designs/README.md` summary-table row (line 143). Totals updated 9 -> 10 Proposed, 2 -> 1 Draft.
4. *`designs/README.md` plan content.* All five sub-items verified: M1 milestone-table entry (line 342), `Module Substrate` dependency-graph subgraph with `sesia --> cmia` (lines 279 to 283), per-design size estimate `M-L, 1 week` (line 631), milestone totals (M1 12->13 remaining, 8-10->9-11 weeks; total 50->51, 51-70->52-71 weeks), cumulative timeline columns shifted +1 week each (M2 12-15->13-16, M3 17-22->18-23, M4 25-33->26-34, M5 39-53->40-54, M6 51-70->52-71). Arithmetic checks out.

**Should-fix (5 of 5 verified addressed):**

1. *SES arity rule paragraph* at design lines 149 to 161, with anchor link to sibling's `## importHook signature` and an explicit "Every later reference ... points back to this paragraph" forward-reference convention.
2. *Policy-attribute-passthrough invariant* added as a `## Test plan` entry at lines 556 to 565, explicitly tied to `## Open questions` § 5.
3. *`moduleMapHook` + attribute-bearing-entry interaction* enumerated as three exhaustive cases at lines 320 to 352. Case 2 (the subtle one) is now explicit: the linker treats `moduleMapHook`'s return as if its caller-side attribute set were empty.
4. *Mermaid intro + missing arrow*: five participants introduced in a numbered list at lines 97 to 119; `pkg->>mod: module source bytes` arrow at line 130.
5. *Prose hygiene*: tense slip fixed (`looked like` -> `looks like` at line 376); partition-table spacing fixed (line 358); carry-rule paragraph collapsed from three repetitive sentences to one (lines 142 to 147).

## Per-seat verdicts (round 2)

- **critic**: comment-only. Round-1 substantive concerns fully addressed; the three-case `moduleMapHook` clarification lands the load-bearing decision.
- **skeptic**: comment-only. Sibling-anchor citations all live; the SES-arity-rule symmetry claim now stated explicitly; policy-passthrough test catalog entry closes the round-1 § 5 gap.
- **copyeditor**: comment-only. Mermaid intro, missing arrow, carry-rule trim, tense slip, table spacing all in place.
- **pedant**: comment-only. `Status: Proposed`; README plan content fully integrated per `designs/CLAUDE.md` § Progress Tracking.
- **novice**: comment-only. Mermaid lifelines introduced before diagram; SES arity rule has fixed referent paragraph; three-case clarification recoverable for a reader who has not held the partition in mind.

## New in-scope must-fix this round

**None.**

## Out-of-scope items

Carried forward from round 1:

- `withAttributes` companion-field name (`## Open questions` § 1): TC39 / Node.js tracker survey before the builder lands the implementation.
- Bundler-rejection test-catalog entry (`## Open questions` § 3): builder-dispatch reminder.
- CommonJS interop story (`## Open questions` § 4): may benefit from a maintainer call.

New this round:

- Migration soft-landing quiet-failure risk: a v0 caller whose graph later gains a `with` clause silently loses attribute information; the arity rule keeps the call valid but the attributes are dropped. Builder-dispatch reminder.
- Test-plan "covers" mapping: small clarity ratchet for the implementation PR's test catalog.

These ride out of the loop as candidate follow-ups, not blockers.

## CI status

**No checks ran on the new head.** Per the fixer's analysis ([`050920Z-result-fixer-6e81ac.md`](050920Z-result-fixer-6e81ac.md)), zero workflow runs on the branch at both `a2f4d7f48` and `e79247c80`; the sibling PR #248 (same `kriscendobot` author) ran the full 4-check matrix successfully when un-drafted. The dispatch prompt explicitly noted this as a pre-existing condition not to block on. Per the judge's loop-termination rule the verdict drives un-drafting; CI behavior post-un-draft is a maintainer-side concern if it does not fire.

## Un-draft status

**Un-drafted.** `gh pr ready 264 -R endojs/endo-but-for-bots` ran successfully at 2026-05-15T05:16Z. PR state is now `isDraft: false`, `state: OPEN`. The judge's loop-termination rule applies (zero in-scope must-fix items, terminating verdict reached).

## References

- Round-1 verdict: [`044924Z-result-judge-da12e0.md`](044924Z-result-judge-da12e0.md).
- Fixer's address-pass: [`050920Z-result-fixer-6e81ac.md`](050920Z-result-fixer-6e81ac.md).
- Round-2 formal review on the PR: posted via `gh pr review --comment` at 2026-05-15T05:15:49Z.
- Design under review: `designs/compartment-mapper-import-attributes.md` (687 lines at the new head).
- Sibling design: PR #248, `design/ses-import-attributes`, current head `375a3af6` (un-drafted).

## Library look-ups

None; the panel re-convene was a re-verification of round-1 items against the fixer's diff plus a fresh end-to-end pass per seat. No new keywords or concept-page edits warranted.

Self-improvement: the in-band-fallback procedure's round-2 form deserves a paragraph in `garden/skills/panel-review/SKILL.md` (or in `garden/roles/judge/AGENT.md` § In-band fallback). The verification step that distinguishes a round-2 in-band run from a round-1 one is "walk the round-1 findings against the new head before writing fresh per-seat blocks", and the discipline of opening the verification section above the per-seat findings keeps the loop-termination decision auditable. Lesson candidate: a one-line addition to the in-band fallback procedure noting that round-2 verification should land as a labeled section ahead of the per-seat blocks so a future merged-PR feedback watch can grep for the verification audit trail.
