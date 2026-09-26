FIX round 3 complete. Applied the panel's round-3 must-fix items to PR #48, pushed as a follow-up commit, and CI is green.

## What I did

Addressed all four blocking items plus the safe should-fix/comment-only tail on the git-content-substrate serving plane:

1. **Byte-fidelity / §6 break (4 seats, blocking).** The serve-time sentinel swap did a blind whole-document `Buffer.indexOf`, corrupting any author-written literal `/.content/<64 zeros>/` string (in `<pre>`/`<code>`, `<script>` constants, comments, plain text, nav `<a href>`). The projector now **records the byte offset of each sentinel it actually emits** (`rootQualifyHtmlWithOffsets` → `Projection`/manifest `sentinelOffsets`), and the content server splices **only at those offsets** (re-verifying the needle is present first). A document with no recorded offsets — a `weblet_publish`/seeded blob, a non-UTF-8 doc interned raw, or an HTML doc with no sub-resources — is served **verbatim, never scanned**.
2. **Compound `rel` misclassification (assessor, blocking).** `isNavigationalLink` now treats a `<link>` as navigational only when **every** `rel` token is navigational, so `rel="alternate stylesheet"` is correctly root-qualified.
3. **`limits` type (typist, blocking).** `PublishContentTreeInput.limits` is now `Partial<ProjectionLimits>`; `resolveLimits` takes the partial and drops the cast; the test drops its `as never`.
4. **Cryptic `nc` fixtures (stylist, blocking).** Renamed to `nonUtf8*`/`requestNonUtf8`.

Should-fix tail (safe subset): collapsed `PublishContentTreeResult` to `= AdvanceResult`; weakened the CAS "never a false success" JSDoc to match the read-check-write caveat; fixed the "Steps 3 and 5"→"3 and 4" JSDoc.

## What changed
8 files, +522/−141. New tests: end-to-end byte-fidelity (author sentinel survives in every untouched region; non-projected blob serves verbatim), a compound-`rel` case, projector offset unit tests (incl. a multi-byte char shifting the byte offset), and a manifest `sentinelOffsets` build→parse round-trip with fail-closed validation.

## Verification
Local `npm run typecheck` clean; full `npm test` = 278 passed / 3 skipped (CI-equivalent). Pushed `bcbabed..12f5eda` to the PR head via `safe-push-pr-head.sh`; `ci-wait-merge.sh` reports **CI GREEN (rc 0)**.

## Follow-ups (deferred — unwired paths, not merge-blocking)
TTL read-cache `invalidate(id)` on advance; an in-process CAS mutex; id-namespace separation from `deriveWebletId`. The driver re-posts the panel (panel-4) next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (8321848 cached reads)
- Output: 74119 tokens
- Cost: $7.682946999999999
- Wall-clock: 1021s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
