---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T01:20:39Z
---
result: scholar-ingest-source-combex-capdesk-polaris-primaries

# CapDesk / Polaris primaries ingested via the combex.com Wayback fallback

One scholar cycle. The CapDesk/Polaris primaries ARE recoverable: combex.com has
substantive Internet-Archive captures, and the Polaris HP Labs report (HPL-2004-221)
is available as an original-bytes PDF. Five primary sources ingested
(`source_fetched_via=wayback`), 11 section files, complementing — and now
cross-referenced bidirectionally with — the secondary-source survey
`ocap-history--e-capdesk-polaris`.

## Sources ingested (5)

- **combex--tech-index** (1 section) — the Combex Technology hub page erights.org
  links to for CapDesk; content SHA-256 `f22dc828`, wayback 20260105152220.
- **combex--edesk** (2 sections) — "E and CapDesk: POLA for the Distributed
  Desktop", the canonical CapDesk primary (cited as ref [7] by the Polaris paper);
  SHA-256 `0cc54052`, wayback 20260504141905.
- **combex--darpa-browser** (3 sections) — "The DarpaBrowser", the DARPA-accepted
  capability-confined-renderer project document (the most substantive CapDesk-era
  primary, 40 KB); SHA-256 `3a68fd80`, wayback 20260504023216.
- **combex--opportunity** (1 section) — "The Opportunity for a Virus-Invulnerable
  Desktop", the CapDesk threat-model / market framing; SHA-256 `9bbce140`,
  wayback 20240418142939.
- **papers--stiegler-karp-yee-miller-polaris-2004** (4 sections) — "Polaris: Virus
  Safe Computing for Windows XP" (HPL-2004-221, Stiegler/Karp/Yee/Miller, 9-pp PDF
  text extracted via pypdf); the Polaris primary — CapDesk's PowerBox /
  installation-endowment / designation-as-authorization carried to unmodified
  Windows XP via restricted accounts + RunAs. PDF SHA-256 `6c95faf1`, wayback
  20220423221140.

All filed under `capability-security` / `capability-theory`.

## Recon notes (for any follow-on)

- Polaris is NOT on combex.com and NOT linked from combex's CapDesk index (as the
  job's recon predicted): its primary is the HP Labs report HPL-2004-221. The
  skyhunter.com/marcs/* pages (Marc Stiegler's site — narratedIntros,
  granmaRulesPola, PolarisWeb) have NO usable Wayback captures (curl rc=22); the
  HP Labs report is the recoverable Polaris primary.
- combex.com itself is unreachable directly and is not on the erights.github.io
  mirror, so every byte came from the Internet-Archive `id_` path via
  fetch-source.sh, exactly as designed.

## Indexes updated

- `sources/README.md` — 4 rows under "External web sources" + 1 under "External
  papers".
- `sections/README.md` — 5 new source blocks (11 section bullets).
- `topics/capability-security.md` (9 rows) and `topics/capability-theory.md` (5 rows).
- `keywords.md` — 17 new keyword lines (CapDesk, Combex, Polaris, PowerBox, caplet,
  capWT, valet key, permission vs authority, RunAs, …).
- Cross-reference: added the combex/Polaris primary cluster to the existing survey
  source `ocap-history--e-capdesk-polaris.md` "See also" (bidirectional with the
  new sources' own See-also pointers).

## Integrity gate

`library-link-check.sh --source-slug` PASSED (rc=0) for all 6 touched clusters
(the 5 new sources + the cross-referenced survey), and `--nav` PASSED (rc=0) over
all navigation surfaces. Every section-table target, README row, and topic row
resolves to a committed file.

## Deferred to a follow-on (within budget; not forced)

combex.com `products.html`, `screen-shots.html`, the `papers/index.html` index,
and the external skyhunter.com "E in a Walnut" / narrated-introductions pages
remain un-ingested. They are secondary to the CapDesk/Polaris primaries; a future
`scholar-ingest-source` cycle can pick them up if wanted. Not posting a follow-on
job for them — the primary CapDesk/Polaris cluster the job targeted is now complete.

Self-improvement: fetch-source.sh handles non-erights wayback fallback cleanly,
but it has no PDF-text path — I extracted HPL-2004-221 with pypdf by hand. A
deterministic "fetch + extract text for paper PDFs" companion (pypdf is available
in the sandbox; pdftotext is not) would remove the one hand-rolled step in
paper ingestion. Noting as a candidate, not landing a role/skill edit (out of a
gardener's authority).
