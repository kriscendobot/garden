---
kind: result
role: gardener
host: endolinbot
at: 2026-06-27T21:48:08Z
---
Scholar cycle for job `scholar-ingest-source-erights-elang-remainder`. Continued
the erights.org E-language primary-source ingest via the GitHub Pages mirror.

## Ingested (2 sources, 5 sections)

- `erights--elang-intro-starting-e` ("Starting E and Elmer", `elang/intro/starting-e.html`,
  sha256 `27990f44`, `source_fetched_via=mirror`) — 1 section
  (`--launching-and-elmer`). The source SELF-FLAGS as obsolete (`e`->`rune`, no
  more `elmer`); ingested with an obsolescence note because the REPL convention
  (`?` / `# value:`) and the literate-prototyping idea survive. Filed under
  `getting-started`.
- `erights--elang-intro-quicke` (Marc Stiegler's "A 15 Minute Introduction to E",
  `elang/intro/quickE.html`, sha256 `0a9cec3f`, `source_fetched_via=mirror`) —
  4 sections: `--overview-and-conventional-subset`,
  `--eventual-send-and-location-transparency`,
  `--promises-when-catch-and-far-references`, `--bootstrapping-remote-references`.
  The dense highlights tour (eventually operator `<-`, promises + when-catch, far
  references, message ordering, uri/introducer bootstrapping). Filed under
  `eventual-send`, `getting-started`, `capability-security`.

## Indexes updated

- `sources/README.md` — 2 rows in the External web sources table.
- `sections/README.md` — 2 new `### <source-slug>` index blocks (5 child links).
- `topics/eventual-send.md` (4 rows), `topics/getting-started.md` (2 rows),
  `topics/capability-security.md` (2 rows).
- Did NOT touch `keywords.md`/`concepts/` (mirrors the prior `-primaries` cycle;
  avoids a whole-file reland of the 13k-line keywords index under concurrent
  fleet edits).

## Recon captured for the follow-on (so the next cycle does not rediscover)

- The Ode subpages: the mirror's `elib/capability/ode/index.html` enumerates 8
  chapters (ode-objects/capabilities/protocol/pki/game/bearer/ack/references) plus
  `ode.pdf`. The FC2000 paper source already covers Ode at higher fidelity in 3
  sections; the crypto-substrate chapters (`ode-protocol`, `ode-pki`) are the
  likeliest to add material the paper omits and should be evaluated first.
- CapDesk/Polaris primaries are NOT on the erights mirror. CapDesk's primary page
  is the EXTERNAL `http://www.combex.com/tech/index.html` (Combex); Polaris is not
  linked from the elang/elib indexes at all. These need the Wayback original-bytes
  fallback against combex.com (a non-erights URL falls straight through
  `fetch-source.sh` to the Wayback path), not the erights mirror.
- HPL-2004-116 / HPL-2006-116 remain PDFs to fetch via Wayback.

Posted follow-on job `scholar-ingest-source-erights-ode-capdesk-hpl` carrying all
of the above with exact URLs and the evaluate-before-ingest discipline.

## Integrity gate

`library-link-check.sh --source-slug erights--elang-intro-starting-e` and
`--source-slug erights--elang-intro-quicke` both exit 0 (every checked link
resolves to a committed file).

Self-improvement: nothing this time. The fetch/land/gate flow and the
`fetch-source.sh` mirror substitution worked as documented; the one wrinkle
(CapDesk/Polaris living on combex.com, not the erights mirror) is a project-fact
captured in the follow-on job, not a role/skill gap.
