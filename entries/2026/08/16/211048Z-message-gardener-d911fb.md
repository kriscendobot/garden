---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T21:10:50Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1008 MERGE-NOW

project: endo-but-for-bots

**PR #1008** `chore: bump electron from 42.5.0 to 43.3.0` (`packages/familiar`,
both `dependencies` and `devDependencies`; electron is the build/packaging
toolchain for the familiar desktop app). Verdict **MERGE-NOW** — a real-CVE
repair. Conducted onto `llm` via the conductor spine
(`ci-wait-merge.sh --dependabot-auto-merge`) after the head was rebased onto
live base (`2d3bf895331` → `9f88032a790`).

## Diligence
- **Census / supersession:** base `llm` at `electron@42.5.0` (`^42.0.1`); PR
  moves forward to `43.3.0` (not a no-op / partial-revert). No sibling Dependabot
  PR moves electron (watcher preflight + `gh pr list` confirmed).
- **Transitive set:** ONLY `electron` itself moved (42.5.0 → 43.3.0). Electron's
  own dependency ranges/resolutions are unchanged in the lockfile — no transitive
  package added/removed/re-versioned, no newly-introduced package, nothing <24h
  old, no license change.
- **Advisories (directional, both sides):** outgoing **42.5.0** carries 1 open
  advisory — **GHSA-r4w5-6pfg-jxp5 / CVE-2026-70606** (medium, CVSS 5.9;
  *ProtocolResponse.url reuses the default session cache instead of the
  registering session*), patched in 42.5.1 / 43.0.0. Incoming **43.3.0** carries
  **0** open advisories. The upgrade CLOSES a known advisory the project is
  exposed to and introduces none.
- **Maturity floor:** only electron moved, so freshest = `electron@43.3.0` @
  2026-08-04T19:19:18Z → floor **2026-08-11T19:19:18Z**, already ~5 days past at
  review time (2026-08-16). Publisher `electron-nightly` (official electron
  publishing identity) on BOTH sides — no new-releaser signal. (Maturity moot
  anyway given the CVE repair.)
- **Install:** scripts-disabled (`YARN_ENABLE_SCRIPTS=false yarn install
  --immutable`, rc=0; WARM-CACHE scripts-disabled namespace).
- **Consuming-code impact:** major bump 42→43 (Chromium 150, Node 24.18.1), but
  electron is consumed as the packaging toolchain, not an imported API surface;
  CI is green on the rebased head with no source changes — no migration required.

## Disposition
MERGE-NOW executed via the conductor spine (dependabot auto-merge path; botanist
diligence + conductor guards retained, human signature omitted). Terminal row —
remove on the next sweep; no recheck wiring (that is only for EMBARGO). Verdict
comment: https://github.com/endojs/endo-but-for-bots/pull/1008#issuecomment-5309669300
