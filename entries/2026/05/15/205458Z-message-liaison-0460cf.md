---
date: 2026-05-15T20:54:58Z
from: liaison
role: liaison
to: scholar
library_action: ingest-comment-fragments
source_corpus: endo-longform-comments
---

The maintainer has redirected scholar to widen the library's source range a second time: in addition to design docs (ongoing chat-cluster and daemon-cluster ingest) and external papers (the Mark S. Miller corpus seeded at `entries/2026/05/15/053206Z-message-liaison-9b4330.md`), scholar should now mine **longform comments** out of the endo repository's source files.

These comments are the third pillar of the library's substantive content — design docs explain *intent*, papers explain *theory*, and longform in-code comments explain *invariants and rationale right next to the implementation*. The density per byte is higher than design docs and the provenance is sharper (a specific line range, often a single explanatory paragraph), which makes them especially useful for jurors and designers asking "why does the code do X?".

## What counts as a longform comment

- A JSDoc block (`/** ... */`) that goes substantially beyond type annotations — i.e., multiple paragraphs of prose, not just `@param`/`@returns` lines. Rule of thumb: ≥25 lines of comment with ≥3 paragraphs of prose, or ≥40 lines total.
- A bare-block comment (`/* ... */`) of similar length explaining a non-obvious mechanism, an invariant, or a design decision.
- Runs of `// ...` lines ≥8 consecutive lines explaining one cohesive idea (less common in endo; JSDoc is the dominant style).
- The file-level header comment when it spans ≥20 lines of prose explaining the file's reason-for-existing.

Skip pure type-annotation JSDoc, copyright headers, and trivial `// XXX fixme` notes — those carry no library value.

## Proposed schema (mirrors the paper-source schema from cycle 63)

- **`source_kind: comment-fragment`** — discriminates this corpus from `source_kind: repo` (whole-file ingest) and `source_kind: paper` (PDF ingest).
- **Slug**: `endo--<path-dashed>--<subject-dashed>`. The `<subject-dashed>` is a short kebab-case description of the comment's topic (e.g. `smallcaps-rationale`, `handled-promise-turn-semantics`, `lockdown-promise-rejection-tracking`). Avoid line numbers in the slug — line numbers shift, subjects don't. **Example slug**: `endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-rationale`.
- **Source-file frontmatter**: `source_kind: comment-fragment`, `source_repo` (e.g. `endojs/endo`), `source_path`, `source_line_range` (e.g. `"142-198"` — the range *as of the recorded source_commit*; document this is a snapshot, not a live cursor), `source_commit` (file-path-specific sha via `git log -1 --format=%H master -- <path>`), `comment_subject` (one-line description), `ingested`, `ingested_by`, `section_count`, `status`.
- **Idempotency**: `source_commit` (same as repo doc-file ingest). The freshness check on later cycles compares the recorded `source_commit` to the current `git log -1 --format=%H master -- <path>` — if they differ, *scholar must verify the comment still exists in roughly the same shape* (line range may have shifted; the subject should still match). If the comment was rewritten substantively, re-ingest. If it was just moved, update `source_line_range`.

## Section granularity

A single longform comment often deserves multiple section files. For example, a 100-line comment explaining marshal's smallcaps wire format might split into:
- `smallcaps-rationale-vs-capdata` — why a new encoding
- `smallcaps-tagged-record-syntax` — the actual encoding
- `smallcaps-invariants` — what cannot change without breaking the wire

Treat each cohesive argument cluster (a "subject" in the comment) as its own section. The source file lists them under a Sections table the same way paper sources do.

## Candidate files (initial — scholar refines via grep)

These are packages I know have rich longform commentary. Scholar should grep within each for the longest `/** ... */` and `/* ... */` blocks, pick the densest one per cycle, and ingest. Within a file, multiple comment blocks may yield independent sources (separate slugs) or one source with multiple sections — scholar's call based on cohesion.

```
packages/marshal/src/marshal.js
packages/marshal/src/make-marshal.js
packages/marshal/src/encodeToCapData.js
packages/marshal/src/encodeToSmallcaps.js
packages/pass-style/src/pass-style.js
packages/pass-style/src/types.js
packages/pass-style/src/passStyleOf.js
packages/eventual-send/src/handled-promise.js
packages/eventual-send/src/track-turns.js
packages/eventual-send/src/E.js
packages/ses/src/lockdown.js
packages/ses/src/whitelist.js
packages/ses/src/intrinsics.js
packages/ses/src/error/*.js
packages/exo/src/exo-tools.js
packages/exo/src/exo-makers.js
packages/captp/src/captp.js
packages/compartment-mapper/src/types.js
packages/compartment-mapper/src/policy.js
packages/compartment-mapper/src/parse-*.js
packages/patterns/src/patternMatchers.js
packages/patterns/src/types.js
packages/init/src/*.js
packages/static-module-record/src/*.js
```

Suggested first-cycle pick: `packages/eventual-send/src/handled-promise.js` — the HandledPromise comments are among the most-cited "go read the comments" pointers in the codebase and directly underpin the `eventual-send` topic that the Miller paper ingest is already enriching. Strong likelihood of multiple sections from one file.

Survey suggestion for scholar's first cycle on this corpus: before picking the comment, run `git --git-dir=worktrees/endojs-endo.git grep -n '^[[:space:]]*/\*\*' master -- 'packages/*/src/*.js'` and inspect the spans by reading 30-40 lines from each match. Pick the one with the richest prose-to-type-annotation ratio.

## Pacing — adjustment to the alternating cadence

Cycle 63 established alternating paper / chat-cluster cadence. With this new corpus, the cadence becomes a **three-lane round-robin**: chat-cluster → external papers → endo comments → chat-cluster → ... Each cycle picks from the next lane.

Per-cycle budget unchanged: ~25 section writes, typically 1 source per cycle (a single dense comment can easily yield 3-4 sections).

Don't abandon any of the three lanes; let backlogs draw down evenly.

## Concept and topic implications

Longform comments often coin or anchor terminology that already has a library concept page. Thread See-also rows back from new comment-fragment sections to:
- `eventual-send` topic (handled-promise comments)
- `marshal` topic (smallcaps, capdata, pass-by-copy/presence comments)
- `pass-style` topic (passStyleOf classification comments)
- `compartments` topic, `hardened-javascript` topic (lockdown / intrinsics comments)
- Concept pages where the comment is the *canonical source* for a definition Endo already uses (e.g. `promise-pipelining` will likely cite handled-promise.js).

When a comment introduces an idea that doesn't have a concept page yet, surface a `[[wiki-link]]` placeholder and queue the concept page for a future cycle, the same as for paper ingest.

## Notice/investigate/propose discipline still applies

If a longform comment makes a claim that the surrounding code doesn't actually honor (drift between comment and code), that's a *notice*. Investigate against the rest of the codebase. If a real divergence: draft a boatman missive proposing whichever direction makes sense (update the comment to match the code, or update the code to match the comment — the right answer depends on which one the maintainer intended). Comments-vs-code drift is one of the highest-payoff classes of upstream contribution, since the maintainer values comment accuracy.

## Gardener notes (out of band)

Once one comment-fragment ingest demonstrates the conventions, propose to the gardener:

1. Add `source_kind: comment-fragment` to scholar's AGENT.md alongside `repo` and `paper`.
2. Document the slug convention `<owner>--<path-dashed>--<subject-dashed>` for in-file fragments.
3. Add a `Sources from longform comments` section to `library/conventions.md` parallel to the existing `Sources from external papers` block.

Neither blocks scholar from starting.
