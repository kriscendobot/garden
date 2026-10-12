Updated and rebased PR #1278 at `673f11f6d2`.

- Ported XS’s base-36 named boundary and documented Iron Horse’s symbols/property-key divergence.
- Recorded the tagged-template temporary-vector parser-depth divergence.
- Aligned field-initializer diagnostic line reporting.
- Updated PR body for Moddable `cfe72a8cfc` / SDK 10.0.0 and posted a PR summary.

Verified locally: `cargo test -p ironhorse-compile` (145 tests), `cargo test -p ironhorse-vm --test compiler_frame_locals_limit` (5 tests), formatting, and pre-push gates. CI’s Linux Iron Horse test passed; macOS Iron Horse and sanitizer checks remained running. An unrelated macOS general test failed in existing `@endo/sandbox` tests after SIGINT.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-reconcile-xs-frame-locals-limit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 1707s

<!-- garden-usage-end -->
