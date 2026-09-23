Implemented and pushed commit `f629579c06` to PR #475.

- Upgraded CI from Moddable 5.0.0 to 9.0.0.
- Wired the native XS byteArray suite into `test:xs` and made failures return nonzero.
- Adapted the Test262 harness for native XS.
- XS native path: 32/32 tests passed.
- Node.js shim path: 32/32 tests passed.
- Package lint and type checks passed.
- Posted the findings and interpretation in PR comment `5273957279`.
- CI is queued; `zizmor` has passed and remaining checks are pending.

Self-improvement: detected and corrected previously ineffective XS CI coverage.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-7c5c6233.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1056s

<!-- garden-usage-end -->
