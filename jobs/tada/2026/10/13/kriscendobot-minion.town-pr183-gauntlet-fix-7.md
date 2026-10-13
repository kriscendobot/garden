I applied the panel-7 fixes to kriscendobot/minion.town PR #183 and pushed them; CI is green.

**Commit:** one follow-up commit `78df7d8` on `build/inference-phase3-secrets`, pushed with `safe-push-pr-head.sh` (f8cf901 → 78df7d8). `ci-wait-merge.sh` returned rc 0: all 3 checks passed, after about 12 minutes.

**Fixes by reviewer:**
- **integrator 1:** the comment in `deploy/aws/systemd/minion-mcp.service` now says the token lives in the daemon's `@secrets` store. Only token-free state stays under `/var/lib/minion-town/claude-credentials`.
- **integrator 2:** `credential-vault.ts` is now marked at the top of its file as legacy and only used for migrating old records.
- **integrator 3:** the description format is now one exported function, `credentialDescriptionFor(kind)`, with a `CredentialKind` type. The text written for subscription blobs is unchanged.
- **breaker 1:** the JSDoc in `agents.ts`, the comment in `guest-tools.ts`, `DEPLOYMENT.md` and `prompt-origin-gate.ts` now say the root-authored label is asserted by the root MCP session's `infer` call site, not verified. `DEPLOYMENT.md` names the remaining risk: an LLM driving the root session can forward guest-influenced text, which is then served unsliced.
- **breaker 2:** I took the reviewer's first option and made retries safe to repeat, rather than holding the queue until a timed-out call finishes.
  - If `createBase64` fails and the catalog shows an active blob that a timed-out earlier create left behind, the retry replaces that blob.
  - The comment on the per-subject queue now says plainly that a timed-out call can still land after the next operation starts.
- **breaker 3:** a revoked blob now reads as needs-auth. This holds whether the lookup or the read fails. A genuine daemon fault still raises an error.
- **pruner 1 and 2:** the module docs for the gate and the vault are condensed to what each module does and its invariants.
- **purist 2:** the hand-rolled base64 conversion is replaced with `encodeBase64`/`decodeBase64` from `@endo/base64`.
- **purist 3:** the gate's module doc now says it is the minimum adapter for `makePromptOriginGate`, not a fork, and why the upstream gate can't wrap this surface.

**Not fixed — purist 1 (`@endo/sha256`):** the package isn't on npm or on npm.minion.town (I checked both), so I couldn't switch to it. I kept the `node:crypto` exemption, reworded it with the real reason, and messaged the maintainer to ask whether to publish `@endo/sha256` there; the message says it doesn't block anything. The next panel may raise this again.

**Not addressed:** breaker 4 (refused inbox messages being retried after a restart) and the integrator's history-regrouping note. Both were marked comment-only.

**Tests:**
- I added two tests to `test/claude-secrets-credential-vault.test.ts`: one for a revoked blob reading as needs-auth, one for a create colliding with an earlier timed-out create. The fake secret store now refuses to read a revoked blob.
- Typecheck is clean.
- The full local `npm test` had one failure out of 1,084: `test/git-remote/capability.test.ts` ("propagates a git failure…"). It's in an area this commit doesn't touch, and I didn't check whether it also fails without my changes.

**Follow-ups:** decide on `@endo/sha256`. Panel-8 comes next; the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2167289 cached reads)
- Output: 15969 tokens
- Cost: $1.4113578000000004
- Wall-clock: 1038s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
