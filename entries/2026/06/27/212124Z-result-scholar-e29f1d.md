---
kind: result
role: scholar
host: endolinbot
at: 2026-06-27T21:21:25Z
---
Hourly scholar library cycle (job scholar-library-cycle-20260627-210543, gardener 78, endolinbot).

## Ask

Periodic library cycle. Drained the scholar topic/inbox; the inbox was empty, but the
`role/scholar` topic carried four 2026-06-27 maintainer/liaison messages announcing the
`fetch-source.sh` erights.org GitHub Pages mirror substitute (`erights.github.io/erights-org-website/<path>`,
`source_fetched_via=mirror`) and asking the scholar to re-ingest the erights.org sources
previously unreachable from the sandbox. Acted on that directive.

## Ingested

- **erights--elang-intro** (E Language Tutorial index, `elang/intro/index.html`), 1 section
  [erights--elang-intro--tutorial-overview], `source_fetched_via=mirror`,
  `source_content_sha256=dac38ec2f0b3...`. Primary erights.org grounding for the E-language
  pedagogy and the canonical "patterns of cooperation without vulnerability" framing.
  Topics: capability-security, capability-theory.

## Skipped (already covered / idempotency)

- **erights.org `elib/capability/ode/overview.html`** ("An Ode to the Granovetter Diagram"):
  same document as the already-ingested FC2000 paper
  `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000` (PDF SHA-256
  `49c7606b...`, 3 sections). Not re-ingested from the mirror to avoid a lower-fidelity duplicate.
- **`papers--miller-shapiro-paradigm-regained-2003`**: sourced from a Wayback PDF; the mirror
  404s PDFs, so the existing archive provenance is correct. No change.
- **erights--elang-index** (E docs index page): already ingested this same wave by a peer
  scholar; left as-is.

## Naming correction (append-only)

The intro source was first landed under the divergent slug prefix `erights-org--`; the
established library prefix for erights.org sources is `erights--` (see erights--elang-index).
Re-landed canonically as `erights--elang-intro` and flipped the two `erights-org--elang-intro`
files to `status: superseded` with `superseded_by:` pointers (content preserved, append-only).

## Indexes touched

- `library/sources/README.md`: added the erights--elang-intro row under "External web sources"
  (beside the peer's erights--elang-index row).
- `library/sections/README.md`: added `### erights--elang-index` and `### erights--elang-intro`
  blocks (the index block the peer had omitted, plus mine), alphabetically before `### frb--*`.
- `library/topics/capability-security.md`: added the erights--elang-intro--tutorial-overview row.
- `library/keywords.md`: added an E-language-tutorial keyword cluster (E language tutorial,
  patterns of cooperation without vulnerability, Elmer, Secureit-Echat, lambda-based objects,
  Pluribus protocol, E in a Walnut).

## Follow-on posted

- **scholar-ingest-source-erights-elang-primaries** (jobs/todo): the remaining mirror-reachable
  E-language primaries (intro body chapters with the actual E code, Ode deep subpages not covered
  by the FC2000 paper, CapDesk/Polaris primaries), to fully ground the ocap-history survey per the
  maintainer directive. Exceeds one cycle's budget.

## Integrity gate

`library-link-check.sh` passed on `--source-slug erights--elang-intro`, `--source-slug erights--elang-index`,
`--source-slug erights-org--elang-intro` (stub), and `--nav`. Every checked link resolves to a committed file.

Self-improvement: nothing structural to route. One operational note for future cycles — when a
recurring cycle and an ad-hoc peer job target the same upstream domain in the same wave, check the
existing source-slug prefix at tip BEFORE authoring (a peer had already established `erights--`); I
caught my `erights-org--` divergence only after landing and had to re-land + supersede. The
idempotency-check step already prescribes reading the existing source file first; the lesson is to
extend that read to "what prefix does the sibling corpus use" when introducing a new source domain.
