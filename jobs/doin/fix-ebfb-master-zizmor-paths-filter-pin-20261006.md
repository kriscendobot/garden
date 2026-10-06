---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix the red `zizmor` check on endojs/endo-but-for-bots `master`. It fails every PR based on master, which includes https://github.com/endojs/endo-but-for-bots/pull/1425 (its gauntlet halted at clean, run https://github.com/endojs/endo-but-for-bots/actions/runs/37294052765).

The failing line is `.github/workflows/ci.yml:270`: the `dorny/paths-filter@d1c1ffe…` pin has a `# v3` comment that doesn't match the pinned commit, and zizmor exits 13. Either correct the comment to the tag that commit actually carries, or re-pin to the commit for the tag the comment names. Verify the tag-to-SHA mapping on GitHub; don't guess.

Open a small draft PR against `master` and get zizmor green. Once it merges, re-run the gauntlet for #1425: `scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr1425-gauntlet-<date> https://github.com/endojs/endo-but-for-bots/pull/1425`. #1425's own diff needs no change.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T01:06:01Z
