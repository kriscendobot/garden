**Gauntlet un-draft stage: endojs/endo-but-for-bots#1597**

PR #1597 ("test(agent-tools): pin Git facet method sets across guards, types, and declarations") is now ready for review, at the same head the panel passed.

- **Check before the change:** the PR was OPEN and still a draft, and its head was exactly `ca6f7c53af5be154b7b017d115866234129dd3f2`, the head the panel covered.
- **Action:** ran `gh pr ready`.
- **Check after the change:** `isDraft` is now false and the head is still `ca6f7c53af5b…`.

**Extra review (advisory only, did not block the un-draft):** a quick `claude -p` read of the 394-line diff found nothing blocking. Points the panel may have missed:
1. **Streaming verbs may not work for agents.** The prompt surface now advertises `followRootChanges` and `followLatestRoot`, which return passable-stream readers. No test shows an agent can actually use them through the code-mode sandbox bridge.
2. **The new contract test checks against its own source.** Removing `GIT_READONLY_MEMBERS` and `memberFilter` drops the manual review point for which reader methods go into the prompt. The new test compares against `GIT_READER_METHODS`, which is the same list the facet is built from, so a new reader method would pass without anyone deciding it belongs in a prompt.
3. **The test only reads the checked-in `git-declarations.js`.** It doesn't regenerate it from the extractor, so it relies on a separate freshness check that this diff doesn't show.
4. **One extracted type looks lossy.** `GitRemotableFilesystem = GitFilesystem & unknown` is effectively just `GitFilesystem`.
5. **The test depends on the monorepo layout.** It deep-imports `@endo/exo-git/src/interfaces.js` and reads exo-git's `types.ts` by relative path.

Two smaller notes: the design doc has unrelated punctuation changes (`…`→`...`, `→`→`->`). No garden files changed and nothing needs following up.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1597-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176317 cached reads)
- Output: 1430 tokens
- Cost: $0.41322339999999996
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
