I've fixed PR #1575 against the round-6 panel findings. CI is fully green on the new head `0eff2f27a4` (19 passed, 17 skipped), the PR is mergeable and still a draft. I posted a summary comment on the PR (issuecomment-6518034964), and the next panel round should review this head.

The full assessor and breaker write-ups were no longer kept anywhere, so I worked from the shortened versions in the panel-run record. The curator, pruner and releaser findings were complete in the posted review.

**Reservation and budget correctness (`79a26beaf4`)**
- **Concurrency slots:** a reserved turn now holds its slot until it settles. Before, its slot was freed on a wall-clock expiry while the stream could still be running. A stream nobody reads is ended by the endpoint's own request deadline, and a restart settles any reservations left over. That made the `maxWallClockMs` limit, which this PR added, do nothing, so I removed it.
- **Budget kinds:** `validateInferenceLimits` now refuses a record that proposes both a dollar and a token budget. It also refuses a token budget when the deployment ceiling covers only dollars, which used to let a token budget escape the dollar ceiling.
- **Overrun:** usage reported above the reservation is still charged in full and counts against the rest of the day. That makes the daily ceiling best-effort for turns already in flight, not a hard cap. I documented this in the code and changeset rather than changing it.

**Other fixes**
- **`718f470fdb`:** `INFERENCE_PROVIDER_MODEL_PRICES` is checked at startup; a malformed value fails with a clear message instead of a raw `SyntaxError`.
- **`2fc4518f47` (lal):**
  - A stream cut off at `max_tokens` is now reported as truncated (`length`), not as a clean stop.
  - A cancel before the broker responds now closes the response reader when it arrives, so it no longer leaks.
  - The brokered stream can be disposed, and lal's worker loop disposes it on exit.
- **`529203838d` (docs):**
  - The hosted-agent changeset now leads with the breaking migration and gives the remedy, including the call shapes with `confirmed`.
  - The READMEs no longer repeat the default-limits fact or list internal helpers as exports.
  - The adapter's long JSDoc is cut to two lines.
- **PR body:** trimmed to about 220 words of prose plus the evidence ledger.
- **Two `fixup!` commits:** clear `lint:types` errors that CI caught on my first push.

**Checked, no change needed**
- The `minor` bump is right, since `@endo/hosted-agent` is at `0.0.0`.
- Nothing in the repo outside the registry and its tests calls `setLimits`, `setOwnerLimits` or `setGrantLimits`.
- The fae changeset already covers its driver change.

**Declined:** the shared `BrokeredMessagesRecipe` typedef for fae. The curator marked it comment-only, and it would need a new types-only export from lal.

**Verification:** the hosted-agent suite (877 tests), lal (229) and the relevant fae tests (13) pass locally. The new slot test fails when I restore the old wall-clock expiry. One CI test job failed in the bwrap test in `packages/sandbox`, which this PR doesn't touch; memory records bwrap reds as pre-existing, and the job passed on rerun.

**Follow-ups**
- The garden's `pre-push-gates.sh` passed, yet each package's `lint:types` failed in CI. That gap between the local gate and CI is worth its own job.
- The Phase 3 minion.town UI job (`claude-api-p3-minion-ui`) only unblocks once #1575 is merged or closed. A passing panel alone won't start it, so the maintainer needs to merge #1575 or promote that job by hand.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 192 tokens (12830064 cached reads)
- Output: 47317 tokens
- Cost: $4.9255688000000015
- Wall-clock: 6848s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
