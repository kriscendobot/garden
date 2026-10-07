PR #68 fix round 1 is done: I applied the panel's three blocking items and folded in most of the should-fix items. CI is green at the new head `1370125` (`ci-wait-merge` rc 0, all 3 checks passed).

**Blocking items, all applied:**
- **Worker rejection reason (breaker):** the guest worker's rejection reason is now cut to 200 characters, the same limit as schema-issue messages, via a shared `truncateEchoed` helper. A new test throws a 1M-character reason through the `rejects` fixture and checks the error comes back short.
- **Path and contentType length (breaker):** `path` is now capped at 1024 characters and `contentType` at 255. A new test sends a 100k-character value in each and checks the error doesn't echo it back.
- **`ContentFiles` docstring (purist/curator):** it no longer claims to mirror the `publish`/`upgrade` schemas. It now says what they share and how `ContentFiles` differs: the `text` variant, `.strict()`, and bounds on every field.

**Should-fix items applied:**
- The try/catch around base64 decoding is gone; the file label is passed to `decodeBase64(bytes, label)` instead. The existing base64 test now matches the decoder's own "Invalid base64" message.
- A separate `MAX_ENTRY_CONTENT_BYTES` name now covers the per-entry check, and `contentValueLabel` is used everywhere.
- `resolveGuestMainWorker` and `mainWorkerName()` now return the literal type `"@main" | "MAIN"`. `mainWorkerName()` is documented as the facet's one composed member, with the reason it lives there.
- There is still no `upgrade` twin. A one-line justification is in the tool-family header: in-place upgrade isn't available when publishing is served live.
- The mock authorization server comment no longer claims fidelity to a real IdP; it now says `/token` can widen the scope granted at `/authorize`.
- The new `→` and `…` in runtime strings are now `->` and `...`.
- The PR body is trimmed from 327 to 244 words and now mentions the mock authorization server work. The title gained ", plus mock authorization server scope fix".

**Checks:** typecheck passes. The full suite had one failure out of 978 tests, in `test/git-remote/capability.test.ts`. That test belongs to code this PR doesn't touch, and I recorded it earlier as a known host-environment failure.

The push went through `safe-push-pr-head.sh` as two follow-up commits on `feat/weblet-publish-dir`: `4f39cee fix(clip)` and `1370125 docs(dev)`.

**Not done, for the panel-2 round or the maintainer:**
- **Commit history (integrator/packager):** they asked to squash the paired lock-file commits that cancel out and regroup the history. That needs a history rewrite, which is outside a fix round.
- **Splitting off the mock authorization server work:** they asked for a separate PR. For now it is called out in the title and body.
- **Live-daemon test for the `writeText` path:** there is still no live-daemon test confirming a `writeText` value reaches the worker as a string.
- **Comment-only notes:** the leftover "mock AS" / `dev:as` spellings and the `guest.has!` non-null assertion are unchanged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1441142 cached reads)
- Output: 12112 tokens
- Cost: $1.1549804
- Wall-clock: 314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
