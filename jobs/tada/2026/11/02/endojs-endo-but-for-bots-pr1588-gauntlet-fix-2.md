orchestration-failed: true

**Gauntlet FIX round 2, PR #1588 (endojs/endo-but-for-bots):** the panel-2 fixes were already on the PR head, but CI is red on an unrelated `test-xs` failure.

**State of the fixes.** A prior attempt of this job had already pushed the panel's must-fix items at head `0d50424b56`, so I made no new commits. That head includes:
- **Allowlist narrowing (`8eef5a5ed1`):** the allowlist now narrows before any await in `revokeBinding`, `unpin` and `setAllowedOrigins`, closing the revoke race and the fail-open case. It has tests.
- **Redirects and headers (`23b23db465`):** redirect validation covers only 301, 302, 303, 307 and 308. Opaque redirects and malformed `Location` headers are rejected. The `x-http-method`, `x-http-method-override` and `x-method-override` headers are forbidden. It has tests.
- **`snapshotHeaders` (`9ec32904dc`):** `@endo/fetch` reuses the `@endo/http-confine` copy. The timer cap has a citation.
- **Changeset (`0d50424b56`):** the changeset names the breaking API changes and gives migrations. `@endo/http-confine` and `@endo/exo-http-client` are `minor`. `@endo/fetch` and `@endo/confined-fetch` are `major` at version 0.1.0.

**CI.** `ci-wait-merge` returned rc 3 (RED) twice, with 35 of 36 checks green. The only failing check is `test-xs`:
- **Failing test:** `@endo/hardened262#test:xs` reports a baseline change on `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` (passed → failed).
- **Rerun:** I reran the failed jobs once (attempt 2) and it failed the same way.
- **Why I think it's unrelated:** the PR diff touches no `ses`, `hardened262`, `module-source` or `benchmark` files. Runs of the same workflow on `llm` also alternate between success and failure.
- **Not caused by this PR:** I haven't proven that.

**Follow-ups.**
- Someone should check whether the `ThrowTypeError` baseline flake is already tracked, or fix it, before the next panel.
- I did not do these panel items:
  - The `./src/transport.js` and `./src/service.js` entries in `package.json` `exports` are not gated.
  - `Delay` is still declared in two packages.
  - The pruner's comment trims are not applied.
  - Some extra corner-case tests are missing.
  - The PR body is not trimmed.
- The next panel may raise these again as should-fix or comment-only.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 128 tokens (5611198 cached reads)
- Output: 24908 tokens
- Cost: $2.5827108
- Wall-clock: 4711s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
