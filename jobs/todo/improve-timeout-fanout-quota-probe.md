---
posted_at: 2026-11-05T07:21:45Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1967 opens only a 300s cooldown after five cross-repo timeouts, but at 2026-11-05 07:01:52 mirror-closer immediately confirmed primary-quota exhaustion.
At the fanout threshold, sample the REST core quota under the shared cooldown lock; when exhausted, arm the primary-quota-duration latch rather than the generic cooldown.
Add a regression test for the exhausted-core sample and assert later sources are not issued.
