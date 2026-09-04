---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo kriscendobot/proposal-compartments. Run the gauntlet on stale draft PR https://github.com/kriscendobot/proposal-compartments/pull/4 ("docs(spec): record synchronous-import deferral in viability annex", branch defer-synchronous-import-annex). It has sat DRAFT and untouched since 2026-08-17 despite being editorial-only, green (Render PR check passing), and GitHub-reported MERGEABLE against current main. Re-verify it still applies cleanly and `npm run build` still renders with no lint errors after the intervening README/spec.emu rewrite in this range (commits d23d7de, ecc9ee5), then take it through clean → panel review → fix-loop → un-draft and merge.
