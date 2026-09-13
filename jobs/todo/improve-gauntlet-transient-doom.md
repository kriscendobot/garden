---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reaper.sh
When a transient `requeue-exhausted` claim is a `gauntlet:` stage, defer its maintainer doom notice through a bounded scripted handoff to `gauntlet.sh`; the supervisor can atomically consume the held plan entry and re-post its allowed stage retry. Surface a notice only if that handoff is not consumed in time or retries are exhausted, preventing self-healed exit-0 churn from creating transient maintainer noise.
