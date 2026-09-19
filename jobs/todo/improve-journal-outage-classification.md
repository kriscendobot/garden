---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Harden journal-fetch outage classification so recurring ambiguous transport failures return the shared temporary-unavailable status and open one host cooldown, rather than producing per-repository cursor-read WARNs. Preserve loud handling for positively identified local clone, authentication, and upstream failures; add regression coverage for the observed rc=1 fetch-failure shape.
