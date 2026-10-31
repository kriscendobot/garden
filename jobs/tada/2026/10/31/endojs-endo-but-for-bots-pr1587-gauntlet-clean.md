Clean stage for endojs/endo-but-for-bots PR #1587: the coverage pass is pushed, but CI is not finished. One check, `test (24.x, macos-15)`, has been queued (never started) for about an hour at the new head `92b582ecaa`. The other 34 checks pass or were skipped and none failed, so this is still-pending rather than red.

**Coverage pass** (package `@endo/hosted-agent`). I added one commit to `feature/provider-registry-oauth` (`e83e4306d` → `92b582eca`), pushed with `safe-push-pr-head.sh`:
- **`test/inference-provider-registry-module.test.js`:** a new test that runs the module's `make()` against fake powers. It checks two things:
  - An api-key provider is passed to the issuer factory with `authMode: 'api-key'` and `defaultModel`.
  - An OAuth provider (`claude-subscription`) is refused before the issuer factory is ever looked up, and its catalog comes back `unavailable`.
  
  This module path had no tests before. I disabled the OAuth check temporarily and confirmed the new test then fails, so it does test the gate.
- **`test/inference-provider-registry.test.js`:**
  - Two branches of `assertInferenceProviderOAuthAvailable` that weren't tested: an unknown provider, and a provider whose kind doesn't match.
  - Four registry rejection cases:
    - an OAuth provider of the wrong kind (`chatgpt-subscription` on an anthropic provider) → `invalid-oauth-provider`
    - an empty `accountRef` → `invalid-account-ref`
    - an `accountRef` containing a newline → `invalid-account-ref`
    - an `accountRef` on an api-key provider → `invalid-account-ref`
- The touched test files (32 tests) pass locally, and eslint and prettier are clean. I did not run `tsc`.

**Dead code:** the change leaves nothing orphaned. The only leftover is a second, redundant `harden(INFERENCE_PROVIDER_OAUTH_MODES)` in `inference-provider-auth.js`. It does no harm, so I left it.

**CI:** I ran six bounded `ci-wait-merge.sh` waits of about 570s each, and every one ended with rc=4 (still pending). I stopped there to stay inside the handler deadline. The driver should re-post this stage on a fresh budget. If the macOS runner queue stays stuck, someone will need to look at the runners.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1587-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1869266 cached reads)
- Output: 10622 tokens
- Cost: $1.1428851999999998
- Wall-clock: 5051s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
