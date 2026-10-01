I'm about two hours into a 7200s handler budget, and CI on the new head (`fb2bb0ae06`) has only just started. CI hasn't reached a final result I can wait for, so I'm reporting still-pending now.

orchestration-note: CI is still running at the new head, so this is not a failure verdict.

## Clean stage for endojs/endo-but-for-bots#1404: CI still pending

CI is still running on the current head (`fb2bb0ae06`), so this stage isn't done. That head includes my fixes plus the follow-up fixer job's commits on top. My last pushed head (`5e063d1cbd`) never got a final CI result before the follow-up push replaced it.

### What was wrong
CI at the original head `afdc57da1b` failed on all 4 test legs, and the failures came from the PR itself.
- **Main cause:** the `least-authority` (`@none`) powers in `packages/daemon/src/manager.js` still listed 14 guest methods the PR removed (`identify`, `locate`, `storeIdentifier`, `lookupById`, `invite`, `accept`, `deliver`, …). The interface guard rejected them, so every `@none`-powered caplet failed to start.
  - That broke `@endo/host-shell` (kill, stdin round-trip, cancel), the cli `counter-example` demo (`endo make` defaults to `@none`), and the daemon's move-hub tests.
- **Tests not updated:** several tests still read identifiers or locators from guests:
  - agentry `code-mode-provision-host` (its test double had no `copy`)
  - daemon `endo.test.js`: pins directory, introduced names, the pinned guest responder from #1125, and rehydrated requests
  - the `auto-responder-agent` fixture
  - daemon `code-mode-provisioning-{credentials,lifecycle}`
- **cli:** `endo inbox --as <guest>` called `locate('@self')` and `reverseLocate` on the guest. That broke the `sending-messages`, `names-in-transit` and `mailboxes-are-symmetric` demos.

### What I pushed (with `safe-push-pr-head.sh`, adding commits only)
1. `da31cdc6c0` fix(daemon): removed the 14 methods from the `@none` stub, and updated the endo/auto-responder/agentry tests to bind or read through the host (host-side `storeIdentifier`/`identify` with a path, and `fromNames` instead of locators).
2. `8b50cdc552` test(daemon): added an `identifyInGuest` helper to the code-mode provisioning fixture; it reads guest identifiers by traversing from the host into the guest agent.
3. `5e063d1cbd` fix(cli): `inbox` names a guest's correspondents from `fromNames`/`toNames` and keeps the locator path for hosts.

### Local test results
- **Pass:**
  - host-shell formula: 9/9
  - agentry code-mode-provision-host
  - daemon `endo.test.js`: all pass except one mount test, which only collided with a tmp dir left by a run I killed
  - daemon code-mode-provisioning: all files
  - channel, channel-relay, ws-relay, content-store-gc, error-trace and gateway (run from a short-path checkout to get under the unix socket-path length limit)
  - fae (155), floot (195), chat (896)
- **Fail, from this machine's environment rather than the PR:** daemon git tests (host git `rerere` replays an old resolution), daemon shell tests (`/tmp` is noexec, EACCES), and agentry `mid-rebase` (also `rerere`).
- **Not run locally:** the cli demo and `@endo/sandbox`, because the sandbox blocks running their `endo`/`ses-ava` bins. I couldn't confirm the inbox fix locally; CI is the only check on it.
- **Coverage and dead code:** lint on all touched files has 0 errors. No orphaned dead code in the PR's files. The `@none` failure is already caught by the existing daemon test `move renames value, for a single caplet name hub`, so I didn't add a new test.

### Follow-up
I found production code in fae, floot and lal that still calls the removed guest methods, which no test covers. I posted job **`ebfb-1404-guest-consumers-identifiers`** (fixer) for it. It has already pushed `19d61f0bbe` (floot), `e463c67663` (fae) and `fb2bb0ae06` (lal), which is the head CI is now running on.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 262 tokens (18213296 cached reads)
- Output: 45859 tokens
- Cost: $6.143343199999999
- Wall-clock: 7005s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
