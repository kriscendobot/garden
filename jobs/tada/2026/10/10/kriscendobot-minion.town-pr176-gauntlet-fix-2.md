All of panel round 2's must-fix items on kriscendobot/minion.town PR #176 are fixed and pushed. CI is green: `ci-wait-merge` returned rc 0 with 3 checks and 0 failed.

**Must-fix items (all done)**
- **Stylist (naming):** In `deploy/aws/scripts/git-remote-partition.sh`:
  - `cmd` is now `command`.
  - `args_json`, `args_base64`, `ARGS_BASE64` and the box-side `args` object are now `parameters_json`, `parameters_base64`, `PARAMETERS_BASE64` and `parameters`.
  - The shell `id` is now `partition_id`, and the JS `args.id` is now `parameters.partitionId`.
  - `test/git-remote-partition-script.test.ts` changed to match, including the `PARAMETERS_BASE64=` regex.
  - The panel also flagged the short names in the `DEPLOYMENT.md` snippet (as should-fix, alongside the naming items). They are now spelled out: `script`, `owner`, `partition_id`, `readwrite_token_hash`/`read_token_hash` and `readwrite.url`/`read.url`.
- **Pruner:** The `destroy` usage text no longer explains how storage works (the shared store and its lack of cleanup). It now says only what the command does.

**Optional fixes I also made**
- `box_node` now writes the box-side module to a private `mktemp` file owned by `minion-git`. Before, it used a predictable, world-readable `/tmp` path that another local user could hijack.
- The usage text is now a heredoc instead of a fixed line range of the script header, and the `mint` entry warns that the URL is kept in AWS's SSM command history.
- `create` now fails clearly on an empty reply.
- `destroy` now deletes the partition's record, which holds its tokens, before deleting the repo.
- Two new test assertions: one for `create` on an empty reply, one that `mint` uses `mktemp` and no `/tmp` path.

**Verification:** The script's test file passes locally (19 tests) and `npm run typecheck` is clean. Shellcheck only notes that it can't follow the sourced `common.sh`.

**Push and summary comment:** The fix is one follow-up commit, `24866b2` (on top of `adacedd`), pushed with `safe-push-pr-head.sh`. The panel's scribe asked for a summary comment, which I posted: https://github.com/kriscendobot/minion.town/pull/176#issuecomment-6102422012

**Not done this round (listed in that comment):**
- `mint`, `revoke` and `destroy` can still overwrite each other's changes, or the live service's, when run at the same time. The script still tells operators to run one at a time. A real fix belongs in `PartitionStore`.
- `destroy` still hard-codes the store's on-disk layout and the compiled `dist/` paths. A `PartitionStore.destroy` method is the better fix.
- The minted URL still passes through the SSM output that AWS keeps. Revoking the token afterwards is the only mitigation.
- There is no test for the no-overwrite failure path in `mint`, the owner check is still only pinned by a substring match, and there is no handling for an SSM timeout after a mint succeeds.
- Squashing `adacedd` is left for merge time.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr176-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1161122 cached reads)
- Output: 10879 tokens
- Cost: $1.0328044
- Wall-clock: 863s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
