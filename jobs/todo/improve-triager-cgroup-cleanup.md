---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Reap the triager tick’s fetch/handler process subtree on TERM and exit, using the hardened watcher process-group cleanup pattern so git descendants cannot survive a tick and trigger repeated systemd “left-over process” warnings. Align `garden-triager@.service` stop semantics and bounds with that cleanup.
