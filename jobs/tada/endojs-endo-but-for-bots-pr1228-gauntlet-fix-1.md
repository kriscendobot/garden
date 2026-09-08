The fix is pushed and CI is green. Job complete.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #1228 (`design(claude): finish the bare CLI caplet contract`), a design-doc-only PR touching `designs/endo-claude.md` and `designs/README.md`.

**Panel disposition:** must-fix (8 design-panel seats). I applied the must-fix items once and pushed as review-feedback follow-up commits (head `6d343e764e → 86b0ebf14a`).

**What I changed** (one commit, `86b0ebf14a`):
- **Renamed the pervasive "item-5" jargon** (undefined, and colliding with the document's own numbered lists — critic/decomplector/copyeditor/pedant/novice/ergonomist) to **"the one-guest MCP surface"**, introduced once with a `#1206` reference; retitled its interface section. Zero `item-5`/`item 5` references remain in the PR's files.
- **Widened the `openGuestMcp` interface** so it can express the invariants the design delegates to it (critic/decomplector/ergonomist must-fix): added a per-call `sessionTag` `cancel` seam distinct from guest-level `close`, and a `prune`/`attenuateArgs` policy parameter for DD2's code-eval prune and argument-side attenuation; returns `serverDescription` data instead of a rendered `configPath` artifact; states it composes over the lower-level `makeMcpBridge` seam **extended** with these (verified `makeMcpBridge`/`pinToolCatalog`/`TOOL_NAME_RE` against the landed source).
- **Reconciled DD6's now-optional OS slice** with prose that still called it required (argv-section back-reference, DD7 citation — critic/copyeditor/pedant), and **restated the specific escalation** an unwrapped launch leaves open (the full many-guest `captp0` endpoint via `whereEndoSock`) plus the deployment constraint (separate uid, or the slice) that closes it.
- **Recorded the tool-surface-first boundary as a proposed narrowing** of the "hermetically-sandboxed" § Prompt ask, pending a maintainer decision, rather than as authority already granted (skeptic must-fix); restored the deleted threat statement into DD6.
- **Swept the README contradiction** (pedant): fixed the "confined `claude -p`" prose row to unconfined/tool-surface, and demoted the hard `dsand --> eclaude` dependency-graph edge to optional (dotted `-.->`); added a vocabulary + `DDn`-shorthand convention block.
- Smaller panel fixes: flag-table column contract for `--permission-prompts`; "unsubstantiated" over "undocumented evidence".
- Reverted an unrelated `packages/floot/package.json` em-dash normalization introduced by `yarn install` (not committed).

**CI:** GREEN. All required checks pass on head `86b0ebf14a` (`CI (docs-only)`): lint, test (9m14s), build, browser-tests, zizmor, ironhorse-changes all pass; `ironhorse-oracle-sanitizers` skipped. `gh pr checks` exit 0.

**Follow-ups:** None for this stage. The gauntlet driver re-posts panel-2; I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 168 tokens (9691470 cached reads)
- Output: 46440 tokens
- Cost: $7.577569
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
