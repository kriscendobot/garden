# Scholar: translate the role into v2, then begin ingesting the new forks into the library

The garden has just forked three of the maintainer's repos for future work
(`kriskowal/collections`, `kriskowal/frb`, `kriskowal/cask` — see the completed
`fork-collections-and-frb` and `fork-cask` reports). The maintainer wants a
**scholar** dispatched to **begin ingesting information from them** into the garden's
library.

## Step 0 — translate the scholar role into v2 (it is missing)

There is no `roles/scholar/AGENT.md` in v2 yet; the source is `v1/roles/scholar/AGENT.md`.
Translate it into v2 on `main2` (house style per `roles/COMMON.md`; job-board /
gardener-fleet idiom; "gauntlet" not "gamut"), preserving its substance: the scholar
is the curator of the cross-cutting library under `journal/library/`. Cross-check
against the related v1 skills (`v1/skills/context-library`, `v1/skills/library-lookup`,
`v1/skills/journalism`) and translate any the scholar depends on that have not landed.
Push the role to `origin/main2`, then wear it.

## Step 1 — begin ingesting the three repos into `journal/library/`

The library already exists and is large — follow its established structure rather
than inventing one: `journal/library/{concepts,sources,sections,topics,roles}` plus
`conventions.md`, `keywords.md`, `README.md`. Read those conventions first.

For each of `kriskowal/collections`, `kriskowal/frb`, `kriskowal/cask` (read the
content via `gh`/`git` — upstream or the new bot fork, the content is the same):
- Survey the repo (README, package layout, source, docs) and **begin** curating
  library entries per the scholar's procedure and the library conventions: source
  pages for notable files/modules, concept pages for the ideas they introduce,
  topics/sections as the conventions dictate, with cross-links.
- "Begin" is the operative word: an initial, faithful ingestion pass per repo, not
  exhaustive coverage. If a repo is large enough that full ingestion exceeds one
  session, do a solid first pass and **post a follow-on `scholar-ingest-<repo>` job**
  for the remainder rather than stopping silently.

## Bounds

- Scope: these three bot-owned forks of the maintainer's repos. Nothing here touches
  agoric-sdk. Read-only on the upstreams; all writing is to the garden library on
  `journal2`.
- Quiet, faithful curation — do not overfit the library to one repo's idiom; keep
  the cross-cutting structure the existing 45 concepts / 502 sources / 5565 sections
  already follow.

## Definition of done

`roles/scholar/AGENT.md` translated and pushed to `main2`; an initial library
ingestion pass for collections, frb, and cask committed to `journal2`; and a
follow-on `scholar-ingest-<repo>` job posted for any repo whose ingestion exceeds
one session. Report the role SHA, the library entries added per repo, and any
follow-on jobs posted. If blocked, report the diagnosis and ready-to-apply state
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 64
  claimed_at: 2026-06-24T20:07:23Z
