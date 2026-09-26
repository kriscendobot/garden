Implemented and opened ready-for-review PR https://github.com/kriscendobot/minion.town/pull/62 (commit `b3152db`).

- Renamed the provisioned worker from `MAIN` to `@main`.
- Made `guest_remove` explicitly reject `@main` as indelible, with regression coverage.
- Kept the explicit rule scoped to `@main`; existing validation already rejects ordinary mutation of all `@`-prefixed special names.
- Grep found no other hardcoded worker-name literals in `src/`.
- Existing `MAIN` workers remain as inert legacy entries to avoid disrupting in-flight or guest-owned references. Guests may remove `MAIN` after `@main` takes over.
- `npm run typecheck` passed; `npm test` passed with 282 tests and 5 skipped; GitHub CI passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-rename-main-worker-to-at-main.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 404s

<!-- garden-usage-end -->
