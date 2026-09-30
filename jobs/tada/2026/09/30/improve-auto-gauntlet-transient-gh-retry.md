**Completion report: improve-auto-gauntlet-transient-gh-retry**

A transient `gh pr view` failure no longer fails a producer completion. The fix and its tests are pushed to `main2` as commit `7f0cb21902c`.

**The fix, in `scripts/jobs/auto-gauntlet-handoff.sh`:**
- The single `gh pr view` read now goes through the existing `gh_pr_view_retry` helper in `common.sh`. That helper recognizes the same transient signatures as `gh_api_retry` (TLS handshake timeout, `dial tcp`, 5xx/429, `EOF`, and so on) and retries them with bounded backoff, up to `GARDEN_GH_API_ATTEMPTS` tries (default 4).
- A definitive failure is not retried. So a link that points at an issue rather than a PR ("Could not resolve to a PullRequest") still exits as an immediate no-op. The check still works because the helper's log lines, which carry gh's error text, are captured to the file the hook searches.
- The hook fails only after all retries are used up. The retry log lines are passed through to stderr on success as well as on failure.

**Tests:**
- I added three cases to the shared gh stub (`assert-producer-pr-draft-gh-stub.sh`):
  - #211 times out on the first view, then succeeds.
  - #212 always times out.
  - #213 is a non-PR.
- `auto-gauntlet-handoff-test.sh` now checks that:
  - #211 is retried exactly once and records its gauntlet.
  - #213 makes exactly one call and records nothing.
  - #212 makes exactly `GARDEN_GH_API_ATTEMPTS` calls and fails with "gh could not inspect".
- `auto-gauntlet-handoff-test.sh` and `assert-producer-pr-draft-test.sh` (which uses the same stub) both pass. Shellcheck reports only an info-level note that was already there.

**Follow-ups:** none. The fix reaches each host at its next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-auto-gauntlet-transient-gh-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (627612 cached reads)
- Output: 5434 tokens
- Cost: $0.7117784
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
