Implemented and pushed PR #1349 at `f1770005a9`.

- Aligned codec encapsulation with the reviewed design: unconditional SES-owned constructors, shared encapsulation helper, single lockdown-time application, and diagnostic prototype-repoint failures.
- Folded in the XS lockdown-intrinsics prerequisite.
- Expanded Node, XS, and Chromium regression coverage; updated changesets, guide, PR body, and completion summary.
- Verified: SES tests 542 passed; XS, types, lint, convention probes, and Chromium tests passed.
- GitHub CI: 14/16 passed. Two unrelated runner failures remain: missing `tred` and Playwright lacking Ubuntu 26.04 support.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1349-text-codec-encapsulation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1777s

<!-- garden-usage-end -->
