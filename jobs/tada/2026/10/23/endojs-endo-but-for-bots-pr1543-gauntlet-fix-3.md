## Gauntlet FIX round 3: endojs/endo-but-for-bots#1543 — all findings fixed, CI green

I applied every finding in the latest panel verdict (review 5624468784, 2026-10-23T05:55Z), both must-fix and should-fix. The job carried no pre-pass block, so that review was the source. The fixes went to the PR head `design/claude-api-key-agents` as one follow-up commit, **`6a83f1f22`**, pushed with `safe-push-pr-head.sh`. CI on that commit finished with all 30 checks passing and none failing (`ci-wait-merge.sh --no-merge`, exit code 0).

**What changed, by juror:**
- **critic / decomplector (must-fix): a new agent could be left paused after a crash.** `AgentRecord.wakeState` is now the one source of truth for whether an agent should wake; the responder's own paused/running flag only follows it.
  - Agent creation gets a new last step, *Activate*, and a new final state, `completed`. Success is not reported until activation finishes.
  - The recovery process now resumes operations that were committed but not activated, and it also re-applies the desired wake state to every active agent.
  - Wake toggles follow the same order.
- **decomplector (should-fix): provider records claimed to never change but did.** The provider record is split into a fixed `InferenceProviderDescriptor` and a changeable `InferenceProviderLifecycle` (state, limits, upstream-revocation note). Every lifecycle change is written to the audit log.
- **skeptic (must-fix): "Revoke now" can't revoke a leaked key upstream.** It is renamed **Disable key in Endo**. The UI now says plainly that the key still works at the provider and shows the step to revoke it in the provider's console. The provider row keeps showing "upstream revocation not confirmed" until the owner says they did it. There is a new acceptance test for this.
- **skeptic (should-fix): the same key imported twice gets two sets of spend caps.** I narrowed the guarantee rather than adding detection: caps now explicitly apply per provider, not per upstream account. The UI says so, there is a test for importing the same key twice, and an owner-wide cap is added as open question 7.
- **ergonomist (must-fix):**
  - **Dismiss** is renamed **Delete agent**. Its confirmation names the unread messages and transcript that will be lost, and focus starts on Cancel. The related operation is renamed from `dismiss` to `delete`.
  - Turning on wake when mail is waiting now shows the number of queued messages and offers Process / Skip / Cancel before anything is spent.
  - **Rotate key** is replaced by **Replace key**, a guided move of agents to the new key.
- **novice:** added a plain-language paragraph explaining powers profiles at the start of the user-experience section, and an old-path-to-new-path table in `claude-bare-course-correction.md`.
- **archivist:**
  - Corrected the overstated claim about what `llm-provider-factory.js` validates; the general field checks are now specified as new work in the provider registry.
  - Marked `endo-claude.md` as superseded, with a banner, and updated its row and the totals line in `designs/README.md`.
- **pedant:** added Updated/Author metadata to both new designs and wrapped the over-long lines in the README and course-correction doc.

No follow-ups are needed; the gauntlet driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2390009 cached reads)
- Output: 21671 tokens
- Cost: $1.7561097999999997
- Wall-clock: 1088s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
