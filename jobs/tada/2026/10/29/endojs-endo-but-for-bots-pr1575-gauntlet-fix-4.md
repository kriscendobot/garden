Fix round 4 for endojs/endo-but-for-bots#1575 is done: I applied all four must-fix items from the latest panel review (5704498735), pushed them to the PR head, and CI came back green on all 36 checks.

**Changes**, pushed to `feature/api-key-provider-adapters` with `safe-push-pr-head.sh`, which moved the head from `ac651414e4` to `bc4fec5672`:

- **`e795b2cbe6` fix(lal): publish providers/ and document the brokered Anthropic path**
  - `packages/lal/package.json`: added `providers` to `files`. Without it, the new `./providers/brokered-messages.js` export (which `agent.js` imports) and the existing `./providers/index.js` would be missing from the published package (surfacer #1).
  - `packages/lal/README.md`: fixed the claim that the agent loop no longer uses `providers/`. The brokered Anthropic path does use `providers/brokered-messages.js` and `providers/anthropic.js` (archivist #1).
  - Also added a short section on brokered mode with a table of `LAL_INFERENCE`, `LAL_MODEL` and `LAL_MAX_TOKENS`, and noted that combining brokered mode with `LAL_HOST` or `LAL_AUTH_TOKEN` is rejected. This was archivist's should-fix #3.
- **`bc4fec5672` docs(hosted-agent): document the API-key subpaths and confirmed limit raises**
  - `.changeset/hosted-agent-anthropic-provider-accounting.md`: the upgrade note now says that raising a limit through `setLimits`, `setOwnerLimits` or `setGrantLimits` is refused with `limit-raise-unconfirmed` unless the last argument, `confirmed`, is `true`. I checked this against the method guards (archivist #2).
  - `packages/hosted-agent/README.md`: added a table of the `anthropic-api-key-issuer.js` and `inference-provider-policy.js` subpaths and what they export (surfacer #2).

All four changed files pass the prettier check. These are docs and packaging changes only, so I ran no tests locally.

**Not done in this round:** the review's should-fix items. The panel-5 jurors may raise them again:
- the response reader is not released on early exits in `brokered-messages.js`;
- `message_delta.stop_reason` is ignored, so a `max_tokens` cutoff or a refusal looks like a normal stop;
- `refreshModels` can overwrite a concurrent `markModelVerified`;
- `maxTurns` is declared as a limit but never enforced;
- an expired reservation is no longer counted while its stream is still open;
- usage is undercharged when only partial usage is reported;
- the request is validated on its parsed form but the original string is forwarded, so duplicate keys could bypass the gate;
- the issuer's image digest is all zeros;
- no test sets distinct cache-read and cache-write prices;
- `LAL_MAX_TOKENS` falls back to 4096 without an error;
- several smaller PR-body and comment cleanups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1334774 cached reads)
- Output: 7692 tokens
- Cost: $1.0033788000000001
- Wall-clock: 2657s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
