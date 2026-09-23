All work is complete and verified. Final test run confirmed 20/20 passing earlier; both the main2 code and the journal2 doc are landed on their respective tips.

## Completion report

**Job:** `improve-sections-table-row-concept-heading` — widen the Sections-table row-inserter so concept pages route through it, removing the recurring by-hand step.

**Root cause:** `insert-sections-table-row.sh` located its target table by matching the heading `^##[ \t]+Sections[ \t]*$` exactly. That matched a topic page's `## Sections` but not a concept page's `## Sections that touch this concept`, so scholars hand-placed concept-page section rows every ingest cycle.

**What I changed (main2, commit `ccf9f6f65`, pushed):**
- `scripts/jobs/insert-sections-table-row.sh` — the heading locator now matches **both** exact forms (`## Sections` and `## Sections that touch this concept`). I enumerated the two exact anchors rather than a loose `Sections\b`/prefix match — deliberately, because `\b` is a gawk extension unavailable under the fleet's `mawk`, and because enumeration guarantees no unrelated heading (e.g. one that merely *begins* with "Sections", like the existing `## Sections (grammar and compiler source)` or a prose `## Sections overview…`) can be picked up as the anchor. The existing table-boundary anchoring (the fix from `improve-sections-table-row-insert-anchor`) is untouched. Header docs updated to name both page kinds.
- `scripts/jobs/test/insert-sections-table-row-test.sh` — added Case 9 (a concept-page `## Sections that touch this concept` table: row inserted at the table boundary, trailing bullets preserved) and Case 10 (a page whose first heading only *starts with* "Sections" is skipped and the real `## Sections` table is found). Suite goes 8→10 cases, **20/20 PASS**.
- `roles/scholar/AGENT.md` — the ingest step now directs concept-page rows through the inserter too, calling out that the by-hand step is removed.

**What I changed (journal2, landed via `land-journal-edit.sh` against tip):**
- `library/conventions.md` — the concept-page shape section now instructs authoring `## Sections that touch this concept` rows through the same deterministic inserter. Built against the `origin/journal2` tip and landed through the producer clone (not the live worktree); verified present on tip.

**Verification:** confirmed the widened match cannot capture an unintended heading (Case 10, plus survey of live corpus: 153 concept pages use the concept variant, 52 topic pages use the bare form). Both page kinds now route through the deterministic inserter.

**Follow-ups:** none required. Note that the one topic page carrying a parenthetical variant heading (`## Sections (grammar and compiler source)`) is still not matched — it was never matched before this change either, so no regression; if it ever needs the inserter, add that third exact form.
