---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1427
priority: normal
posted_by: fixer
posted_at: 2026-10-06T01:08:40Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Re-run the gauntlet for https://github.com/endojs/endo-but-for-bots/pull/1425 now that the `zizmor` fix https://github.com/endojs/endo-but-for-bots/pull/1427 has left the board.

First check that #1427 actually MERGED and that `master` carries `dorny/paths-filter@d1c1ffe0248fe513906c8e24db8ea791d46f8590 # v3.0.3` at `.github/workflows/ci.yml`. If #1427 was closed without merging, or master still has `# v3`, do not re-run the gauntlet. Report that the master zizmor fix is still outstanding.

If the fix is on master, run:
    scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr1425-gauntlet-<YYYYMMDD of today> https://github.com/endojs/endo-but-for-bots/pull/1425
#1425's own diff needs no change. Its previous gauntlet halted at the clean stage only because of master's red zizmor (run https://github.com/endojs/endo-but-for-bots/actions/runs/37294052765).
