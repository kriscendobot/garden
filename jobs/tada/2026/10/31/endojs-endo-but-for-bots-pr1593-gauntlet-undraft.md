Un-draft stage done: endojs/endo-but-for-bots#1593 ("feat(agent-tools): compose HTTP workspace tools") is now ready for review.

**What I did**
- **Gate check:** Just before changing anything, the PR was open, still a draft, and its head was exactly `d1f1cc58d9368b505f4fcebf470b7003ae70d734`, the commit the panel passed.
- **Un-draft:** I ran `gh pr ready`. A fresh check afterwards showed it is no longer a draft and the head is still `d1f1cc58…`.
- **Advisory appellate review** (a Sonnet pass over the diff only; it did not gate the un-draft). It raised three points:
  1. Both the git `remote` tool and the new `http` tool expose a tool named `fetch`. Granting the two together always fails with a collision error. That fails safely, but an agent can't have push access and confined HTTP at the same time. The design doc marks Phase 3.6 as landed without mentioning this.
  2. The new tests pass an empty stand-in object, so they only check tool names. They don't confirm the changeset's claim that `http` exposes only `fetch` and `allowedOrigins`. Nothing tests what happens if a host passes the policy-control object as `http`.
  3. The README says `makeShellTool` and `makeHttpTool` also produce `inspect` and `fetch`. That may conflict with the new test showing `http` yields only `fetch` and `allowedOrigins`. Checking `json-tools/http.js` and `json-tools/shell.js` would settle it.

**Follow-ups:** The three appellate points are for the maintainer's review. If the git loop needs network access, point 1 blocks that use. Nothing changed in the garden repo, so there was nothing to commit.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1593-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176191 cached reads)
- Output: 1384 tokens
- Cost: $0.41171019999999997
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
