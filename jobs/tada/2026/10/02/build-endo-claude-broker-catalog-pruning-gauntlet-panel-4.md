I ran panel round 4 on PR #1409 and the result is **must-fix**. I posted the verdict as review 5387803024 at 2026-10-02T02:40:25Z. I did not fix anything or take the PR out of draft.

**How the run went:**
- Single-round `panel.sh` ran against the PR head `2740469337` (branch `bot/build/claude-broker-catalog-pruning`) vs base `llm-d4124e6`, in an isolated checkout.
- It exited with code 0, and all 33 seats returned a verdict: 3 request changes, 6 comment only, 24 approve. The purist seat timed out once (1200s) and succeeded on its retry.
- The full record is at `panel-runs/endojs-endo-but-for-bots-1409/5e46942fc37b.md`.

**The review:** It is a COMMENT review because GitHub won't let the PR author request changes. The body starts with the `garden-panel-verdict: must-fix` and `garden-panel-round` markers. Seats with findings appear in full; the approving seats' text is cut so the review fits under GitHub's size limit.

**Must-fix findings for the next fix round:**
1. **locksmith:** the confined tool allow-list (`confinedToolNames`) still serves `loadContent`. A guest can give it an address for content (a `ws=` hint in a magnet link), and the daemon will then fetch from any http(s) address the guest names. That lets a confined guest reach internal services or cloud metadata endpoints (SSRF). The fix is to withhold `loadContent` until the content fetcher only allows approved destinations, or to have the design doc accept this explicitly. Either way, the `confined.js` comment and the README should mention the network fetch.
2. **corner-prober:** the README says a caller can use `allowedToolNames` to add back a withheld tool, but no test covers that, for example passing `['evaluate']`. Separately, the tests only check that 3 of the 13 withheld tool names are refused when called.
3. **scribe:** the PR has no top-level summary comment covering fix rounds 1–3.

**Comment-only notes:**
- **migrator:** add an `@endo/claude` changeset entry, since that package's confined tools shrink. This seat also saw the broker allow-list test fail once in four local runs.
- **purist:** harden the array `selectConfinedTools` returns.
- **surfacer:** mark the withheld naming and locator tools in the README the same way the evaluation tools are marked.
- **pruner:** cut each "does not apply" section of the PR body to one sentence.
- **fast-checker:** add property tests for `selectConfinedTools` keeping order and giving the same result when applied twice.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (917471 cached reads)
- Output: 5235 tokens
- Cost: $0.8161942
- Wall-clock: 2200s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
