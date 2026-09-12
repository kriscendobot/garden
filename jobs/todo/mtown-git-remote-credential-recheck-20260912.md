---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer

Recheck of the kriscendobot/minion.town git-remote / credential resolution gap.

The original job `mtown-git-remote-followup-notice-recheck-20260818` was doomed by
the reaper after 5 requeue cycles and has since vanished from the board with no
completion report. The underlying condition is STILL LIVE: on 2026-09-04 the job
`minion-town-clip-content-store-gc-build` reported that it committed and pushed
branch `feat/clip-content-store-gc` at 1e4e0e9 but `ensure-pr.sh` could NOT create
the draft PR, because "this host cannot resolve a valid kriscendobot git
credential."

Task: diagnose and fix the credential/remote resolution gap so a gardener on this
fleet can run `ensure-pr.sh` against kriscendobot/minion.town. Determine whether
this is a per-host gap (which hosts are affected), a wrapper-pin issue in the
fleet's `gh` identity pinning, or a missing/expired token. Report findings even if
the fix requires maintainer credentials you cannot supply — name exactly what is
missing and on which host.

Do NOT run git in $GARDEN_ROOT.

Skills: skills/self-healing-wrapper, skills/gardener-inbox-error-reporting.
