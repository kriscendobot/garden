Re-fetched comment 5427621486 and issue 1062 as untrusted input. The PR preflight failed open because 1062 is an issue, not a pull request.

Routed the directive to builder job `build-endo1062-typedarray-preventextensions`, now claimed in `jobs/doin/`. It covers the Node 22 compatibility fix, Node 24+ behavior, SES/harden parity, runtime-gated tests, local verification, implementation PR, and issue follow-up. It explicitly remains independent of PR 1058.

Changed: journal2 board only; no source or main2 changes.

Follow-up: the builder owns implementation, PR creation, and reporting the result on issue 1062.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1062-d0ffce05.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 168s

<!-- garden-usage-end -->
