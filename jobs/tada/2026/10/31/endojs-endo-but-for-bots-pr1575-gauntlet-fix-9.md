I applied panel round 9's must-fix items (review 5720208726) to endojs/endo-but-for-bots#1575 and pushed them; CI is green (36/36).

**What changed** — three follow-up commits on `feature/api-key-provider-adapters`, head now `39526e2781`:
- **`7d8ab2af3f` — Lal brokered adapter:**
  - The pi stream now converts the pi-ai context straight to an Anthropic Messages request and builds pi-ai content straight from the stream events. The old detour through the OpenAI-style message shape, with its `JSON.stringify`/`JSON.parse` round trip, is gone.
  - One shared transport core serves both the pi stream and the `chat`/`chatStream` surface.
  - The decomplector asked to drop `chat`/`chatStream`, saying nothing used them. That was wrong: Fae's `provider-owner.js` calls them, so they stay.
  - Stop reasons are now checked against a fixed list. A refusal, a missing or unknown reason, or `tool_use` with no tool call is now an error.
  - The recipe check now requires `model` to be a string.
  - Each response reader now has a single owner.
  - `spawnWorkerLoop` picks one of two helpers, `makeBrokeredModel` or `makeDirectModel`, instead of checking the brokered flag throughout.
- **`67774cc95c` — hosted-agent:**
  - Compaction now keeps every turn it can't prove is settled and outside both windows, so a backward clock step no longer drops a live reservation. A test covers this case.
  - The Anthropic issuer's all-zero image digest now has a comment saying it is a deliberate placeholder: this issuer has no target image, and nothing it hands out reports the digest.
- **`39526e2781` — docs (pruner, releaser):**
  - The new issuer export has its own changeset, and the price-record format moved to the hosted-agent README.
  - Two comments that just restated the code are trimmed.
  - The PR body is shorter.

**Checks:** Lal's full suite passes (232 passed, 1 skipped), as do the changed hosted-agent tests (38) and Fae tests (13). ESLint shows no errors (remaining warnings were already there), and the repo-root type check reports nothing for the changed packages. I posted a summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1575#issuecomment-6537305314

**Not done (comment-only or should-fix items):**
- Changing the request-header denylist to an allowlist.
- `bigint` money math in `priceUsageMicros`.
- Fully replacing the cancellation promise-kit with an `AbortController`; I simplified it but kept it.

The first CI wait was killed at its background time limit, so I restarted it with the remaining deadline; the second run reported green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (6703168 cached reads)
- Output: 34296 tokens
- Cost: $3.1758496000000007
- Wall-clock: 2846s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
