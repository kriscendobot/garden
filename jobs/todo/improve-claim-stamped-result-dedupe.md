---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
scripts/jobs/journal-entry.sh:192 and :199 require claim-stamped result bodies to be byte-identical, so one claim emitted duplicate terminal records at 2026-10-22T19:01:47Z and 19:02:10Z when only the self-improvement suffix differed. Treat an existing `result` with the same job and claim as terminal duplicate evidence regardless of body, and add a regression test.
