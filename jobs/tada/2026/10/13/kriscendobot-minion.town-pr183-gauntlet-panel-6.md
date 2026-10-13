Panel round 6 on kriscendobot/minion.town PR #183 returned **must-fix**. `panel.sh` exited 0 in single-round mode.

- **Setup:** I ran it against the PR head `build/inference-phase3-secrets` with base `bc110102b6f14c7709e9635e86d2b8bb55cc7039`.
- **Repeated mechanism:** The same mechanism has now drawn must-fix findings in three rounds. The decomplector was seated and asked whether the mechanism is needed.
- **Review posting:** `gh pr review --request-changes` failed because the PR is the bot's own. I posted the aggregate as a plain comment review instead.

**Blocking findings (decomplector):**
- The origin refusal runs twice. It runs once inside the gated exo and again in `agents.ts` `inferAs`, and the second copy needs the `gatedExos` WeakSet and `isPromptOriginGated`.
- `rootAuthoredInfers` / `inferRootAuthored` use a hidden WeakMap to carry one bit of identity.

**Should-fix findings:**
- The inbox responder re-delivers a refused `needs-containment` message on every scan, and each retry spends a rate-limit slot.
- `status()` reports `connected` when the secret blob was revoked, and `readSecret` then throws on every infer instead of mapping to `needs-auth`.
- `wiring.ts` and `inbox-watch.ts` are not converted for the new refusal result.
- `ClaudeAgent` has no InterfaceGuard.
- A comment says root authorship is "module-private", but any importer of `inferRootAuthored` can grant it.
- The vault receives the whole root host.
- The credential is split across a blob and a JSON state file.

**Seats:** Archivist, benchmarker, changeset-auditor, orthographer, packager, procurer, pruner, reexport-auditor and thesaurus approved. Breaker, decomplector and locksmith requested changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (653559 cached reads)
- Output: 3425 tokens
- Cost: $0.3909098
- Wall-clock: 174s

<!-- garden-usage-end -->
