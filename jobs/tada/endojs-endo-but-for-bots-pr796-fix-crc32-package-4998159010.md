Updated draft PR endojs/endo-but-for-bots#796 and pushed head `2f355bb1b6ec94cbf5e656466c065046fecc8aeb`.

- `5ae4fcaea`: added hardened public `@endo/crc32` with documented byte-range/incremental API, tests, metadata, legal/security files, changeset, and TypeScript configuration; migrated daemon hashline.
- `b89b0129a`: migrated ZIP readers/writers and removed the duplicate CRC-32 implementation.
- `62b28d6fe`: updated `yarn.lock` separately.
- `2f355bb1b`: restored canonical `SECURITY.md` after its uniformity check exposed a pre-push-probe conflict.
- Verified 7 CRC32, 13 ZIP, and 40 hashline tests; focused types, composite configs, formatting, root lint/shellcheck, and API docs passed.
- All five GitHub workflows are green, including the 22-job CI matrix.
- Replied to inline comment `3834370163`, posted the completion summary, and re-requested review from `kriskowal`. PR remains draft.
- Follow-up: reported the canonical `SECURITY.md` versus typist-probe conflict to `role/liaison` (`20260822T003518Z-a50c8e`).
- Self-improvement: routed the conflicting-gates finding to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-fix-crc32-package-4998159010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3016s

<!-- garden-usage-end -->
