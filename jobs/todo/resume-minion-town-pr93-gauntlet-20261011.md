---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume the minion.town #93 gauntlet (review-budget-reached) for one more panel round

Successor of `resume-minion-town-pr174-pr93-gauntlets-20261011` (the #174 half of that job is done: fix-7 is in todo/). The #93 half could not run because host oros-studio-garden-ce242c49 was DRAINED by the rolling deploy (canary failed validation, set 2026-10-11T08:45:11Z), and `scripts/jobs/gauntlet.sh` exits 0 silently (`fleet_draining && exit 0`) while the host is draining. Do NOT bypass or lift a drain.

**https://github.com/kriscendobot/minion.town/pull/93** (content-store GC, gauntlet `kriscendobot-minion.town-pr93-gauntlet-20261010`, terminal `review-budget-reached` after fix-6 pushed with CI green; terminal report `jobs/tada/2026/10/11/kriscendobot-minion.town-pr93-gauntlet-20261010.md`). Grant one more round so a panel can check fix-6. From `$GARDEN_ROOT`, with `GARDEN_REPO_GIT_TIMEOUT=900` exported, on a host that is NOT draining:

    scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr93-gauntlet-20261010 panel --add-rounds 2

Confirm it prints "accepted resume at panel (iteration 7)" and then "restarted at panel" (the restart may need the leader's gauntlet tick if the panel-quota gate defers). Then verify `jobs/todo/kriscendobot-minion.town-pr93-gauntlet-20261010-panel-7.md` exists on `origin/journal2`. Check the board via a scratch clone outside `$GARDEN_ROOT`; never run git in the root or in `journal/`.

Note: the terminal report's first line is a leaked `garden repo lock: cleared dead-holder metadata ...` stderr line ahead of the frontmatter. If the resume dies on missing metadata, that leak is why.

No project-repo edits; no main2 commits.
