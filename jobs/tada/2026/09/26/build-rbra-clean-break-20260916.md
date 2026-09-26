PR endojs/endo-but-for-bots#1301 had already incorporated the clean break and merged as `4b6ef5152e`; its head branch was deleted, so no new commit or push was appropriate.

The merged implementation:

- Replaces blob `fetch`/`rangeRead*` with `bytes`/`byteRange`/`textRange`.
- Replaces `getInfo` with `sha256` and `size`.
- Rewrites CAS and cached-filesystem consumers to drain the whole-blob `bytes()` reader, then cache/slice locally.
- Retains only unrelated HTTP, Git-transport, registry, and content-store `fetch` methods.
- Updates producers, guards, types, declarations, help, and range/conformance tests.

Verification:

- Legacy-method grep across platform, daemon, git, and exo-git found no `rangeRead`, `rangeReadText`, or `getInfo` calls/definitions.
- All four packages passed lint and `lint:types`; applicable `test:types` passed.
- Platform: 362 tests passed.
- Git: 15 tests passed.
- Exo-git: 56 tests passed.
- Seven focused daemon blob/range/mount/revocation/Git tests passed.
- The full daemon run encountered unrelated `endo.sock` ENOENT failures in channel/GC suites and was interrupted; PR #1301’s authoritative CI was fully green across lint and test matrices before merge.

The rename/conformance child can proceed, but its stale instructions must be retargeted to a fresh branch from `llm`; it cannot continue on merged/deleted PR #1301.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-rbra-clean-break-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 11732s

<!-- garden-usage-end -->
