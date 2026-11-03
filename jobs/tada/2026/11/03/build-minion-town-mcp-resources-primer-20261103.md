## Completion report: build-minion-town-mcp-resources-primer-20261103

The job is done. A previous claimant had already opened draft PR #235 (kriscendobot/minion.town#235, branch `garden/build-minion-town-mcp-resources-primer`), and `ensure-pr.sh` adopted it. Its CI passes: test, changes, and Claude harness on amd64 and arm64. It covers all five tasks:
- **MCP resources and `instructions`:** 11 resources, served by `src/resources.ts`.
- **The `evaluate` guide:** it explains that `values` entries are names of existing pet names, not literals.
- **Generated references:** the guest and host facet references are generated from the daemon's interface guards, with a CI check that they haven't drifted.
- **The primer:** a first cut under `primer/` (roles, skills, and a README on grafting it into a guest).
- **Tool-surface audit:** in the PR description, with removals proposed but no tool removed.
- **A fix:** `evaluate` no longer reports a protocol error when the evaluated code returns `undefined`.

**What this attempt did:** the one missing piece was checking the recipes against production. The PR said a successor job, `verify-minion-town-mcp-recipes-20261103`, would do that, but it was never posted. I ran the recipes myself through the live minion.town MCP tools as the existing principal, then updated the PR description with the results. I pushed no code. Limits held:
- One throwaway invitation, accepted by the same principal.
- No new guest.
- One smoke clip, unpublished afterward.
- Every `recipe-*` name removed and the inbox left empty.
- No invitation locator copied into the PR.

**Production results:**

| Recipe | Result |
| --- | --- |
| List names | PASS |
| Method list and `help` | PASS |
| Bind a stored file or value; directory paths | PASS |
| A literal or unknown name in `values` fails as the guide says | PASS |
| Invite | PASS |
| Accept (same principal) | PASS |
| A second accept is refused and binds no name | PASS |
| Send text and receive (`evaluate` and the `send` tool) | PASS |
| Send a capability, adopt it, dismiss the message | PASS |
| Publish with an inert pet name | PASS (the clip was served with status 200; that name exposes only read methods for stored bytes) |

Three recipes were not run in production: accepting from a second guest (it would need a new guest), cancel (it would need a second invitation), and the host facet (this principal holds no host). All three pass against a local daemon.

**Findings to log.** None of these block invite and accept between agents through `evaluate`:
1. **`undefined` results (confirmed in production):** when the evaluated code returns `undefined`, the tool answers `MCP error -32602: Invalid tools/call result` even though the action, such as a dismiss, already happened. PR #235 fixes this; until it merges, recipes must end in `.then(() => '...')`.
2. **Web invitations:** a locator produced by `evaluate` can't be accepted from the web page, so the `invite` tool is still needed to invite a person rather than an agent.
3. **Naming results:** `evaluate` can't store its result under a name.
4. **Endo help gaps:** `help('send')` and `help('evaluate')` return no documentation.
5. **Unclear error:** `readText` on a stored value gives an unhelpful message.
6. **The primer is copied in:** grafting it into a guest makes a copy, which won't pick up later changes.
7. **The locator is a secret:** accepting puts the invitation locator into the tool's arguments, where clients may log it.

**Follow-ups for the maintainer:**
- **`invite` and `cancelInvite` are already tools:** #233 merged and deployed both, which conflicts with the direction to keep them unimplemented. The PR asks whether #233 should be reverted.
- **Which tools to remove:** decide from the proposals in the PR's audit table.
- **Review and merge:** #235 stays a draft and nothing was deployed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-mcp-resources-primer-20261103.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 46 tokens (1520129 cached reads)
- Output: 9842 tokens
- Cost: $1.0422257999999998 (1 engagement(s) unpriced)
- Wall-clock: 2531s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
