## Gauntlet fix round 4: kriscendobot/minion.town PR #93

I fixed all four blocking items from the round-4 panel and pushed them to `feat/clip-content-store-gc` (`c8ad060` → `90502b5`) with `safe-push-pr-head.sh`, as an advance with no rewrite. CI is green on the new head.

**Commits:**
1. `9327da0` **fix(gateway): treat a blank `GIT_REMOTE_PARTITIONS_DIR` as unset** (corner-prober, must-fix).
   - In `config.ts`, a blank or whitespace value now falls back to `/var/lib/minion-git/partitions`. Before, it stayed `""`, the git-root lookup found nothing, and a `--delete` run could remove live git content.
   - New tests in `test/clip-domain-config.test.ts` cover blank, whitespace, unset and an explicit directory.
2. `b9d5462` **fix(gateway): enforce a GC grace floor and quarantine before unlink** (breaker, corner-prober, assessor).
   - **Grace floor:** delete mode now refuses any grace below `MINIMUM_DESTRUCTIVE_GRACE_MILLISECONDS` (60000 ms), including NaN. Before, only exactly `0` was refused. Both `runGc` and the CLI parser enforce it. Audit mode still accepts any non-negative grace.
   - **Quarantine:** before deleting a condemned blob, the GC renames it to a `<blobId>.tmp-gc-*` name, checks its timestamp again, then deletes it or restores it.
     - A publish that reuses the blob after the rename finds no file, so `internBlob` writes it again.
     - A reuse that landed before the rename shows up in the second check, and the blob is restored.
     - A crash between rename and delete leaves a `.tmp-*` file, which the next run cleans up.
   - Added an `afterQuarantine` test hook and tests for both race orderings and for the floor.
   - The design's invariants and acceptance criteria, and `DEPLOYMENT.md`, now describe both changes. The design also names the one race left: the kernel's ordering of a rename against an in-flight timestamp update, which no userspace check can close.
3. `90502b5` **docs(env): drop the banner rule from the GC section heading** in `.env.example` (archivist). I changed only the heading this PR added; the older section headings in that file still use the same style.

**Verification:**
- Locally, the four affected test files pass (49 tests) and `tsc --noEmit` is clean.
- CI: `ci-wait-merge.sh` never reached a verdict. Every tick failed on `gh pr view`, because this host's bot token can't read the PR's check status (GitHub returns a 403; this is already in memory). I stopped it and read the result from the Actions runs API instead. For head `90502b5`, the run "test (typecheck + vitest)" completed with success: https://github.com/kriscendobot/minion.town/actions/runs/38071401148
- I couldn't drain the inbox: the journal clone timed out (offline, rc=75).

**Follow-ups (optional, not blocking):** the panel's summary-fix suggestions are still open: a test for a content-roots file with a trailing newline or uppercase hex, a test for an exactly 8 MiB manifest, and a test for `--drop-unresolved` with duplicate ids. The typist's ASCII cleanup of the USAGE text and the deploy script's `FATAL:` strings is also still open.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2268706 cached reads)
- Output: 17542 tokens
- Cost: $1.5365731999999999
- Wall-clock: 1225s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
