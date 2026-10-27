# Completion report: design-claude-api-agent-workbench-20261027

The agent-workbench design is done as two draft design PRs, one per repo, following each repo's convention. Each has only the design files in its diff. I filed no budget request, because the script the skill names does not exist (see Follow-ups).

## What I did

**Endo side: [endojs/endo-but-for-bots#1574](https://github.com/endojs/endo-but-for-bots/pull/1574)** (draft, slug `api-key-agent-workbench`)
- It is stacked on #1543. Its base is a frozen snapshot of #1543's head, `design/claude-api-key-agents-81e5e47`, because my design builds on the file #1543 adds and needs its README rows.
- The diff is `designs/api-key-agent-workbench.md` plus the `designs/README.md` index updates: summary row, M3 table row, dependency-graph node, estimate row, and the count paragraph (Proposed 34 → 35, records 253 → 254).
- The milestone duration and timeline are unchanged. I marked the estimate provisional until the open questions are settled, as the README did for the 2026-09-12 hosted-sandbox estimate.
- The design contains:
  - **Reuse table:** each capability, the existing design that supplies it, where it sits on the roadmap, and the small change it needs.
  - **Endowments:** a new agent-factory operation, `endow`. The owner can endow only capabilities they hold. The factory refuses to pass on any facet it minted itself (inference grants, provider facets, control facets).
  - **Budget:** a child's grant is an attenuation of its parent's #1543 grant record. Every request is checked against the child's own grant and each grant above it, in #1543's one usage ledger. There is no second ledger, and limits above the parent's are refused, not clamped.
  - **Spawner:** `AgentSpawner` uses the #1543 agent factory to create each child as an ordinary agent with a parent pointer. It is compatible with Fae's `SubagentSpawnerInterface`, so Fae's existing subagent tools work unchanged.
  - **Control facet:** `DelegationControl` offers pause, resume, resize and revoke. Revoke also deletes the child's own subagents, deepest first.
  - **Abuse controls:** limits on depth, children per agent, agents per tree and spawn rate, each with its own refusal code.
  - **No key material:** a child only ever receives its own inference grant.
  - **Workbench tool bundle:** a mount confined to a subtree plus a git reader or writer. Tools are `glob`/`grep`/`glorp`, hashline edit, bounded `readLines`, exact-string edit and git status/diff/log/commit. Rewriting history, push, shell and network are excluded.
  - **Ownership map.**
  - **Phases W1–W6**, starting after #1543 phase 5 and each with acceptance tests. W6 is the live end-to-end run of the maintainer's scenario on production with the dedicated canary key.
  - **6 open questions** for the maintainer.

**minion.town side: [kriscendobot/minion.town#228](https://github.com/kriscendobot/minion.town/pull/228)** (draft, `designs/agent-chat-clip.md`, base `main-443519e`)
- **Shape:** one chat Clip per owner. The Clip reaches a per-conversation `ChatSession` only through the nonce locator from minion.town#88. The locator is minted by an account-gated endpoint, expires, and can be revoked.
- **Turn flow:** a message goes to the agent's pinned responder, status events follow, and the reply streams in as message edits until it is marked done.
- **Clip sandbox rules:** no `<form>`, no inline script, CapTP only over the Clip's own origin, inert links, the locator scrubbed from history, and no transcript kept in browser storage.
- **Trusted UI, kept outside the Clip:** the endowments step and the delegation tree, where the owner can pause, resize or revoke any child.
- **Plan:** phases C1–C4, then the canary, with 4 open questions.

**Tracker [#227](https://github.com/kriscendobot/minion.town/issues/227):** I added review asks 3 and 4 (the two sets of open questions) to the table and posted a result comment.

**"Glorp":** it already exists. It is the fused glob+grep method on `EndoMount`, added in endo #713 as `glorp(globPattern, grepPattern, opts)`. No design document owns it, and the doc its code comment cites (`platform-search-pushdown.md`) does not exist, so I did not need to ask the maintainer. The design records this as a gap for the next grooming pass.

**Checks:** both mermaid diagrams and the edited README graph parse; `prettier --check` passes on the Endo files.

## Follow-ups
- **Build:** the workbench build is Endo phases W1–W5, the minion.town chat Clip C1–C4, and the W6 live canary. I posted no build job; the build handoff picks it up once the design gauntlet passes.
- **The build waits on:** the maintainer's answers to the open questions, #1543 merging and its phase 5 landing, and, for chat Clip phase C3, minion.town#88 or the `ChatDoor` stopgap named in open question 1.
- **Stacked PR:** #1574's base is a snapshot of #1543's head. If #1543 is rebased, #1574 needs a new snapshot and a rebase onto it.
- **Budget request not filed:** the budget-request skill names `scripts/jobs/request-budget.sh`, which exists neither in the deployed root nor on `main2`. My estimate is about 40M tokens across about 10 builder jobs, effort slug `api-key-agent-workbench`. The skill and its script need reconciling.

<!-- garden-design-build-handoff: successor=build-claude-api-agent-workbench-20261027 state=recheck:endojs-endo-but-for-bots-pr1574-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1574 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-claude-api-agent-workbench-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (9173529 cached reads)
- Output: 59291 tokens
- Cost: $6.660867799999997
- Wall-clock: 901s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
