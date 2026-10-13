Panel round 3 on kriscendobot/minion.town PR #183 came back **must-fix**. I posted the verdict on the PR and stopped there: no fixes, no un-draft.

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot/minion.town`, branch `build/inference-phase3-secrets`, head `eee6880`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 183 main-bc11010`. It exited 0, and its last line was `code-panel single-round — must-fix`. All 34 seats returned.
- The panel's check for repeated findings noticed that the prompt-origin gate and the `@secrets` vault drew must-fix findings in both earlier rounds, so the panel added the decomplector's "is this mechanism needed?" question. Its answer: the design requires both, but each is built from more parts than it needs.
- Posted the aggregate as review 5497810719, under "## Panel verdict — round 3: **must-fix**". GitHub refused `--request-changes` because the bot can't request changes on its own PR, so it went up as a COMMENTED review. Rounds 1 and 2 were posted the same way.
- The full aggregate (104 KB) is over GitHub's size limit for a review. The posted version keeps all nine request-changes seat bodies and lists the approve and some comment-only seats by verdict only.

**Must-fix items in the review**
1. **migrator:** the gate quietly breaks the inbox responder. Mail sent to a root-created agent gets a `needs-containment` refusal, and the message is then dismissed with no retry and nothing shown to the sender. `/_internal/claude/infer` breaks the same way.
2. **archivist:** the gate's JSDoc says the refusal "never fires" under correct routing, but `DEPLOYMENT.md` says three callers now get it by design.
3. **curator/typist:** the `PromptOrigin` type is declared twice, in `types.ts` and in `prompt-origin-gate.ts`.
4. **curator/decomplector/locksmith:** the function that grants root authorship is exported, so any module that imports it can mark a prompt as root-authored. It should be private to `agents.ts`, or root access should go only to the agent's creator.
5. **integrator:** `credentials.ts:35` still names `credential-vault.ts` as the store, after the switch to the `@secrets` vault.

The round-2 must-fix items look resolved.

**Follow-ups:** the next stage is a fix-loop. The fixer should consider the decomplector's simplifications (decide origin from the call route only, keep reads from migrating, migrate once at startup) to stop findings recurring on the same two mechanisms.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1381531 cached reads)
- Output: 8432 tokens
- Cost: $1.0035702
- Wall-clock: 2178s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
