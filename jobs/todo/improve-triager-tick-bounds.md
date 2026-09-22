---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Enforce the remaining tick budget around the triage handler and its posting work, exiting cleanly without advancing or penalizing the cursor when it expires. The pre-handler phase check cannot prevent an unbounded handler from consuming the final headroom; `garden-triager@kriscendobot-minion.town` still hit its 900s systemd timeout.
