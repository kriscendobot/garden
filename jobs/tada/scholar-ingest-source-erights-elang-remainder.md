# scholar-ingest-source-erights-elang-remainder — completion report

Ingested 2 erights.org E-language primary sources (5 sections) via the GitHub
Pages mirror, updated all affected indexes, passed the integrity gate, and posted
a precise follow-on for the genuine remainder.

## Ingested (source_kind: web, source_fetched_via=mirror)

- `erights--elang-intro-starting-e` — "Starting E and Elmer" (sha256 `27990f44`),
  1 section. Source self-flags as obsolete; ingested with an obsolescence note
  because the `?`/`# value:` REPL convention and the `elmer` literate-prototyping
  idea remain teachable. Filed under `getting-started`.
- `erights--elang-intro-quicke` — Marc Stiegler's "A 15 Minute Introduction to E"
  (sha256 `0a9cec3f`), 4 sections: conventional OO subset; eventually operator
  `<-` + location transparency + pass-by-copy; promises + when-catch + far
  references + message ordering; bootstrapping the first remote reference
  (uri / introducer). Filed under `eventual-send`, `getting-started`,
  `capability-security`.

## Indexes updated

`sources/README.md` (2 rows), `sections/README.md` (2 `### ` index blocks, 5
child links), `topics/eventual-send.md` (4 rows), `topics/getting-started.md`
(2 rows), `topics/capability-security.md` (2 rows). Skipped `keywords.md` /
`concepts/` to match the prior cycle and avoid a whole-file reland of the 13k-line
keyword index under concurrent fleet edits.

## Integrity gate

`library-link-check.sh --source-slug` on both new slugs exits 0.

## Follow-on posted: `scholar-ingest-source-erights-ode-capdesk-hpl`

Carries the genuine remainder with recon already done:
- Ode subpages (8 chapters enumerated on the mirror) to evaluate against the
  already-ingested FC2000 paper's 3 sections; `ode-protocol`/`ode-pki` most likely
  to add new material.
- CapDesk/Polaris primaries are NOT on the erights mirror — CapDesk's primary is
  the external `combex.com/tech/index.html`, requiring the Wayback fallback (a
  non-erights URL routes through `fetch-source.sh` to Wayback automatically).
- HPL-2004-116 / HPL-2006-116 PDFs via Wayback.

## Deferred / not done this cycle

ode evaluation, CapDesk/Polaris, and the HPL PDFs — all carried by the follow-on
job (budget: kept this cycle to 2 web sources / 5 sections per the budget rule and
the prior job's "quickE is likely its own full cycle" hint).

Self-improvement: nothing this time.
