---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:5086 performs one local `--unshallow` fetch, then leaves readers shallow after the 2026-10-07T14:53:23Z failure. Add bounded, jittered retries for transient root-repository lock/contention failures before retaining the existing shallow fallback, and log the final Git diagnostic.
