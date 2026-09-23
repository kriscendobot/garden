Round-4 fix stage complete for endojs/endo-but-for-bots PR #1124.

**What I did:** Applied panel round-4's must-fix and worthwhile should-fix items to the PR head (commit `f10247fd2`), pushed via `safe-push-pr-head.sh`, and watched CI to green.

**Must-fix items:**
1. **Reachability gap** — the docstrings recommended keying durable per-peer accounting on the session's verified public key over the spoofable `remoteDesignator`, but `SessionLocatorContext` only carried `{ remoteDesignator, abortSession }` and the verified key was reachable only via the `debugMode`-gated `_debug` hatch. Threaded the handshake-verified `peerPublicKey` into the context (both the fresh and resumed session paths in `index.js` already hold it) and updated the JSDoc, README, and formula-nonce-locator comment to name `context.peerPublicKey`.
2. **Abbreviation** — renamed `const ref = {}` → `netlayerHolder` in the endpoint test.

**Should-fix items (same round):** trimmed the changeset to a proper release note (dropping the mechanism proof and the retired `endo-bootstrap` overstatement); dropped the stray unrelated `EndoMountControl` re-export from `types.d.ts`; added tests for the miss-logger-class-only and `missBound`-guard guarantees; renamed `K` → `overshoot`.

**Verification:** daemon nonce-locator (8) + endpoint (7) tests green; `@endo/ocapn` and `@endo/daemon` `lint:types` clean; eslint 0 errors; prettier clean; **CI 28/28 green** (`ci-wait-merge.sh` rc 0). Posted a consolidated fix-round summary comment on the PR.

**Follow-up:** the scribe flagged a garden-side gap (the gauntlet `fix)` stage template never cites `skills/pr-completion-summary-comment/SKILL.md`) — that's a `scripts/jobs/gauntlet.sh` template fix on `main2`, out of scope for this PR job; not owned here.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 164 tokens (6082221 cached reads)
- Output: 30249 tokens
- Cost: $5.769415500000001
- Wall-clock: 1136s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
