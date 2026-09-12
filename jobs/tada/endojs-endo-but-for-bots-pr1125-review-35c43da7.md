Addressed all five inline review comments on endojs/endo-but-for-bots#1125.

- Pushed three follow-up commits through CAS rebases; head is `862c5f25479507a46ad4e9aba4507b2982973fac`.
- Removed branch-only `pins`/`heldPins` migration logic while preserving compatibility with deployed guests lacking pin fields.
- Renamed the formula type consistently to `readable-directory`.
- Added complete formula-record coverage, including guest `planes`.
- Posted claimed designer jobs `design-endo-daemon-mutable-blob-block-storage` and `design-endo-daemon-storage-capability-matrix`.
- Replied to every inline thread, including the requested CASK mechanism explanation, and posted a top-level completion summary.
- Updated the PR body to use `hostPins` and accurately describe migration compatibility.
- Verified 18 targeted tests pass, TypeScript checking passes, and ESLint has zero errors. Daemon-backed tests were not locally verifiable because the isolated worktree’s Unix socket path exceeds the platform limit.
- CI run `34705188784` is still progressing without observed failures; handed monitoring and post-green review re-request to the existing PR shepherd.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-review-35c43da7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1272s

<!-- garden-usage-end -->
