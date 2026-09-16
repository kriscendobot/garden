---
created: 2026-09-16
author: gardener
---

# Skill: Botese normalization

## Purpose

The single documented home for the **Botese** rule set the garden normalizes
*away from*: the auditable phrase list of AI-slop clichés, the exclusion
discipline (what NOT to touch), and the machine-readable data file that both the
[thesaurus](../../roles/jurors/thesaurus/AGENT.md) jury seat-gate and the
[deslopper](../../roles/deslopper/AGENT.md) fixing role consume. The phrase data
lives here, in one file, so the rule set is auditable and extensible from a single
place — exactly as the origin directive asked (kriskowal, GitHub review comment
`endojs/endo-but-for-bots` PR 1281, `discussion_r4028527867`, 2026-09-16: "The
gauntlet should have caught this automatically, in the same manner as
deterministically detecting British English spellings and agentically fixing them
in a loop. Please dispatch a job to add a thesaurus role to the jury panel for all
the known words of Botese like seam, load-bearing, and so on.").

"Botese" is the maintainer's term for the dialect of AI-slop cliché — the tics an
LLM reaches for reflexively ("this is the *seam* where…", "the *load-bearing*
invariant is…") in place of saying the thing plainly. This skill is a **direct
structural port of** [american-english-normalization](../american-english-normalization/SKILL.md)
(design: [designs/american-english-spelling-panel.md](../../designs/american-english-spelling-panel.md))
— same shape (a curated data file, a deterministic seat-gate grep, a cost-gated
jury seat, a myrmidon-tier fixing loop), a different word/phrase domain. Where that
skill catches British *spellings*, this one catches Botese *phrases*.

## Scope

This is a **garden/house convention scoped to maintainer-authored (bot +
maintainer) prose**, exactly like the American-English list and the other
garden-only prose conventions ([em-dash-style](../em-dash-style/SKILL.md),
[no-latin-shorthand](../no-latin-shorthand/SKILL.md)). It applies to garden-authored
prose (`roles/*/AGENT.md`, `skills/*/SKILL.md`, `designs/*.md`, `CLAUDE.md`, and the
like) and to the maintainer-authored (bot + maintainer) source and prose the panel
reviews on a project fork.

It is **NOT** imposed on external contributors: on an external-author PR the
thesaurus seat's findings downgrade to `drop`
([panel-review](../panel-review/SKILL.md) § External-author calibration), the same
way em-dash, Latin-shorthand, and American-English findings do. External
contributors follow the project's own house rules. Vendored content under
`references/<source>/`, already-committed journal entries, quoted upstream text,
fixtures, and generated output are left as-is.

## The data file: `cliches.tsv`

`cliches.tsv` (co-located) is the auditable rule set: a **curated, explicit phrase
list**. Four TAB-separated columns, one cliché per row, `#`-comment and blank lines
ignored:

| column       | meaning                                                              |
| ------------ | ------------------------------------------------------------------- |
| `category`   | `filler-emphasis`, `overwrought-metaphor`, … (a coarse grouping)     |
| `phrase`     | the literal, usually **multi-word** phrase to detect                |
| `suggestion` | the rewrite direction — what to write instead                       |
| `notes`      | false-friend cautions, the legitimate literal sense, provenance     |

**Every row is an enumerated literal phrase, never a suffix pattern or a heuristic**
— the same "comprehensive list, not patterns" decision `divergences.tsv` made
(PR #75). But where the spelling list matches whole *words*, this list matches whole
*phrases*: precision comes from the distinctive **construction**, not a bare word.

### Why phrases, not words (the decision that keeps this precise)

"seam" and "load-bearing" are ordinary words with genuine literal uses — a real
architectural seam, a Michael-Feathers testing "seam", a real load-bearing wall.
Bare-word matching would fire on all of those, and a false positive that rewrites a
legitimate sentence is worse than a missed cliché. So the list enumerates the
distinctive **cliché collocation** (`load-bearing invariant`, `seam where`) that the
literal senses do not share. This is the load-bearing difference from the spelling
port: a British spelling like `colour` is a divergence *wherever it appears in
prose* (the only exceptions are structural — identifiers, quotes), so its grep can
match a bare word; a Botese word is a cliché only in a *specific construction*, so
its grep must match a phrase.

Two layers of precision, exactly as the spelling mechanism has:

1. **The grep matches only a curated multi-word phrase.** It can never fire on a
   bare "seam" or "load-bearing".
2. **The thesaurus seat (a `claude -p`) adjudicates every hit.** Even a matched
   phrase can sit inside a quote, an identifier, or a genuinely literal sentence;
   the seat accepts those with rationale, exactly as the orthographer seat accepts a
   British spelling inside an upstream identifier.

## Exclusion discipline (precision over recall)

- **Never add a bare common word.** A phrase is only ever a *construction* distinct
  enough that its literal senses do not collide with it. `load-bearing` alone,
  `seam` alone — excluded by construction.
- **Keep the literal senses safe.** Real load-bearing structural elements (`wall`,
  `beam`, `column`, `member`), a real fabric/rock seam, and the established
  software-testing "seam" (Feathers) are legitimate; the enumerated collocations do
  not name them, and the seat accepts any that slip through the phrase net.
- **No pattern rows at all.** A Botese cliché the list has not yet enumerated is
  caught not by a heuristic but by a gardener/maintainer adding the literal phrase
  row (curation, below).

## Curation

The list grows **only** by adding literal phrase rows, and each extension is
**maintainer-reviewed** — mirroring the American-English list. A gardener surfaces a
candidate through a thesaurus `[proposed-rule]` finding; a human vets it before it
lands. Gardeners do not unilaterally widen the shipped list. When adding a row, keep
the phrase specific (a construction, not a word), add inflected collocations as
their own rows (matching is whole-phrase, so `load-bearing invariant` does not also
catch `load-bearing invariants`), and double-check the phrase cannot fire on a
legitimate literal sentence.

## How the data file is consumed

- **The seat-gate grep** — `scripts/jobs/gardening/thesaurus-cliche-grep.sh`
  (no LLM). Reads `cliches.tsv`, computes the diff's **added lines** against the
  base, whitespace-normalizes each, and whole-phrase/case-insensitively matches each
  `phrase`, emitting `<path>:<line>: <phrase> [<category>] rewrite: <suggestion>`,
  one line per occurrence. It casts a wide net (all added text lines) and does not
  try to distinguish a genuine literal use from a cliché — that precision is the
  seat's job. Exit 0 iff ≥1 candidate; exit 1 clean/no-base; exit 2 cannot-determine.
  This same exit gates any deslopper dispatch: zero candidates means nothing is
  dispatched.
- **The thesaurus seat** (`seat-gate-thesaurus.sh` wraps the grep and spends a
  `claude -p` only on a hit) adjudicates each candidate into a finding (real Botese
  cliché in prose, with a concrete rewrite), an accept-with-rationale (a genuine
  literal use / identifier / quoted text / fixture the change does not own), or a
  `[proposed-rule]` note (a real cliché not yet on the list).
- **The deslopper role** applies the vetted rewrites and re-runs the grep until
  every residual candidate is a recorded leave-as-is (the deterministic fixpoint
  loop).

## Output shape

The grep's `report` digest is the shared currency: one line per occurrence,
`<path>:<line>: <phrase> [<category>] rewrite: <suggestion>`, plus a trailing
`summary: N candidate(s) across M file(s)`. It is the seat's input and the fixer's
dispatch payload, unchanged.

## Notes

- **Whole-phrase matching only**, with non-word boundaries at both ends: `seam
  where` matches "the seam where" and "Seam Where" but not `seamwhere` or a phrase
  embedded in a larger token. Runs of whitespace are collapsed before matching, so
  `load-bearing   invariant` still matches; a phrase split across two lines does not
  (the grep is line-oriented — add the single-line form as a row if it recurs).
- The grep is case-insensitive for detection; the deslopper preserves sentence
  casing when it rewrites.
- Unlike a spelling fix, a Botese fix is a **rephrase, not a token swap**: the
  matched phrase is removed or reworded per the `suggestion`, so the re-grep no
  longer matches it. The closed-list convergence argument is otherwise identical to
  the American-English loop's.
