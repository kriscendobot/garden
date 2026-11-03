**FIX round 2 is done for kriscendobot/minion.town#229: the must-fix items are pushed and CI is green.** I pushed `36896397`, `3e8d0a1f` and `736fb61c` to `feat/claude-api-provider-ui` as follow-up commits. `ci-wait-merge.sh` returned rc 0 with 2 of 2 Actions runs passing at `736fb61c`. The bot's token can't read the status rollup, so commit statuses and non-Actions checks weren't visible.

## Must-fix items applied
- **False 503 on create and replace:** I removed the `delete` on the request CapTP had frozen, along with the key-zeroing steps that didn't really erase the key.
- **Hardened-path test:** new `test/inference-provider-service.test.ts` runs the real endpoint and adapter under lockdown over a CapTP loopback, with guards copied from endojs/endo-but-for-bots#1575. It also covers daemon restart, connection close, boot outage and refusal passthrough.
- **Registry contract:** method names, `reattach`, `assertUpstreamRevoked()`, the operation `status` field and `upstreamRevocationAssertedAt` now match #1575.
- **Limit fields (the panel missed this):** the daemon uses `concurrentTurns`, positive values and exactly one daily budget. The old `concurrency` field would have made every create fail with `invalid-limits`.
- **Daemon outages:** the adapter connects on first use and retries once on a fresh session, so an outage or restart gives a per-request 503 and no longer stops the app.
- **Limits and ids:** blank, empty, zero or fractional limits are refused on both server and UI. Ids are validated and required on every route, so there is no more `String(... ?? randomUUID())`.
- **Smaller items:**
  - The bare catch now logs.
  - Resume sends a pending replacement through `/replace`.
  - `/enabled` is replaced by a `HEAD /account/providers` that provisions nothing.
  - The Caddy matcher tests, deploy probe and landing-module docs are added.
  - The PR body, ledger and rollout-gate statements are refreshed.

## Should-fix items also applied
- Bound per-owner facets
- Confirmation before raising caps on replace, with uneditable caps carried over
- `reattachFailed` reported on a partial replace
- Unknown-outcome handling for non-JSON responses
- Removal of inert step 2 controls and `discoverModels`
- Docs cut to one statement of the rollout gate
- Browser-gate workflow paths
- `src/http.ts` reset to the base plus the provider wiring, dropping the reformatting noise

## Decisions to check
These three are also in the PR body.
1. **Owner key differs from the design:** the design says `ownerId` is the guest formula id, but that id is 129 characters and the registry's pattern allows 128. I used the `guestNameForIdentity` hash of iss+sub, which also meets the locksmith finding. Phase 4 must use the same key, or the design or registry must change.
2. **Re-entering a key after a reload is only partly fixed:** operation records carry no limits, so custom caps get `idempotency-conflict` and the page tells the owner to cancel and start again. The caps can't silently change, but replaying them needs #1575 to expose `request.limits` in `summarizeOperation`. I did not post that follow-up.
3. **Attached agents are empty for now:** registry summaries don't report them yet, so the page lists none and `remainingAgents` is `null`. The page then tells the owner to check for agents still on the old key before disabling it.

## Not done
- **`deploy-app.sh`:** it has no forged-subject check for the provider route, because the flag-off app answers 404.
- **History:** not rewritten, so the earlier `root-host-socket.ts` add-and-remove churn remains.
- **Shared gate helper:** the `equalSecret` and gate-logic duplication is still there (comment-only finding).
- **UI gaps:** there is no control for switching budget kind, and no per-agent usage for the previous period.

## Testing
- **Passed locally:** `tsc` and 7 provider and neighboring test files (119 passed, 4 skipped). Chromium ran; the skips are the Firefox and WebKit cases, which can't launch on this host.
- **Timed out locally:** the full suite hit my 560s limit, so it has no local result.
- **Not covered:** none of this has run against a live daemon.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (3031715 cached reads)
- Output: 77242 tokens
- Cost: $3.919191
- Wall-clock: 1768s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
