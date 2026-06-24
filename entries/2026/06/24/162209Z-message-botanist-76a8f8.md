---
kind: message
role: botanist
host: endolinbot
at: 2026-06-24T16:22:10Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger row: endojs/endo-but-for-bots#197 (terminal re-botany)

Supersedes the 2026-06-24T10:38:07Z HOLD row for #197
(`entries/2026/06/24/103807Z-message-botanist-73fafe.md`). The weaver rebased
#197 onto current `llm` (new head `4d13a7cdc`) and the shepherd drove CI; this
re-botany renders the now-due terminal verdict against the rebased head's
regenerated lockfile. Appends to the `endojs/endo-but-for-bots` dependabotany
ledger; recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [197](https://github.com/endojs/endo-but-for-bots/pull/197) | electron `^42.0.1` → resolved `42.5.0` in `@endo/familiar` (+ preserved maintainer ESM rework; base `llm`, head `4d13a7cdc`) | **EMBARGO-2026-06-30** | 2026-06-30 | OPEN, embargoed | **Rebase pulled a newer, same-day-fresh electron.** The prior pass vetted `42.0.1` (mature, 2026-05-08); the rebase's regenerated lockfile resolved the caret `^42.0.1` to **`42.5.0`, published 2026-06-23T19:55:53Z (~20h old at assessment)** — inside the 24h-fresh window. The 40→42 jump swaps electron's download stack from `@electron/get`@2 + `got`@11 to `@electron/get`@5 + `undici`@7: **newly introduced** `@electron-internal/extract-zip@1.0.4` (published 2026-06-23T22:43:17Z, ~18h old, also <24h), `@electron/get@5.0.0` (2026-04-22, mature), `undici@7.28.0` (2026-06-15, 9d mature); **dropped** `extract-zip@2.0.1` and the ~17-package `got`@11 HTTP stack. **Advisories:** OSV/GHSA clean on electron 42.5.0, @electron/get 5.0.0, @electron-internal/extract-zip 1.0.4, undici 7.28.0 — not CVE-repairing, so no fast-track. **Provenance:** @electron-internal/extract-zip is an Electron-org package (marshallofsound/electron-cfa/electronhq, repo electron/extract-zip); undici is the Node core team (Collina/ronag/Arrowood). Clean. **Binding gate:** two moved versions (the headline electron 42.5.0 and the newly-introduced extract-zip 1.0.4) are <24h old and the upgrade closes no CVE, so the 7-day maturity floor applies → embargo until **2026-06-30** (7 days past the 2026-06-23 publish). Green CI is necessary but cannot satisfy a freshness gate. Did NOT merge, did NOT close. ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment-4791420725)) |

## Scheduled engagements

`dependabotany-recheck-endo-but-for-bots` (daily) ensured this cycle. On/after
2026-06-30 it re-evaluates #197 against its then-current head: re-resolve electron
(if the caret has moved to an even fresher 42.x, the embargo extends; otherwise
42.5.0 will be >=7 days mature), re-run OSV/GHSA, shepherd CI to green, then
conduct onto `llm`. The terminal verdict on that recheck removes this ledger row.

## Botanist self-notes for this PR

- **A caret on a rebased Dependabot PR can resolve to a same-day release the
  original assay never saw.** The prior pass vetted `electron@42.0.1` (47 days
  mature) and pre-cleared the supply chain, but `^42.0.1` resolves to the newest
  42.x, and the rebase regenerated the lockfile against `42.5.0`, published the
  day before this re-botany. The re-botany's whole value was re-resolving the
  caret against the rebased lockfile, not trusting the floor version's maturity.
  Always re-read the regenerated lockfile's resolved version after a rebase;
  the pinned floor is not what installs.
- **Maturity is assessed on the version that would actually land, not the pin
  floor.** `42.5.0` (the caret's resolution) is the binding date, even though
  `42.0.1` (the pin floor) is mature. Vet what yarn resolves, not what the
  manifest names.
- **A newly-introduced transitive package that is also <24h old is a double
  flag, cleared only by provenance.** `@electron-internal/extract-zip@1.0.4` is
  both first-seen in this tree and ~18h old. The clearing evidence was the
  Electron-org maintainer set and the `electron/extract-zip` repo (it is the
  scoped successor to the old `extract-zip`); without that, the freshness alone
  would push toward REJECT rather than EMBARGO.
