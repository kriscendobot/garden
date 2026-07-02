All DoD items confirmed. The job is complete.

## Completion report

**Outcome:** #594's lint driver is now JavaScript, pushed to the PR head, CI `lint` green, and kriskowal's review re-requested — the review is resolved. The PR remains draft (maintainer's call).

**What happened (collision handled).** This job was dispatched to two hosts. A peer (`kriscendobot`) landed the substantive conversion first — commit `323535ab9` "chore(lint): drive the per-bucket lint from JavaScript" — replacing `scripts/eslint-repo.sh` with `scripts/eslint-repo.mjs` and posting a thorough summary. My own push was correctly **rejected** (non-fast-forward) because the remote had advanced. Per the anti-clobber norm, I did **not** force-push my competing implementation over the peer's landed, correct work.

**Verification of the peer's driver (real evidence, not just inspection):**
- Its approach is sound and preserves the critical invariant: it spawns a **fresh `eslint` child process per bucket** (`spawnSync(process.execPath, [eslintBin, …])`), so each typescript-eslint project service is bounded to `ESLINT_BUCKET_SIZE` package programs — a pure in-process Node-API loop would reproduce the ceiling because tseslint's program cache is module-global. The driver documents this explicitly.
- I independently reproduced the fix in an isolated worktree and ran an authoritative coverage comparison via the ESLint Node API: `eslint .` and the bucketed dir set each walk **1133 files, 0 missed / 0 extra**, with `packages/where` and `packages/zip` both linted → **COVERAGE IDENTICAL**. A full bucketed run exited 0 with **0 errors, 5 pre-existing warnings**.
- Confirmed the peer's `require.resolve('eslint/package.json').bin.eslint` resolves to a real `bin/eslint.js` under this repo's pnpm layout.
- Authoritative end-to-end confirmation: the PR's own **`lint` CI job passed (4m36s)** at head `323535ab9`.

**Loop-closing actions I took (the remaining DoD gap nobody had done):**
1. **Re-requested kriskowal's review** — `requested_reviewers` now `["kriskowal"]` (was empty).
2. Posted a concise confirmation comment (same `kriscendobot` voice as the thread) that CI `lint` is now green and review re-requested: https://github.com/endojs/endo-but-for-bots/pull/594#issuecomment-4868807137

**Key URLs**
- Addressing commit: https://github.com/endojs/endo-but-for-bots/commit/323535ab9
- Review addressed: https://github.com/endojs/endo-but-for-bots/pull/594#pullrequestreview-4616520025
- Summary comment (peer, cites SHA + verification): https://github.com/endojs/endo-but-for-bots/pull/594#issuecomment-4866973037
- My CI-green + re-request comment: https://github.com/endojs/endo-but-for-bots/pull/594#issuecomment-4868807137
- Green lint job: https://github.com/endojs/endo-but-for-bots/actions/runs/28598611268/job/84800521936

**Follow-ups:** None required for this review. The separate advisory `ebfb-lint-master-strategy-evidence` job (bucket-vs-shard strategy) can still layer on top later without affecting this resolution. Did not un-draft or merge (maintainer's call).
