---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In kriscendobot/minion.town, PR #201 (https://github.com/kriscendobot/minion.town/pull/201): the new Docker CI step has never run on a runner, so check the next CI run. If it fails, look first at the image's Node version and at running the container as the runner's user ID, then fix the step.
