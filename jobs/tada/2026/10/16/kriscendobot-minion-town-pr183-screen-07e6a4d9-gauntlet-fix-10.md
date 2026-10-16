## Gauntlet fix round 10: kriscendobot/minion.town PR #183

I fixed all three must-fix items from panel 10, pushed the fix to the PR head as 623a7c7, and CI on 623a7c7 is green (`ci-wait-merge` rc 0).

**Must-fix items:**
1. **Unprobed token could be activated after a failed store (saboteur).** In `secrets-credential-vault.ts`, if a re-store fails after the secret may already hold the new bytes, `storeNow` now deletes the subject's state record. A probe from an earlier store that passes later finds nothing to activate, and the subject reads `needs-auth` until a new store succeeds. I chose this over advancing the generation on every failure because the existing test "a replacement store that fails / leaves an inference under the unchanged credential current" requires the generation to stay put. I updated the comment in `wiring.ts` to match. A new test (a `setDescription` timeout after `replaceBase64`, then `activate`) fails without the fix and passes with it.
2. **PR title claimed a phase it defers (integrator).** I renamed it to "…contain the root backend (endo-but-for-bots#1357 phase 3)". I did this through GraphQL because the REST API quota was used up.
3. **DEPLOYMENT.md cited the wrong phase and gate (integrator).** The containment-refusal text now says the sliced backend's phase 6 and gate 8 come from endojs/endo-but-for-bots#1357, not from the local design's numbering.

**Smaller fixes I also made:**
- **Pruner:** I cut the migration narrative in DEPLOYMENT.md to a pointer to the vault header plus the "no downgrade, roll forward" sentence, and moved the "older release reads a migrated record as malformed" detail into the header. I also deleted four test comments that only repeated the assertion below them.
- **Integrator (should-fix):** I removed the leftover `apiKeyHelper` wording in the design's phase-1 gate.

**Checks:** `tsc --noEmit` is clean and all 26 `test/claude-*.test.ts` files pass (345 tests).

**Left for the next panel or a follow-up (all should-fix or comment-only):**
- **Breaker:** a daemon write that lands after its timeout can still undo a later `revoke` or replacement. Also, migration leaves stray `*.tmp` files and unmigratable `version: 1` records in place, and those can still hold a token.
- **Procurer:** use `isRecord` from `@endo/pass-style` instead of the local copy (needs a new dependency).
- **Decomplector:** it questions keeping the token and its state in two separate stores, and whether the one-time legacy migration is needed at all.
- **Typist:** type annotations to add.
- **Packager:** fold the review fix-up commits into the commits they amend before un-drafting.

The PR stays a draft. The pre-pass verdict is HOLD-DRAFT because the successor job `minion-town-claude-kriscendobot-canary-after-connect-20261006` owns the remaining phases.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2718518 cached reads)
- Output: 14165 tokens
- Cost: $1.5867956000000003
- Wall-clock: 2167s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
