Opened draft PR https://github.com/kriscendobot/minion.town/pull/112 against `main`.

- Re-pinned all three synchronized Endo references to `f9cbcfc426f726858a671bcb09f7c2c774cc659e`.
- Updated live-daemon method-surface expectations for the newer Endo guest and directory APIs.
- Left historical reminder compatibility provenance unchanged.
- Hard gate passed: built the exact Endo commit, then its registry migration suite passed 5/5, including daemon restarts with one and multiple host formulas missing `registry`.
- Full `ENDO_CHECKOUT` suite passed: 45 files, 433 tests. Pin-drift, typecheck, pre-push gates, and 30 Claude-harness tests passed.
- GitHub Actions run 35887081475 is green across the main test and both harness architectures.
- Follow-up: maintainer review and merge; the downstream invitation fallback remains out of scope.
- Self-improvement: notified the liaison that `local-verify.sh` still defaults to Yarn despite documented npm lockfile detection.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-endo-repin-post1329-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1009s

<!-- garden-usage-end -->
