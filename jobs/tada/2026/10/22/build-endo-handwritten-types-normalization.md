Opened draft PR #1541: https://github.com/endojs/endo-but-for-bots/pull/1541

Normalized hand-written definitions across 16 JavaScript-first packages into checked TypeScript sources with pure declaration re-export shims. Preserved runtime entry points and public type paths. Excluded `@endo/marshal`, which remains owned by #1393. Replied on issue #1540 with the PR URL.

Validation completed:

- `yarn build:types && yarn build:types:check`
- Root TypeScript program
- `yarn lint` and `yarn build`
- All affected-package tests, including 119 daemon tests
- All nine deterministic pre-push probes

No lockfile or changeset was needed. Initial CI’s dependency-cycle job failed because its runner lacks `tred`; remaining CI and the gauntlet are staged for follow-up.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-handwritten-types-normalization.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2524s

<!-- garden-usage-end -->
