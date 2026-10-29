Fix round 5 for PR #1575 is done: all seven must-fix items from the latest panel review (5705086755) are applied and pushed, and CI is green (36 checks, 0 failed). There was no pre-pass block for this round, so I worked from that review.

**Head:** `bc4fec5672` → `7814d2c452`, two follow-up commits, pushed with `safe-push-pr-head.sh`.

**What changed**
1. **wire-watcher (validated body vs. forwarded body):** the registry used to check a parse of the request body but forward the caller's original string. Now `validateAnthropicInferenceRequest` re-serializes the validated body and returns it as `checked.message`. Both `request` and `requestByteStream` forward that, so a repeated key can no longer mean one thing to the registry and another upstream. The input byte count and size check now use the forwarded body. New test: a body with repeated `model`/`max_tokens` keys forwards only the validated values.
2. **breaker (limits that were never enforced):** I removed `maxTurns` and `maxResponseBytes` from the limit fields and the defaults, since nothing enforced them. New test: both are now refused as invalid limit fields.
3. **curator (bump level, incomplete changeset) and migrator (upgrade note):** I rewrote the hosted-agent changeset. It now covers:
   - `INFERENCE_PATHS` gaining `/v1/messages/count_tokens`;
   - the new `discoverModels` and `modelPrices` inputs and the `INFERENCE_PROVIDER_MODEL_PRICES` variable;
   - `@endo/base64` and `@endo/utf8` becoming runtime dependencies;
   - why the bump stays `minor`: the package is pre-1.0 (`0.0.0`) and the registry is experimental;
   - the default limits applying to existing providers, owners and grants after upgrade;
   - the stricter request policy: a bare `{}` body is now refused with `inference-request-refused`, and the registry forwards its own serialization;
   - unpriced models needing a `dailyTokens` budget, and the `model-not-available` error.
4. **archivist:** the `LAL_MAX_TOKENS` row in `LAL-ARCHITECTURE.md` now names the brokered Anthropic path (`LAL_INFERENCE`) as well as llama.cpp.
5. **decomplector:** I added one sentence to the `brokered-messages.js` header and the PR body explaining why it is a sibling of `subscription-responses` rather than a mode of it: both consume an `InferenceEndpoint`, but they speak different request and event formats.

**Checks**
- **Local:** the hosted-agent registry and issuer tests pass (31), the Lal brokered-messages tests pass (28), eslint shows no errors, and prettier and `lint:types` are clean.
- **Daemon restart test, local only:** `inference-provider-registry-restart.test.js` failed locally because the daemon couldn't load the native `better-sqlite3` module under this machine's Node version. It is a local environment problem, not this change, and the CI test jobs that run it passed.
- **CI:** the first run had two red jobs, `cover (22.x)` and `sandbox-drivers`. Both were the same `packages/sandbox` bwrap test ("process group survived bounded cleanup"). This PR doesn't touch `packages/sandbox` and the previous head was green, so I treated it as a known flake (fix pending in open PR #1566) and reran the failed jobs once. The rerun went green and `ci-wait-merge` returned rc 0.
- An earlier backgrounded `ci-wait-merge` call hit its time limit and was stopped. I replaced it with a foreground wait, which gave the final result.

**Follow-ups:** none blocking. The panel's should-fix items were not addressed this round; panel-6 can re-raise them. They cover:
- charging failed upstream responses as released rather than estimated;
- reading `stop_reason`;
- cancelling the response reader on early exits;
- the gap in the owner's dollar cap for unpriced models;
- server-side tool types;
- the all-zero `ISSUER_IMAGE_DIGEST` placeholder;
- documentation and README trims.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3222922 cached reads)
- Output: 15080 tokens
- Cost: $1.6816323999999996
- Wall-clock: 3209s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
