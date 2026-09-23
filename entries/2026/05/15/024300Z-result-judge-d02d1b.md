---
ts: 2026-05-15T02:43:00Z
kind: result
role: judge
to: general-contractor
project: endo-but-for-bots
worktree: dispatches/judge--14e5ac/project
refs:
  - entries/2026/05/15/023800Z-dispatch-general-contractor-14e5ac.md
  - entries/2026/05/15/023644Z-result-fixer-a3fc5b.md
  - entries/2026/05/15/021800Z-result-judge-60d499.md
---

# Result: judge 14e5ac — PR #241 design-panel verification round (loop terminates)

PR: endojs/endo-but-for-bots#241 `design: familiar/host run applications over a VFS` (head `2d187d912d634c7f9ecdab3a85334de670cdb2b9`; branch `design/familiar-run-vfs-apps`).

Five-seat design panel (critic, skeptic, copyeditor, pedant, novice) re-convened on the address-pass head to verify the round-1 verdict (review id `PRR_kwDORRE4FM7__WW7`).  Submitted as one formal `gh pr review --comment`; review id `PRR_kwDORRE4FM7__vXy`.  PR un-drafted via `gh pr ready 241`; PR is now OPEN, no longer draft.

- Panel execution: in-band-fallback (harness exposed no `Agent` tool; verified via `ToolSearch` per § In-band fallback step 1; seats written one at a time against role files, then aggregated).
- Panel kind: design-panel.
- Verdict: comment.  (Self-authored PR; GitHub blocks `--request-changes`.  No in-scope must-fix carries termination.)
- Must-fix: **0** in-scope.
- Should-fix: **1** new in-scope (OQ4 internal contradiction; non-blocking).
- Out-of-scope: 6 round-1 carryovers (POSIX-sandbox tracking issue, `endor-run-expanded` Form-3 implicit dependency surface, OQ1/OQ4 interactions, serial-comma normalization, README milestone-1 row diff-hygiene, worked-example walkthrough) plus one new minor (`Posix` lowercase in untouched README milestone-1 lead-in prose).

## Per-seat verification finding

| Seat | Verification |
|------|--------------|
| critic | Address pass is substantively sound.  M1 (Purpose restructure) closed in `c3f55404f`; M3 (registry-table-stability precondition + operator patterns) closed in `64caa0869`; S1-S5 (resolution algorithm and policy) closed in `9cefc2666` and `da45c638d`.  Chosen approach remains correctly weighed; alternatives section untouched and still fair.  One new in-scope finding: OQ4 now reads as a confirmation of a body-committed policy, which is internally circular (see *New finding* below). |
| skeptic | Premise attacks of round 1 land in the address pass.  M3's registry-table-stability precondition is now explicit and the failure mode ("silent transitive drift") is named; § Ingestion failures (S4) names `IngestionError` via `@endo/errors` with CAS-content-addressed rollback semantics; the six-test catalog (S6) exercises the failure paths.  No new premise attack surfaces; the new claims are stronger than the design surface needs but internally consistent.  En-dash in README (S19) repaired. |
| copyeditor | Prose mechanics clean.  S7 (Case 2 step 4 voice/tense) rewritten active and step 5 added for scratch GC; S8 (Case 1→Case 2 bridge) added; S9 (Glossary Ejection cross-reference); S10 (slash-construction in § Endor cross-references); S11 (Go-mod-shape bridge before bullets); S12 (elided runtime phase) — all closed.  New paragraphs (peer/optional policy, ingestion failures, cross-major-version migration) are well-constructed with parallel sentence structure and no tense drift. |
| pedant | Formal style consistent.  S14-S20 (heading case, H1 spaced slash, VFS introduction, `Posix`→`POSIX`, `Case 1`/`Case 2` convention, README en-dash for "2-3 weeks", `Updated` metadata row) all closed in `e84121907` and `2d187d912`.  Em-dash discipline preserved (no em-dashes introduced anywhere in the nine-commit diff); relative-paths discipline preserved (cross-references remain bare filenames).  `POSIX` appears 8 times consistently in the body; `Case 1`/`Case 2` proper-noun-style with `case-1`/`case-2` lowercase-hyphenated as compound adjectives is internally consistent. |
| novice | Top-down clarity holds.  M1 (Purpose) parses for a naive reader (three short paragraphs, sub-case anchored at one-sentence depth, forward reference); M2 (load-bearing terms) all defined in Glossary with one-line glosses and cross-references; S13 (CAS expansion) closed.  Logical progress from § Purpose through § Dependencies is unbroken.  The new `cap-std` parametrisation-seam paragraph in § Case 1 § Shape is dense but parses; below should-fix threshold. |

## New in-scope finding (should-fix, non-blocking)

The address pass introduced a minor internal contradiction in Open question 4.  The body now commits a policy (peers fail-closed at compartment-map build time, optionals best-effort with runtime missing-module error), and OQ4 reads:

> ... This question is a maintainer confirmation rather than an open choice; if the maintainer prefers a different policy, the body needs revision.

An open question whose answer is "see body" is no longer an open question.  Recommendation (not blocking): either (a) remove OQ4 from `## Open questions for the maintainer` and let the body's committed policy stand, or (b) restore OQ4 to its original open form and back the body off the committed policy until the question resolves.  (a) is the cleaner cut; (b) the more conservative option.  Surfaced for the maintainer's eye in the verdict rather than blocked the loop because the design is internally consistent under either resolution and the maintainer reading body + OQ4 together can derive intent.

## Loop termination

Per `roles/judge/AGENT.md` § Operating norms ("Decide loop termination") and `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop, no in-scope must-fix → terminating verdict.  `gh pr ready 241 -R endojs/endo-but-for-bots` ran; PR is now OPEN (not draft).  The bot-side PR-creation-flow chain is complete for #241; next venue is the maintainer's review queue.

## Verdict body posted

Review id `PRR_kwDORRE4FM7__vXy` submitted at 2026-05-15T02:42:36Z by kriscendobot (the bot identity is also the PR author; the self-review fallback is `--comment` with the explicit "No in-scope must-fix" signal in the body for the orchestrator's dispatch matrix).  Verdict body is 1228 words, within the design-panel target band (600-1000 words with the ~25% tolerance the role file names; the verification round carries an extra eighteen-finding closure table that pushes the count over the upper bound).

## Self-improvement

Below threshold for a structural lesson.  One observation: a design-panel verification round's body benefits from a per-finding closure table (the "Should-fix items (15 of 15 closed)" pattern this verdict uses) more than a code-panel verification round's body would, because design-panel findings are typically more numerous and more granular (each prose-mechanic should-fix is its own row, vs the code panel's tendency to bundle "naming throughout file X" into one row).  A future codification might land this as a half-sentence in `skills/panel-review/SKILL.md` § Aggregation: "Verification-round aggregations may exceed the per-round word budget when the closure table is dense; the role file's ~25% tolerance applies, but the closure table's information density is the load-bearing payload and should not be trimmed to fit."  Not a structural lesson; below the threshold for a `message` to `liaison`.  If two more design-panel verification rounds land the same shape independently, that is a stronger signal worth surfacing.

Self-improvement: a closure-table pattern for verification-round verdicts is emerging.  Below threshold for a message to liaison; will resurface if it lands again independently.
