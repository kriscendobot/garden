## Gauntlet FIX round 1: kriscendobot/minion.town#220

I applied the must-fix items from panel review 5642347528 (14 jurors). The fixes are pushed to `split/pr216-account-deletion` (head `539835bf` → `aee8ea91`, fast-forward) and CI is green: `ci-wait-merge` returned rc=0, with 7 of 7 checks passing, including the real-daemon `guest-web-daemon` suite.

**Commits pushed (8):**
- `18fbd266` **(breaker):** the DynamoDB store now refuses a bond row whose `bonded_iss`/`bonded_sub` don't hash to the row's own sort key. Before this, such a row could unbond the wrong account. New test cases cover it.
- `f5fb992f` **(wire-watcher, fast-checker):** the name rules for browser-guest handles are now exact: `web-<lowercase uuid>` or `coupon-<32 hex>`. The same rule is in `root-host-socket.ts`, the `deploy-app.sh` gate, and DEPLOYMENT.md. Names like `web-1` are now rejected. The gate has a 50-run fast-check property, and I confirmed the box's awk (Ubuntu 24.04, mawk 1.3.4) handles the `{n}` patterns.
- `c3769306` **(locksmith, breaker, engine-realist, prover):**
  - The directory now returns a locked-down guest object with only eight methods, never the raw daemon guest. A test shows `evaluate`, `storeValue` and similar are unreachable.
  - Deletion now cancels the handles, looks the guest up again, empties it and checks it reads back empty before cancelling the agent. If a peer keeps refilling it, the deletion stays pending.
  - `inspect` rechecks after its reads that the guest wasn't deleted meanwhile.
  - I removed two tests that already passed before this PR and replaced the third with a concurrent-connection case the old code fails.
  - The new delivery-race and inspect-race tests fail when their fix is removed.
- `15ea167b` **(corner-prober, pruner):** the CLI pet name is now quoted correctly for POSIX shells and PowerShell. Hostile names are round-tripped through `sh` under fast-check. I dropped the `settings-types.d.ts` comments that only restated names.
- `c64bd08a` **(corner-prober):** new tests check that the in-memory and DynamoDB account-store facets each expose only their own methods and share the same bond state.
- `f010415d` **(packager, changeset-auditor, migrator, integrator, benchmarker):**
  - The changeset is one sentence per line. It now describes Log out and marks the `GET /api/guest` credential narrowing as Breaking, with the audit to run.
  - The old "Forget this browser" wording is replaced in the onboarding design, `invitation-session.ts` and its test.
  - The open-signup design now says why rebind cost is not benchmarked.
- `aee8ea91`: the IAM test's fixture row now uses its real sort key, which the new check requires.

**Also changed on the PR:** for the integrator finding, I edited the title and body to say the PR carries #219's commit `2e563013`. If #219 merges first, this PR gets rebased onto it; otherwise #219 should be closed as subsumed. I posted a comment on the PR giving the outcome for every finding.

**Declined, with reasons given in that comment:**
- **migrator (`major`):** this is a private 0.1.0 app, where a breaking change is a `minor` bump, and `major` would publish 1.0.0. The breaking change and its migration are now in the changeset.
- **purist (`@endo/sha256`):** nothing is hand-rolled. The code uses Node's own SHA-256 under the same exemption five other modules already use. Switching the whole repo is a separate decision.
- **transplanter (hard-coded deploy paths and `WEB_SIGN_OUT_PATH`):** these follow the existing single-deployment convention. `endo-daemon.service` and `minion-mcp.service` hard-code the same paths and values.

**Follow-ups:**
- #219 needs a decision from the maintainer: merge it first, or close it once this PR merges.
- One local test failure, `test/git-remote/capability.test.ts` ("propagates a git failure"), is in files this PR doesn't touch, and it passes in CI. It looks specific to this host's git setup.
- The first CI-wait process ran past its background time limit and was stopped. I re-ran the wait in the foreground, and that is where rc=0 comes from.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr220-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (9428950 cached reads)
- Output: 51443 tokens
- Cost: $4.298162
- Wall-clock: 2372s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
