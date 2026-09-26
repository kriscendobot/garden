Verified PR #475 landed and re-fetched review 5037468519; it has no inline threads.

Rebased PR #388 onto frozen base `llm-af12d7c`, migrated all gateway byte-array handling to passable hardened `Uint8Array` using `frozenBytes`/`thawedBytes`, updated types, tests, dependencies, lockfile, docs, and PR body, then force-pushed with lease.

Commits:
- `146ab2c33` — semantic changes
- `386866c09` — lockfile update

Gateway lint and all 115 tests passed. All deterministic pre-push gates passed, and GitHub CI is green. Posted the completion summary and re-requested review from `kriskowal`. No follow-up work remains; local repo-wide docs validation reported unrelated existing errors, while the GitHub docs workflow passed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr388-passable-byte-arrays-after-pr475-37754f3b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2689s

<!-- garden-usage-end -->
