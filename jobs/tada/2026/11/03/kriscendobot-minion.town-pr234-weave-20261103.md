I wove kriscendobot/minion.town#234 onto current `main`. It's mergeable again, and still out of draft so the proxy screen can re-screen it.

**What changed**
- **New frozen base:** I pushed `main-3f6c2b2` at `3f6c2b24`, which is the merge of #233. I moved the PR's base from `main` to it.
- **Rebase:** I replayed all 12 commits from the old merge base `c5c35044` onto `3f6c2b24`, and none became empty. The head moved from `bb6f1bee` to `0e10e33b` (force-with-lease, checked against `bb6f1bee`). The diff against the frozen base is the PR's 14 files only.
- **GitHub check:** after the push, the PR reports base `main-3f6c2b2` and `MERGEABLE`.

**How I resolved the conflicts in `src/web/guest-web-router.ts`**
#233 moved the router's own invitation map and accept logic into a new shared registry, `src/web/local-invitations.ts`, which the MCP `invite` tool also uses. Two of #234's commits edited the old in-router code, so their behavior had to move into the registry rather than be taken from either side:
- **`10a59872` (forgotten-contact replays):** the registry now records the name an invitation was accepted under. `accept()` takes an optional `{ stillHolds(acceptedAs) }` check. On a replay, if the guest no longer holds that name, it answers "invitation unavailable" (404). The router passes a check that inspects the guest's contacts. The return type is unchanged (`"accepted" | "repeat"`), so #233's existing registry tests still apply. The rest of that commit (the 400 for a malformed path parameter, the comment edits) applied cleanly.
- **`bae1dcdc` (retire on forget):** git merged the forget route without a conflict marker, but the merged code looped over a map that no longer exists. I added `registry.retire(inviteeFormulaIdentifier, petName)`, and the router calls it after `forgetContact`. So this hidden break got the same move into the registry as the explicit conflict.

#233's behavior is all kept: the shared registry, invitations minted via `mint({redeem})`, and the `InvitationSpentError` and cancel paths.

**Local checks**
- `npm run typecheck` passes.
- `npm test`: 1664 passed, 14 skipped, 1 failed. The failure is `test/git-remote/capability.test.ts > projectPartition > propagates a git failure rather than reporting the ref absent`. Neither the PR nor #233 touches `git-remote`, so it fails the same way on main; it is likely the sandbox's git setup. It still failed with a fresh temp directory under `/tmp`. Every web-router, invitation-registry and invite-tool test passes.

**Follow-ups**
- No comments were posted on the PR, since the job didn't authorize any.
- The proxy screen has to re-screen head `0e10e33b` and then merge it. The merge now targets `main-3f6c2b2`, as the job asked.
- Reviewers should look at the two new registry methods, `accept(…, {stillHolds})` and `retire()`. They are new API on #233's module and appear in #234's diff, not just a replay of its original edits.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `bb6f1bee265fa0c7341291330adc70a5a1f422ac`; this job presented `0e10e33b9e777db6732e1ea635a88bf4b8c460d3`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-weave-20261103.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1411276 cached reads)
- Output: 8404 tokens
- Cost: $1.0434632000000001
- Wall-clock: 132s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
