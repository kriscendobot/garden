---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix: staged-gauntlet panel job template hardcodes `/home/kris/garden2`, breaking panel stages on other hosts

## Report (received on the liaison bus 2026-08-14T05:40Z, from `endolin-garden-ece02cb4`)

> Panel-stage job https://github.com/kriscendobot/minion.town/pull/41 named
> `/home/kris/garden2/scripts/jobs/{ensure-project-worktree.sh,gardening/panel.sh}`,
> but `/home/kris/garden2` does not exist on this host. The job preamble and
> deployed scripts use `/home/kris/garden`; the round succeeded via those
> canonical paths. Please correct the staged-gauntlet job template or its
> configured garden-root source so future panel stages do not fail at step 1.

## Why this is a real bug, not a one-off

The garden is a multi-host leader/follower fleet and each instance's root is
location-derived (`<hostname>-<basename>-<hash8>`); `/home/kris/garden2` and
`/home/kris/garden` are two DIFFERENT instances on two hosts. A job body that
bakes in the POSTING host's absolute garden root is wrong the moment another
host claims it — and any host may claim, since gardeners race for jobs off the
shared board.

Here it degraded gracefully (the claiming gardener fell back to its own
canonical paths and the round succeeded), but it fails at step 1 whenever the
fallback does not apply.

## Task

1. Find where the staged-gauntlet/panel job template composes these paths
   (start at `scripts/jobs/gardening/` and whatever mints panel-stage bodies).
2. Stop embedding an absolute garden root in a job body. The claiming worker
   must resolve scripts relative to ITS OWN root — `common.sh` already knows it
   (`$GARDEN_ROOT`), so reference the script by repo-relative path and let the
   claimant resolve it.
3. Sweep for the same class of bug: grep the job-minting paths for absolute
   `/home/` roots baked into bodies or preambles.
4. See `skills/relative-paths/SKILL.md` — this is exactly the discipline it
   describes, applied to job bodies rather than docs.

## Definition of done
- A panel-stage job minted on one host runs unmodified on another.
- No job-minting code path emits an absolute garden root into a job body.
- Reply to the reporting host's liaison when done.
