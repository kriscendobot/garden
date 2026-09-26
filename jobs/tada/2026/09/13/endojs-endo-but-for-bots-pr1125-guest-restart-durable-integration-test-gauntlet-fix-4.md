CI is GREEN — all 34 checks passed, 0 failures. The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1125 (guest-owned invitation primitive).

**What I did:** Read the panel-4 request-changes verdict (10 blocking seats), applied the actionable items as one review-feedback follow-up commit (`12b9bbb58`) to the PR head `bot/build/endo-guest-invite-primitive`, pushed via `safe-push-pr-head.sh`, and watched CI to terminal — **GREEN (34/34 checks, 0 failures)**.

**Changes applied (10 daemon files):**
- **stylist** — renamed `formulateReadOnlyDirectory` → `formulateReadableDirectory` (matches its `readable-directory` type + `formulateReadableBlob`/`Tree` siblings); reconciled `normalizeHostOrGuestOptions`'s `@param` doc with its shared name.
- **purist** — documented why `MailHub`/`MessageHub` `readOnly()` return the already-read-only hub, and the deliberate server-side attenuation-unwrap in `getAllNetworkAddresses`.
- **breaker / wire-watcher** — narrowed the `accept()` "restart-durable" claim to no-double-consume (spelling out the crash-mid-fallible-work retry window); qualified `EndoGuest.invite`'s "no network authority" → no dialing/peer authority; noted `Invitation.cancel` is a bare bearer capability.
- **wire-watcher / corner-prober / saboteur** — added concurrent `cancel()`-vs-`accept()` and `cancel()`-after-`accept()` idempotency tests (verified passing locally).
- **engine-realist / benchmarker** — documented the per-delivery `reincarnateMailboxPins` rationale in-code (declined the once-per-restart gate — it would break the tested mid-life worker-cancel resurrection).
- **orthographer / typist** — British→American spellings, `ExecutionContext` `@import` alias, U+2192→ASCII arrow.
- **integrator** — refolded the PR description onto the upstream template (Security/Scaling/Documentation/Testing/Compatibility/Upgrade Considerations).

**Declined (with rationale, posted to the PR):** the duality-auditor `GuestFormula.hostAgent`/`hostHandle` persisted-field rename (cuts against the maintainer's "don't reshape existing formulas" convention; the field genuinely means "owning host" and is overloaded only in a narrow legacy path); and memoizing `formulateReadableDirectory` per `directoryId` (comment-only follow-up, out of scope).

**Local verification:** `lint:types`, `lint:eslint`, `prettier --check` clean; touched daemon tests pass (the long CI-worktree `endo.sock` path is a known env limit, confirmed non-regression via a short-sock rerun). CI confirmed all green.

**Follow-ups:** the two declined items remain open for a future round if the maintainer wants them; the driver will re-post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 226 tokens (13818563 cached reads)
- Output: 57702 tokens
- Cost: $10.0665155
- Wall-clock: 2562s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
