Scholar cycle for `scholar-ingest-source-erights-ode-capdesk-hpl` (resumed after a
reaper requeue; the earlier session's drafted ode-protocol section survived in
scratch and was landed unchanged).

## Evaluated the Ode chapters; ingested the two that add material

Fetched all five non-trivial Ode chapters via `scripts/jobs/fetch-source.sh`
(`source_fetched_via=mirror`, erights.github.io). Evaluated each against the FC2000
paper source's three existing sections:

- **INGESTED `ode-protocol.html`** ("Capabilities As A Cryptographic Protocol",
  sha256 `ff1dbcf5`) → 1 section
  `erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol`.
  Soft-flagged overlap with the FC2000 `pluribus-rights-taxonomy-and-covered-call-option`
  section, which only summarizes Pluribus; this chapter is the standalone protocol
  mechanics (proxies, four-step encode/decode, the SSL-shaped handshake without
  certificates and with perfect forward secrecy, the impostor problem at both ends,
  subjective aggregation).
- **INGESTED `ode-pki.html`** ("Capabilities As A Public Key Infrastructure",
  sha256 `23d89b79`) → 1 section
  `erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure`.
  This is the one Ode chapter whose substance the FC2000 ingest deliberately
  dropped (its source-index records §5's PKI comparison as supporting material not
  retained), so the capability-vs-SPKI comparison was absent from the library.
- **SKIPPED `ode-objects.html`** (lambda→objects pedagogy; overlaps the
  granovetter/object-capability section and the elang tutorial sources; §2
  supporting material).
- **SKIPPED `ode-game.html`** (stub on the mirror: body is only the title and the
  public-domain footer).
- **SKIPPED `ode-bearer.html`** (rights taxonomy + smart contracts; covered by the
  FC2000 `pluribus-rights-taxonomy-and-covered-call-option` section).
- **SKIPPED `ode-ack.html` / `ode-references.html`** (acknowledgments / bibliography,
  per the job).

## Files written (all via land-journal-edit.sh)

- 2 sections + 2 source-index files (`sources/erights--elib-capability-ode-ode-protocol.md`,
  `sources/erights--elib-capability-ode-ode-pki.md`).
- Topic rows: `topics/captp.md` (protocol), `topics/capability-security.md`
  (protocol + pki), `topics/capability-theory.md` (protocol + pki).
- `sources/README.md` (2 rows after the erights elang block).
- `sections/README.md` (2 new source blocks; count 5834 → 5836 / children 5328 → 5330).
- `keywords.md` (15 new rows: Pluribus handshake, perfect forward secrecy, VatID,
  capabilities as a cryptographic protocol, capabilities as a PKI, SPKI comparison,
  Certificate Result Certificate, confused deputy (PKI), etc.).

## Integrity gate

`library-link-check.sh --source-slug` on both new clusters: OK. `--changed`: OK.

## Follow-on jobs posted (the rest of the original chain remainder)

- `scholar-ingest-source-combex-capdesk-polaris-primaries` — CapDesk/Polaris
  primaries via the combex.com Wayback fallback (recon confirmed: not on the
  erights mirror; linked from the erights home page to `combex.com/tech/index.html`).
  Includes the unrecoverable-fallback instruction (record and complete if no usable
  Wayback captures).
- `scholar-ingest-source-hpl-techreports-polaris` — HPL-2004-116 and HPL-2006-116
  PDFs via Wayback, one report per cycle per the paper pacing, with a self-follow-on
  for the second.

Self-improvement: nothing this time. The `fetch-source.sh` + `land-journal-edit.sh`
+ `library-link-check.sh` toolchain handled the web-source ingest and the
hot-shared-index appends cleanly; no rule gap surfaced.
