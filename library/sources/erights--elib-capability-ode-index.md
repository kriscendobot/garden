---
source_kind: web
source_url: http://erights.org/elib/capability/ode/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/capability/ode/index.html
source_fetched_via: mirror
source_content_sha256: 9763047ff7ebe0fcc52b55c613146634b96c1420fd1c9692314cb314e4b7ab4f
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_date: 2000-01-01
ingested: 2026-06-28
ingested_by: scholar
section_count: 0
status: current
notes: >
  HTML-form POINTER, not a re-ingest. This is the web walkthrough of the paper
  already ingested as papers--miller-morningstar-frantz-capability-based-financial-instruments-2000.
  Same content, same abstraction level, different form (multi-page HTML vs PDF),
  so re-transcribing its chapters would duplicate the paper's sections against
  the maintainer's efficient-context directive. This source page records the
  erights.org mirror provenance and maps the HTML chapter URLs to the existing
  paper sections so a reader who lands on an erights ode URL navigates to the
  already-ingested material. Per-chapter HTML expansion is available only if a
  reader needs finer granularity than the paper's three collapsed sections; that
  is deferred to scholar-ingest-erights-2.
---

The web (HTML) form of *Capability-Based Financial Instruments*, also titled
*An Ode to the Granovetter Diagram*, by Mark S. Miller, Chip Morningstar, and
Bill Frantz (to appear in Financial Cryptography 2000). **This is the same
document already ingested in full as the paper source
[papers--miller-morningstar-frantz-capability-based-financial-instruments-2000](papers--miller-morningstar-frantz-capability-based-financial-instruments-2000.md)**
(from the Agoric PDF mirror). This source page exists to (1) record the
erights.org GitHub Pages mirror provenance the job asked for and (2) map the
HTML walkthrough's chapters to the canonical paper sections, so the library does
not carry the same argument twice. It deliberately has no section files of its
own.

## HTML chapter map to the canonical paper sections

The HTML series splits the paper into per-perspective chapters. The library's
paper ingest deliberately collapses the seven paper sections into three
argument-cluster sections (foundations + rights amplification; the canonical
money example; distributed enactment + rights taxonomy + smart contract). The
mapping:

| HTML chapter (erights mirror) | Canonical library section |
|---|---|
| `overview.html` — Abstract, Intro, & Six Perspectives | [granovetter-six-perspectives-and-object-capability-model](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model.md) |
| `ode-objects.html` — From Functions To Objects | [granovetter-six-perspectives-and-object-capability-model](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model.md) |
| `ode-capabilities.html` — From Objects To Capabilities (incl. the Simple Money Example) | [mint-purse-money-and-six-security-properties](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties.md) |
| `ode-protocol.html` — Capabilities as a Cryptographic Protocol (Pluribus) | paper: [pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) — also ingested verbatim as HTML section [erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol](../sections/erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md) (2026-06-27) |
| `ode-pki.html` — Capabilities as a Public Key Infrastructure | paper: [pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) — also ingested verbatim as HTML section [erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure](../sections/erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure.md) (2026-06-27) |
| `ode-game.html` — Capabilities as a Vast Multiplayer Game | [pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) |
| `ode-bearer.html` — From Capabilities To Financial Instruments | [pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) |
| `ode-ack.html` / `ode-references.html` — Acknowledgments and References | (front-matter; not separately ingested) |

The chapter index also links `ode.pdf` (a print-form PDF "a bit out of date");
that PDF 404s on the GitHub Pages mirror and is superseded by the canonical
Agoric-mirror PDF recorded on the paper source.

## Note on the two already-ingested ode chapters

A prior cycle (2026-06-27) ingested two of the HTML chapters verbatim as their
own section files: `ode-protocol.html` →
[erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol](../sections/erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md)
and `ode-pki.html` →
[erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure](../sections/erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure.md).
Those two sections overlap the FC2000 paper's
`pluribus-rights-taxonomy-and-covered-call-option` section (same content, HTML
chapter form). They are kept (the journal is append-only); a future
consolidation pass could soft-flag them against the paper section. This index
page deliberately does **not** add the remaining chapters as new sections, to
avoid widening that overlap; per-chapter expansion of the rest is deferred to
`scholar-ingest-erights-2` only if a reader needs finer granularity than the
paper's three collapsed sections.

## Provenance

- Index page fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/capability/ode/index.html`.
- Content SHA-256 `9763047ff7ebe0fcc52b55c613146634b96c1420fd1c9692314cb314e4b7ab4f`, 8228 bytes.
