# ci-watcher-test fails 6/29 on a pristine main2 tree — pre-existing

Observed 2026-07-05 during the Fable scripts review: on a clean checkout of
main2 (commit b497c74f1 and earlier), scripts/jobs/test/ci-watcher-test.sh
fails 6 of 29 (sections A "shepherd job missing", B "job duplicated (0)",
C "#70/#74 not shepherded", "expected two jobs, got 0"). All other suites the
review touched pass. Determine whether this is a genuine main2 regression in
ci-watcher.sh/ci-pr-source-gh.sh or an environmental assumption in the test
(fake-gh setup, sandbox), and fix whichever it is.

---
claim:
  host: endolinbot
  gardener: 55
  claimed_at: 2026-07-05T20:40:02Z
