---
created: 2026-09-05
updated: 2026-09-05
author: gardener
---

# Skill: American-English normalization

## Purpose

The single documented home for the British->American spelling divergence rule
set the garden normalizes toward: the auditable word list, the exclusion
discipline (what NOT to touch), and the machine-readable data file that both the
[orthographer](../../roles/jurors/orthographer/AGENT.md) jury seat-gate and the
[americanizer](../../roles/americanizer/AGENT.md) fixing role consume. The word
data lives here, in one file, so the rule set is auditable and extensible from a
single place — exactly as the origin directive asked (kriskowal, review
`pullrequestreview-5045909300` on `endojs/endo-but-for-bots` PR 282: "paneling a
jury to grep for common divergence from British English and dispatch a job with a
dedicated role for addressing these digressions").

Design of record: [designs/american-english-spelling-panel.md](../../designs/american-english-spelling-panel.md).

## Scope

This is a **garden/house convention scoped to maintainer-authored (bot +
maintainer) work**, adopted 2026-09-05, exactly like the other garden-only prose
conventions ([em-dash-style](../em-dash-style/SKILL.md),
[no-latin-shorthand](../no-latin-shorthand/SKILL.md)). It applies to
garden-authored prose (`roles/*/AGENT.md`, `skills/*/SKILL.md`, `designs/*.md`,
`CLAUDE.md`, and the like) and to the maintainer-authored (bot + maintainer)
source and prose the panel reviews on a project fork.

It is **NOT** imposed on external contributors: on an external-author PR the
orthographer's findings downgrade to `drop`
([panel-review](../panel-review/SKILL.md) § External-author calibration), the same
way em-dash and Latin-shorthand findings do. External contributors follow the
project's own house rules. Vendored content under `references/<source>/`
(everything but our own README files), already-committed journal entries, quoted
upstream text, fixtures, and generated output are left as-is.

## The data file: `divergences.tsv`

`divergences.tsv` (co-located) is the auditable rule set: a **comprehensive,
explicit, curated word-pair list**. Four TAB-separated columns, one divergence
per row, `#`-comment and blank lines ignored:

| column     | meaning                                                              |
| ---------- | ------------------------------------------------------------------- |
| `category` | `ise-verb`, `isation-noun`, `our-or`, `re-er`, `ll-doubling`, `ll-single`, `ce-se`, `ogue-og`, `ae-oe-e`, `irregular-plural`, `misc`, `briticism` |
| `british`  | the literal whole word to detect                                    |
| `american` | the replacement                                                     |
| `notes`    | false-friend cautions, examples, provenance (optional)              |

**Every row is an enumerated literal whole-word pair — never a suffix pattern or
heuristic** (PR #75 decision: "we should be able to make a comprehensive list and
not simply patterns"). Every inflected form is its own row (`serialise`,
`serialised`, `serialising`, `serialiser`, `serialisation` are five rows, not one
`-ise` rule). This is what makes the set a **closed list** a deterministic grep
enumerates exhaustively, so a dispatch leaves little room for a case to be
forgotten (design § Search-gated dispatch).

## Exclusion discipline (precision over recall)

A false positive that rewrites a real word is worse than a missed divergence, so
the list is an **allow-list**: the grep can only ever match a word a curated row
already names. Rows that must **never** be added:

- **Always-`-ise` words are NOT divergences** and never enter the list:
  `surprise`, `advertise`, `exercise`, `comprise`, `advise`, `arise`,
  `compromise`, `disguise`, `franchise`, `improvise`, `merchandise`, `supervise`,
  `televise`, and kin. American English keeps the `-ise` here.
- **`-re`/`-our` false friends** kept as-is: `genre`, `acre`, `massacre`,
  `mediocre`, `macabre`, `ogre`; `contour`, `velour`, `glamour`, `devour`,
  `four`, `hour`, `pour`, `tour`, `your`. These are why `-re`/`-our` ship as
  enumerated literal word rows, never a blanket suffix transform.
- **SI unit spellings** where the metric standard is the `-re` form (`metre`,
  `litre`) are deliberately omitted: international technical writing follows the
  SI spelling, so normalizing them would work against the "clearer to an
  international audience" goal, not for it.
- **No suffix or pattern rows at all** (PR #75 decision). A British spelling the
  list has not yet enumerated is caught not by a heuristic but by a
  gardener/maintainer adding the literal row (curation, below).

## Curation

The list grows **only** by adding literal rows, and each extension is
**maintainer-reviewed** (PR #75, decision 3b). A gardener surfaces a candidate
through an orthographer `[proposed-rule]` finding (design § The orthographer
seat); a human vets it before it lands. Gardeners do not unilaterally widen the
shipped list. When adding a row, add every inflected form as its own row and
double-check it is not an always-`-ise` word or a `-re`/`-our` false friend.

## How the data file is consumed

- **The seat-gate grep** — `scripts/jobs/gardening/orthographer-divergence-grep.sh`
  (no LLM). Reads `divergences.tsv`, computes the diff's **added lines** against
  the base, and whole-word/case-insensitively matches each `british` token,
  emitting `<path>:<line>: <british> -> <american> [category]`, one line per
  occurrence. It casts a wide net (all added text lines) and does not try to
  distinguish identifier from prose — that precision is the seat's job. Exit 0
  iff >=1 candidate; exit 1 clean/no-base. This same exit gates any americanizer
  dispatch: zero candidates means nothing is dispatched.
- **The orthographer seat** (`seat-gate-orthographer.sh` wraps the grep and spends
  a `claude -p` only on a hit) adjudicates each candidate into a finding (real
  divergence in prose/comment/doc/string), an accept-with-rationale (identifier /
  upstream API / quoted text / fixture the change does not own), or a
  `[proposed-rule]` note (a real divergence not yet on the list).
- **The americanizer role** applies the vetted replacements and re-runs the grep
  until it returns zero candidates (the deterministic fixpoint loop).

## Output shape

The grep's `report` digest is the shared currency: one line per occurrence,
`<path>:<line>: <british> -> <american> [category]`, plus a trailing
`summary: N candidate(s) across M file(s)`. It is the seat's input and the
fixer's dispatch payload, unchanged.

## Notes

- Whole-word matching only: `colour` matches `colour` and `Colour` but not
  `colourblindness`-style compounds unless that compound is its own row. This is
  deliberate precision; add the compound as a literal row if it recurs.
- The grep is case-insensitive for detection but the americanizer preserves the
  observed casing when applying (`Colour` -> `Color`, `colour` -> `color`).
