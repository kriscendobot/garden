Job complete. Report follows.

---

# Completion report: scholar-ingest-source-erights-elang-remainder

## What I did

Continued the erights.org E-language primary-source ingest via the GitHub Pages mirror (`fetch-source.sh`, which substitutes the mirror because erights.org refuses sandbox connections). Ingested the two mirror-reachable HTML chapters the job named, updated all affected library indexes, passed the integrity gate, and posted a precise follow-on for the genuine remainder.

## Ingested — 2 sources, 5 sections (`source_kind: web`, `source_fetched_via=mirror`)

- **`erights--elang-intro-starting-e`** — "Starting E and Elmer" (sha256 `27990f44`), 1 section. The source **self-flags as obsolete** at the top (`e`→`rune`, no more `elmer`); I ingested it with an obsolescence note because the `?`/`# value:` REPL convention and the `elmer` literate-prototyping idea (and the "documentation as executable regression test" ambition) remain teachable. Filed under `getting-started`.
- **`erights--elang-intro-quicke`** — Marc Stiegler's "A 15 Minute Introduction to E" (sha256 `0a9cec3f`), 4 sections: conventional OO subset; eventually operator `<-` + location transparency + capability-security-via-unguessable-URIs + pass-by-copy; promises + when-catch + far references + message ordering; bootstrapping the first remote reference (uri / `introducer onTheAir`). Filed under `eventual-send`, `getting-started`, `capability-security`. Each section carries an E-to-Endo Translation block per conventions.

## Indexes updated

`sources/README.md` (2 rows), `sections/README.md` (2 `### ` index blocks, 5 child links), `topics/eventual-send.md` (4 rows), `topics/getting-started.md` (2 rows), `topics/capability-security.md` (2 rows). All landed via `land-journal-edit.sh` (producer-clone CAS, fetched fresh tip before each shared-index append). Skipped `keywords.md`/`concepts/` — matches the prior cycle and avoids a whole-file reland of the 13k-line keyword index under concurrent fleet edits.

## Integrity gate

`library-link-check.sh --source-slug` on both new slugs exits 0.

## Recon captured (so the next cycle doesn't rediscover) and follow-on posted

Posted **`scholar-ingest-source-erights-ode-capdesk-hpl`** (already claimed by gardener-44) carrying:
- **Ode subpages**: the mirror enumerates 8 Ode chapters (more than the job named). The FC2000 paper already covers Ode in 3 sections; `ode-protocol`/`ode-pki` are the likeliest to add omitted material — evaluate those first.
- **CapDesk/Polaris primaries are NOT on the erights mirror** (key finding). CapDesk's primary is the external `combex.com/tech/index.html`; Polaris isn't linked at all. These need the Wayback fallback against combex.com (a non-erights URL routes through `fetch-source.sh` to Wayback automatically) — not the erights mirror.
- HPL-2004-116 / HPL-2006-116 PDFs via Wayback.

## Budget / what's deferred

Held to 2 web sources / 5 sections per the budget rule and the prior job's "quickE is likely its own full cycle" hint. Ode evaluation, CapDesk/Polaris, and the HPL PDFs are all carried by the follow-on. Scratch cleaned up.

Self-improvement: nothing this time — the fetch/land/gate flow worked as documented; the one wrinkle (CapDesk/Polaris on combex.com) is a project fact captured in the follow-on, not a role/skill gap.
