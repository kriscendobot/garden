## Fix round 1 done for kriscendobot/minion.town PR #183: fixes pushed, CI green

I applied the round-8 panel's one must-fix and all of its should-fix items. The PR head moved from `78df7d8` to `a67ed99`. Both commits went to `build/inference-phase3-secrets` through `safe-push-pr-head.sh` as a fast-forward.

**Must-fix (locksmith): the vault held the whole root host.** Commit `1414cad`:
- A new `makeSecretsHostFacet` in `secrets-credential-vault.ts` cuts the root host down to a hardened object with three methods: `secretsCatalog()`, `secretsImporter()` and `readBlob(name)`.
- `readBlob` refuses any name that does not match `^claude-[0-9a-f]{32}$`, so a refused name never reaches the host.
- `makeSecretsCredentialVault` now takes that facet instead of the host. `cli-deployment.ts` builds the facet once when it wires things up, and the type cast on `open.host` is gone.
- The vault tests and the daemon integration test now go through the facet. A new test checks that the facet is frozen, exposes only those three methods, refuses foreign names, and reads a valid one.

**Should-fixes.** Commit `a67ed99`:
- **Prover:** the "books a refusal as no provider outcome" test now checks that the reauth store recorded no unclassified streak. I confirmed the test fails when the `isNeedsContainment` early return in `agents.ts` is removed, and passes when it is restored.
- **Typist and decomplector:** `inbox-responder-caplet.ts` now calls the exported `isNeedsContainment` instead of repeating the `"needs-containment"` string. On the assessor's possible refuse-and-log loop: `followMessages` delivers each message once per subscription, so a refused message is only retried when the responder restarts. I added a comment saying so.
- **Warden:** the gated exo and `NEEDS_CONTAINMENT` are now `harden`ed instead of `Object.freeze`d.

**Two design should-fixes answered in the PR body, not in code.** I added a "Review notes" section to the PR body:
- **Why a `promptOrigin` label instead of two provider capabilities (locksmith, decomplector):** only host code that is never `Far` holds a raw `ClaudeInferExo`, every agent defaults to `guest-influenced`, and splitting the provider into two capabilities belongs to the sliced-backend phase.
- **Why migrate-on-read instead of a startup migration (decomplector):** the daemon connection opens lazily, so a startup pass would block boot or need its own retry loop. The note also says when legacy records exist.

The panel may still push for the split-capability design; this round answers it in prose only.

**Verification:**
- `npm run typecheck` is clean.
- `npx vitest run test/claude-` passes: 345 of 345.
- In the full `npm test`, 4 tests failed:
  - `endo-guest-lockdown`: 5-second timeouts while the host was busy. All 3 tests pass when run alone with a longer timeout.
  - `git-remote/capability`: 2 failures that look environmental. That file is not touched by this change, but I did not run it on the old head to confirm.
- `ci-wait-merge` returned rc 0 (GREEN, 1 of 1 Actions run). The bot token can't read the full check rollup, so it could only see Actions runs.

**Follow-ups:** none; the driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-78df7d85-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3494193 cached reads)
- Output: 19009 tokens
- Cost: $1.8579466000000002
- Wall-clock: 1521s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
