Implemented and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1289 at commit `853e9021e`.

- Added marshal-local `passablesEqual`, projecting byte-array leaves to readable hexadecimal values while retaining AVA `deepEqual` diagnostics.
- Replaced three byte-array-specific round-trip comparison branches.
- Added equality and diagnostic regression coverage.
- Verified TypeScript, ESLint, Prettier, pre-push probes, and 30 affected tests under lockdown, unsafe-lockdown, and shims-only configurations.
- Linked the draft from the originating PR #475 review thread.
- CI is running; no implementation follow-up remains. Unrelated warm-cache worktree changes were left untouched.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-marshal-passables-equal-ava-operator.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 725s

<!-- garden-usage-end -->
