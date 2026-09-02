The review is posted. The header clearly states the **must-fix** disposition so the fixer stage can read it. This stage is complete: one panel round run, verdict posted, stopping here (no fix, no un-draft).

---

**Completion report**

Ran the gauntlet PANEL round 2 for endojs/endo-but-for-bots PR #1116 (`design: guest-native invitation and acceptance`, a design-doc PR on `designs/guest-native-invitations.md`, head `9781c05d81`, base `llm`).

- Set up an isolated project worktree of the PR head (`design/guest-native-invitations`, endojs-owned).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base `llm`. The design-panel fanned seven seats (copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic). All seven returned **request-changes**; the panel's terminal disposition was **must-fix**.
- Key must-fix clusters: §5/§6 consume-once + concurrency reasoning is unsound (`withFormulaGraphLock` is a global reentrant depth counter, not a serializing mutex, so top-level concurrent `accept`s run inline unqueued; the "de-reference → collected" consume-once ledger depends on `ENDO_GC`, which is off by default in the shipped daemon, so a replayed locator can re-accept); §2/§3 attenuation story un-attenuates guest locators by advertising the daemon's addresses (conflicts with the landed `daemon-agent-network-identity` design) and leaves inviter-side `writeRemoteAgentKey`/`addPeerInfo` daemon-global overwrites reachable by any anonymous locator holder; `already-consumed` is declared normative but not derivable from kept state; plus pedant/novice/ergonomist clarity, README-plan, and rename-discipline items.
- Posted the full per-seat aggregate to PR #1116 as a review with a header stating disposition = must-fix. Note: GitHub rejects a request-changes review on the bot's own PR (HTTP 422), so it was posted as a COMMENT review (`pullrequestreview-5085603619`); the content the fixer stage reads is identical. (`gh pr view`/`gh pr review` GraphQL path was also flapping on a spurious rate-limit preflight; used the REST reviews endpoint.)

Stopped here per single-stage contract — no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 89 tokens (3052255 cached reads)
- Output: 15001 tokens
- Cost: $2.6481014999999997
- Wall-clock: 429s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
