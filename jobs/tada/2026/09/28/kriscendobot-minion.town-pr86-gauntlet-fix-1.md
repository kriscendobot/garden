# Gauntlet fix round 1: kriscendobot/minion.town#86

I fixed the panel's must-fix items and pushed them to the PR head. CI came back green (all 3 checks). Locally, `npm run typecheck`, `npm run build` and `npm test` all pass (614 passed, 8 skipped). I rewrote the branch history once, so the PR head moved from `8689f79` to `0f9633a`.

**History rewrite** (asked for by packager and integrator). I pushed with `safe-push-pr-head.sh --mode rewrite`, which force-pushes safely.
- Squashed the leftover `fixup!` commit into the refactor commit it belonged to.
- Moved the `/healthz` comment in `app.ts` out of the docs commit and into the refactor commit.
- Before adding anything new, the tree was identical to `8689f79`.

**`b337f7a` fix(git-remote): make revocation durable and harden the push projection**
- **Revoked tokens coming back:** a `mint` racing a `revoke` could write a revoked token back to disk. Each store now runs mint, revoke, `setContentRoot` and index rebuilds one at a time through a single queue. I disabled the queue to check the two new race tests, and both fail without it.
- **Full scan on every bad token:** an unknown token used to trigger a rescan of every partition (twice on a cold start). The index is now rebuilt only when the partitions directory's modification time changes, so a bad token costs one `stat`. Mints and revokes made by another store instance are still picked up.
- **Unsafe paths in a push:**
  - Pushed file paths now go through the same check the guest publish path uses (`normalizeManifestPath` in `publish.ts`). That rejects the `gateway/` and `.well-known/` prefixes and `.`/`..` segments.
  - Symlinks and a file literally named `__proto__` are skipped.
  - Every skipped path is logged.
- **Deleted branch kept serving:** a push that deletes the served branch now clears the recorded `contentRoot` instead of leaving old content up.
- **Naming and comments:**
  - Spelled out abbreviated names (`rec`, `cap`, `err`, `buf`, `res`, `p`, `c`).
  - Replaced the hand-written path helpers with `node:path`'s `dirname` and `basename`.
  - Changed arrow and comparison symbols in comments and test titles to ASCII.
  - Added a comment explaining why `GIT_HTTP_EXPORT_ALL` is safe, and corrected the timing-safety comment.
- **New tests:**
  - The TLS requirement switched on: plain HTTP and forwarded `http` get 403, forwarded `https` is served.
  - A table of `GIT_REMOTE_REQUIRE_TLS` values that must keep TLS required.
  - Concurrency, no-rescan, and a token revoked by another store instance while the index is loaded.
  - Minting on an unknown partition, and setting and clearing the content root.
  - Exact-length limits for partition ids and tokens.
  - An empty-tree push and a push containing unservable paths.
- The git-remote tests went from 38 to 59.

**`0f9633a` docs(git-remote): move the validation runbook to DEPLOYMENT.md**
- The step-by-step validation you asked for now lives in `DEPLOYMENT.md` under "Validating the git remote after merge", and the design links to it.
- Removed the status paragraph and shortened the `@endo/platform` deferral.
- Listed `config.test.ts` and corrected the test counts.

I posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/86#issuecomment-5879378357

**Left alone on purpose**
- **fast-check:** I did not add it as a dev dependency. The TLS setting is covered by an explicit table of values instead.
- **`/dev/null` in the end-to-end test:** the reviewer marked it comment-only.
- **Trusting `x-forwarded-proto`:** this is a documented reverse-proxy trust boundary, flagged only for the record.
- **Duplicate file read in `gate()`:** it reads each partition's file twice. The reviewer called this out of scope and it isn't a correctness problem.

**Follow-up worth considering (outside this PR):** the guest publish path has the same `__proto__` problem. `buildManifest` in `content-store.ts` and the publish flow in `publish.ts` both build plain objects keyed by caller-supplied paths, so a path named exactly `__proto__` would silently drop out of a published manifest. The git projection now skips such paths; the publish path doesn't.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (4221666 cached reads)
- Output: 33366 tokens
- Cost: $2.7083812
- Wall-clock: 512s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
