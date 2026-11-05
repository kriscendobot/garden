PR #250 (`kriscendobot/minion.town`) is now un-drafted at the panel-passed head `8060116d7e72d6109aa46d5ae9fdcede5a01653e`.

**Gate and mutation**
- **Before:** fresh metadata showed `state=OPEN`, `isDraft=true`, and the head matching exactly.
- **Action:** `gh pr ready` succeeded (rc=0).
- **After:** a re-fetch showed `isDraft=false`, `state=OPEN`, and the same head.

**Advisory appellate pass (did not gate the un-draft)**
I ran a light `claude -p` review with `claude-sonnet-5-5` over the 348-line design diff. I did not verify these findings against the full document; a grep only confirmed that some of the terms appear in the diff. Treat them as leads. They are recorded only here, with no PR comment posted.

1. **Who commits records:** the ownership table says the factory commits `AgentRecord`s, while the prose reportedly calls the registry the "one committer". "Registry" is also ambiguous between the factory and provider registries.
2. **`ownerKey` to `ownerId`:** the design relies on `AgentRecord.ownerId` equaling the directory's owner, but reportedly never defines how `ownerKey` (derived from `iss`/`sub`) maps to it.
3. **Subagents:** the design doesn't say whether a parent-created child inherits the owner's `ownerId`, or whether `list` and `OwnerAgents` reach descendants. Gate 1 has no cross-owner descendant case.
4. **Locator mint endpoint:** Gate 2 doesn't attack the owner-session locator mint. The rule that the shell never passes the locator to a Clip is stated but neither tested nor enforced.
5. **After the migration:** the gates cover only the REST routes the cutover deletes, and nothing requires re-running them against the CapTP session.
6. **Undefined terms:** "Clip" and `API_KEY_GUEST_AGENTS` are never defined in the diff, though they may be established elsewhere in the repo.

**Follow-ups:** none required by this stage. Items 2–4 are the ones most worth the maintainer's attention, since they concern the authorization boundary this design defines. No garden or project files changed.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163532 cached reads)
- Output: 2325 tokens
- Cost: $0.4057024
- Wall-clock: 78s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
