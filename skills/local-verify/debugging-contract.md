# local-verify — the debugging-agent contract (selective inspection)

Reference companion to [SKILL.md](SKILL.md). This is the token-efficiency core: how
an agent handed a failure block reads **only the slices it needs** from the blob,
never the whole log.

```sh
# the failing test's assertion and the lines around it
git -C <worktree> cat-file -p <sha> | grep -n -A5 -B2 'FAIL\|Error\|✗'
# just the first error
git -C <worktree> cat-file -p <sha> | grep -m1 -i error
# the tail (a stack trace, the summary line)
git -C <worktree> cat-file -p <sha> | tail -40
# a specific failing file's section
git -C <worktree> cat-file -p <sha> | sed -n '/packages\/foo/,/^$/p'
```

The full log is in git, content-addressed and immutable, but it enters the
agent's context only one narrowed slice at a time. This generalizes the gardening
state machine's diverted `GARDEN_TRACE` (trace to a file a debug subagent reads,
not to the supervisor's stdout) and the
[prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md) pattern
(hash a failure log into git, pass the SHA, inspect on demand). The shared
primitives are `capture_blob` / `inspect_note` / `anchor_blob` in
`scripts/jobs/common.sh`.

Cross-host note: `git hash-object -w` writes the blob into the **local** object
store of the worktree only. A same-host debugging agent (the usual case: the
gardener supervising this PR) reads it directly. To make a capture inspectable
from another host, anchor it under a ref and push it
(`anchor_blob`), per [prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md)
§ Cross-host reachability.
