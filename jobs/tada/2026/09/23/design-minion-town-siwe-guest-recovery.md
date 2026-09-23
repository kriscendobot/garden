Completed `design-minion-town-siwe-guest-recovery`.

- Opened draft PR https://github.com/kriscendobot/minion.town/pull/114 at commit `8cc6b6c`, pinned to `main-8e9f2be`.
- Added `designs/siwe-guest-recovery.md`, settling address binding/removal, multi-address and lost-address behavior, one-time recovery, expiry/rate limits/auditing, capability-first boundaries, Cognito bypass, and EOA-only verification.
- Marked the on-chain authorization design superseded and removed its authorization direction from related documentation.
- Withdrew stale parked job `deploy-siwe-thunk-minion-town`; its deployment already completed and its remaining on-chain scope is rejected.
- Verified: main suite 428 passed/5 skipped; typecheck passed; SIWE suite 19/19 passed; `git diff --check` passed. GitHub test and both architecture harnesses have successful runs; one duplicate arm64 run remained in progress after the PR close/reopen race.
- Follow-up: implementation should revise draft PR #81 to use the normalized multi-identity recovery store and single-use disclosure flow. The maintainer may request the design gauntlet for #114.
- Self-improvement: reported the shared frozen-base deletion race to `role/liaison` for sweep hardening.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-siwe-guest-recovery.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1049s

<!-- garden-usage-end -->
