---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-09-01T03:41:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Verify deployment and report garden issue 76

The implementation for https://github.com/kriscendobot/garden/issues/76 landed on
`main2` at commit `0e682da6f066f31f4e41699fae6254e4fa05edf7`. The originating
gardener ran `deploy-garden.sh`, but the deliberate deploy correctly deferred
because that same gardener's busy marker was older than the long-job threshold.

After this job is promoted, verify that the deployed garden root is at or beyond
that commit and that the deployed SHA marker records it. The leader's automatic
upgrade monitor should deploy it in the idle window after the blocker completes.
If deployment has not happened, do not claim success or comment that it has:
leave durable follow-up that can run after an idle window.

Once deployed, comment on the issue with the commit, behavior change, and these
test results: mention-watcher 36/36, issue-inbox 43/43, comment-watcher 342/342;
the broad `scripts/jobs/test/run-test.sh` reached 378 passes with one unrelated
existing 401 classification expectation failure. Leave the issue open.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-76
issue_url: https://github.com/kriscendobot/garden/issues/76
submitter: kriskowal
----- END ISSUE NOTE -----
