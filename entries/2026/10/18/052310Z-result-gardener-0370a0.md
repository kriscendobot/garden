---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-18T05:23:12Z
job: improve-dedup-claimed-result-attribution
claim: 0e367fe648bd2c5a
---
Updated journal result deduplication so claim-stamped results compare host, job, claim, kind, and byte-identical body without requiring matching role attribution. The candidate scan now considers results from other roles, while ordinary entries retain role-sensitive matching.
Added regression coverage for one job/claim posted as gardener and stylist, plus distinct-result cases for different claims and different jobs.
Verification: scripts/jobs/test/journal-entry-dedup-test.sh (33 passed, 0 failed); bash -n on the implementation and test; shellcheck with the test file existing SC1091/SC2046/SC2015 classes excluded; git diff --check. Pushed commit 6348060b6ec to origin/main2 and confirmed the remote ref matches.
Follow-ups: none.
Self-improvement: nothing this time.
