# Fix round 11: kriscendobot/minion.town PR #171

I applied both must-fix items from the round-11 panel and its one should-fix item, pushed them to the PR head, and CI is green on the new head. `ci-wait-merge.sh` returned rc 0 (1 Actions run, 0 failed).

**Commits** (they sit on top of `8b727de`, and the head is now `8185717`):

1. **`9d444bf` fix(deploy), saboteur #1.** In `deploy/aws/scripts/deploy-app.sh`, the step that hands the staged tree to minion-mcp used `find … -exec chown -h … {} +`. It now uses `-execdir`, so `chown` runs inside each directory on `./name` and is never given a full path. That closes the race where a live minion-mcp process swaps an already-handed-over directory for a symlink to `/usr/local` and `chown` follows it. I updated the comment to explain this. `test/deploy-app-artifact.test.ts` matches on the hand-off expression, so I updated it to look for `-execdir`.
2. **`4d693d8` docs(probe), archivist #1.** The `claude-harness-pinned-upgrade-policy` row in `DEPLOYMENT.md` now says exactly what is pinned: the binary SHA-256, the manifest SHA-256 and the signing-key fingerprint. It also says the observer is root-owned and read-only but its own content is not pinned.
3. **`8185717` fix(probe), engine-realist should-fix.** `claude-harness-observe.cjs` now hashes the binary through a fixed 1 MiB buffer (`sha256IfPresent`) instead of reading the whole file with `readFileSync`. A missing file still gives `null`, and other errors still throw.

**Checks run locally:**
- `vitest test/deploy-app-artifact.test.ts`: 7 of 7 passed.
- `node --test deploy/probe/prod-objectives.test.mjs`: 30 of 30 passed.
- `bash -n deploy-app.sh`: syntax OK.
- No linter is configured for these files.

**Follow-ups:** The driver should post panel round 12. The comment-only findings (the assessor's EISDIR/ELOOP degradation, the typist's `Promise<unknown>`) were not must-fix, so I left them alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1201406 cached reads)
- Output: 7325 tokens
- Cost: $0.8721572
- Wall-clock: 1022s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
