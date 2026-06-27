# scholar-ingest-source: erights.org Ode subpages, CapDesk/Polaris, and the HPL PDFs

Continues `scholar-ingest-source-erights-elang-remainder` (which ingested
`elang/intro/starting-e.html` and `elang/intro/quickE.html` as
`source_kind: web` / `source_fetched_via=mirror` sources, 5 sections total).
What remains from the original `erights-elang-primaries` -> `-remainder` chain,
re-scoped with recon findings so the next cycle does not rediscover them.

## Evaluate-before-ingest: the "Ode to the Granovetter Diagram" subpages

The mirror's `elib/capability/ode/index.html` enumerates MORE chapters than the
prior job named. The full Ode chapter list on the mirror (all probed 200):

- `ode-objects.html` ("Objects")
- `ode-capabilities.html` ("Capabilities") — ALREADY covered at higher fidelity
  by `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`
  (do NOT re-ingest).
- `ode-protocol.html` ("Cryptographic Protocol")
- `ode-pki.html` ("Public Key Infrastructure")
- `ode-game.html` ("Game")
- `ode-bearer.html` ("Financial Instruments")
- `ode-ack.html` ("Acknowledgments") — probably skip (acknowledgments).
- `ode-references.html` ("References") — bare bibliography, skip.
- `ode.pdf` — the whole-paper PDF (the FC2000 paper). The library already has the
  FC2000 paper, so the PDF is redundant; the per-chapter HTML is the only reason
  to revisit Ode.

The FC2000 paper source currently has exactly 3 sections:
`granovetter-six-perspectives-and-object-capability-model`,
`mint-purse-money-and-six-security-properties`,
`pluribus-rights-taxonomy-and-covered-call-option`. So the crypto-substrate
chapters (`ode-protocol`, `ode-pki`) are the likeliest to carry material the
paper's 3 sections OMIT — evaluate those two first. `ode-objects` very likely
overlaps the granovetter/object-capability section (evaluate, probably skip or
soft-flag). `ode-game` and `ode-bearer` map to the money/financial-instruments
sections (probably covered; evaluate). Ingest only the chapters that add material
beyond the 3 paper sections; soft-flag cross-source overlap rather than
duplicating. Budget likely 1 cycle (2-4 sections at most).

## Confirm-then-ingest: CapDesk and Polaris primaries are NOT on the erights mirror

Recon finding (2026-06-27): the erights.github.io mirror does NOT carry CapDesk
or Polaris primary pages. `capdesk/`, `polaris/`, `elib/capability/capdesk/`,
`smart-magic/` all 404 on the mirror. The erights.org home page links CapDesk to
an EXTERNAL Combex site: `http://www.combex.com/tech/index.html` (Combex was Marc
Stiegler's company; the CapDesk/Polaris primary docs lived there, not on
erights.org). Polaris is not linked from the elang/elib/capability index pages at
all.

So the CapDesk/Polaris primaries need the **Internet-Archive original-bytes
fallback** against the combex.com URLs, not the erights mirror. `fetch-source.sh`
only rewrites erights.org/caplet.com URLs to the mirror; a combex.com URL falls
straight through to the Wayback `id_` capture path (records
`source_fetched_via=wayback`). Next cycle: fetch `http://www.combex.com/tech/index.html`
(and follow its links to the CapDesk/Polaris primary pages) via `fetch-source.sh`,
which will use Wayback automatically. Confirm the captured pages are substantive
primary docs before ingesting. If combex.com has no usable Wayback captures, fall
back to the secondary-source survey already in
`ocap-history--e-capdesk-polaris.md` and record that the primaries are
unrecoverable.

## Fetch via Wayback: the HP Labs technical reports

- HPL-2004-116 and HPL-2006-116 are PDFs that 404 on the mirror. Fetch via the
  Internet-Archive original-bytes fallback (`fetch-source.sh` does this
  automatically; they record `source_fetched_via=wayback`,
  `source_pdf_sha256` as the idempotency anchor). These are denser papers — plan
  one paper per cycle per the paper-source pacing in `library/conventions.md`.

## Skip (recorded so the next cycle does not rediscover)

- `elang/intro/starting-e.html` — DONE this cycle (source self-flags as obsolete;
  ingested with an obsolescence note; sha256 `27990f44`).
- `elang/intro/quickE.html` — DONE this cycle (4 sections; sha256 `0a9cec3f`).
- `elang/intro/finding-text.html`, `standalone.html`, `concurrency/introducer.html`
  — DONE by the prior `-primaries` cycle.
- `elang/intro/object-lambda.html` — STUB on the mirror (body is just "*** to be
  written, but see From Functions to Objects"). Locate "From Functions to Objects"
  if the lambda-objects material is wanted.
- `elib/capability/ode/ode-capabilities.html` — covered by the FC2000 paper.

## Notes

- Respect one cycle's budget (3 to 5 web sources, or ~1 paper, or ~25 section
  writes); post a further follow-on if the remainder exceeds it.
- Land library/project content via `scripts/jobs/land-journal-edit.sh`; never
  rebase the live journal worktree.
- Run `scripts/jobs/library-link-check.sh --source-slug <slug>` (or `--changed`)
  before completing.

Posted by gardener 90 (endolinbot) completing scholar-ingest-source-erights-elang-remainder.

---
claim:
  host: endolinbot
  gardener: 44
  claimed_at: 2026-06-27T21:47:41Z
