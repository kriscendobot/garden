PR head is now my commit `a8b4842bb` and CI has re-triggered (queued). Inbox empty. My work for this stage is complete.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr1170-stabilize-ci-20260906` — stabilize PR #1170's reproducible cold-CI failures (stage 1 of the serial orchestration `endojs-endo-but-for-bots-pr1170-ci-disposition`).

**Diagnosis.** The reproducible failures were confined to `packages/space-nixos-admin/test/deploy-performer.test.js` — a package that consumes **no moved dependency** from PR #1170. They are wall-clock timing failures exposed by the grouped 21-package lockfile bump producing a cold, oversized affected set that saturated the runners, dilating each nominal ~10ms poll to hundreds of ms. Two shapes, both environmental:

1. **`a watch inherits the wait deadline`** bounded *total* elapsed at 1.3× the 1s cap; under load the **pre-free wait** alone dilated to ~2.24–2.85× (2240ms/2848ms observed on 22.x/24.x), so the bound failed even though the inherit logic was correct.
2. **The other four failures** (`foreign operation in flight…`, `id-less status appearing mid-watch…`, `empty-string status id…`, `id-less NONTERMINAL status holds the slot`) all timed out because the harness's default 5s watch cap is wall-clock while the id-less grace / test sampling loops are **poll-counted**; under load 30 dilated polls ran past the 5s cap, turning the actionable grace/liveness message into a spurious `saw no outcome within the watch limit`. Failure count scaled with load (2 on 22.x, 5 on 24.x), the classic signature. The `flock: No such file or directory` error was teardown-cascade collateral from the primary timeouts.

**Fix (test-only, no dependency/lockfile changes):**
- Raised the harness default `watchLimitMs` 5s → 60s, restoring the prod-like separation (production cap is a day) so the poll-counted grace always expires far inside the cap even under load. Cap-reaching tests pass their own small `watchLimitMs` and are unaffected — verified only the inherit test overrides it.
- Reworked the inherit test to measure the watch window **from the moment the slot is freed** (the actual quantity under test) rather than total elapsed, with a 0.5× bound. This excludes the dilated pre-free wait entirely.

**Verification:** all 54 `deploy-performer` tests pass locally; the inherit fix **still fails** when the deadline-restart regression is reintroduced (watched 2017ms vs 1000ms bound), confirming preserved regression-detection; eslint and tsc clean. Committed with explicit pathspec and pushed to the PR head via `--force-with-lease` CAS (`4b1fd8620..a8b4842bb`); CI re-triggered on the new head.

**Not fixed — external/environmental, documented for the next stage (re-run items, not PR-attributable):**
- **Guile interop** (`ftpmirror.gnu.org` HTTP 502 across all 6 retries fetching Guix): a sustained GNU-mirror outage. The workflow is already best-practice hardened (cache + `nick-fields/retry` ×6 + `ftpmirror.gnu.org` mirror redirect) with a *deliberate documented decision* to decouple from `ci.guix.gnu.org`; no responsible code change exists — it clears on re-run once GNU's mirror recovers.
- **macOS `codex-sandbox/codex-client`** intermittent stall: consumes no moved dependency, passed on the latest attempt — a re-run item.

**Follow-up for the orchestration's next stage:** watch the fresh CI run; if Guile still 502s or macOS stalls, re-run those individual jobs (external transients) rather than touching the diff.

The reproducible failures this stage owned were responsibly repaired and pushed, so the campaign should advance — no orchestration-failure signal.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1170-stabilize-ci-20260906.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3428360 cached reads)
- Output: 37104 tokens
- Cost: $3.6765980000000003
- Wall-clock: 588s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
