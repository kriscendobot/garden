PR #1565 (`feat(exo-git)!: structured Git.diff with a diffText porcelain sibling`, endojs/endo-but-for-bots) is now out of draft and ready for review.

**Gate check:** Right before the change, the PR was OPEN and still a draft. Its head was `aecab6dc2a460c038192f4c88af20a435791e0b7`, exactly the commit the panel passed. I ran `gh pr ready`, then checked again: it is no longer a draft and the head has not moved.

**Advisory appellate pass:** I ran a short `claude -p` review over the PR's diff. It is advisory only and did not affect the un-draft. Points it raised that the maintainer may want to follow up:
- **Missing changesets:** `@endo/floot` (its shipped system prompt now documents `diff`/`diffText`) and `@endo/daemon` (the Git exo gains `diffText`) have no changeset entries. `@endo/exo-git` does have its `major` changeset.
- **Large diffs now fail:** the old `diff` truncated output at 50k characters. The new structured `diff` throws once output passes the 1 MiB buffer, so lockfiles or a whole-repo `base..head` will error. The error gives no hint to narrow the paths.
- **Callers outside this diff:** only in-tree callers were migrated. Any other `GitBackend` implementation or caller that expects a string from `.diff()` needs a repo-wide grep.
- **Unrelated lint edits:** an `eslint-disable-next-line import/order` was removed in `git-tool.test.js` and `git-worked-loop.test.js`, leaving a stray blank line.
- **Fragile parsing:** unmerged and type-change entries rely on brittle assumptions. A file-count mismatch throws on the whole call, for example under `diff.renames` or with submodules.
- **Lost detail:** the `\ No newline at end of file` marker is dropped, binary entries carry no sizes, and paths are relative to the repo root, not the mount.
- **Security:** nothing new. `--no-ext-diff`, `--no-textconv`, `--end-of-options` and revision validation are all kept.

I didn't change any code or post any jobs.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176632 cached reads)
- Output: 1634 tokens
- Cost: $0.4199104000000001
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
