---
kind: panel-run
repo: kriscendobot/minion.town
pr: 183
panel_kind: code
base_ref: bc110102b6f14c7709e9635e86d2b8bb55cc7039
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: f8cf901fa8420fd0ab05c603aa3892789221f185
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: daaa4adcff23
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #183 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `f8cf901f`

seat verdicts (34): archivist=comment assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=must-fix orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (20):
- breaker: **should-fix: "root-authored means the operator typed it" is not enforced where it is claimed.** The `agents.ts` JSDo...
- breaker: **should-fix: `bounded()` timeouts break the "runs alone, in arrival order" claim in `secrets-credential-vault.ts`.**...
- breaker: **should-fix: a revoked or externally altered blob reads as an error, not as `needs-auth`.** In `readSecret`, when `l...
- breaker: **comment-only: the inbox responder leaves needs-containment mail in place.** It `return`s without dismissing, so the...
- breaker: **comment-only: the legacy-migration path is consistent.** A `status` call that tolerates a failed migration returns ...
- breaker: **Sibling-family check.**
- breaker: `gateOnPromptOrigin` wraps only `providerFor`.
- breaker: `childProviderFor` is intentionally ungated, since it is the sliced path.
- breaker: `runConfinementProbe`, `derivePlanModels` and `deriveCredentialExpiry` run fixed prompts with no guest input, so they...
- breaker: `makeClaudeAgent` has one default (`guest-influenced`) and one override, in `makeRootAuthoredInfer`. No other `makeCl...
- breaker: The family is consistent.
- breaker: Origin is read once by destructuring, so it can't change between the check and the use.
- breaker: The wrapper exo is frozen.
- breaker: A missing or unknown origin is refused.
- breaker: Skipping `recordOutcome` on needs-containment correctly keeps the unclassified streak clean.
- breaker: The secret name is derived from the subject, never taken from the record.
- decomplector: **must-fix: a second credential store sits beside the first.** `src/endo/claude/secrets-credential-vault.ts` is a new...
- decomplector: The existing path is `credential-vault.ts`, which the diff leaves in place, plus the daemon's `@secrets` blob.
- decomplector: The state file (`planModels`, `storedAt`, `active`) is derivable or could live in the blob's description.
- decomplector: Two threads of concurrency hardening (`serialize` and `bounded`) exist only because the design braids blob lifecycle,...
