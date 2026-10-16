# Gauntlet FIX round 1: kriscendobot/minion.town PR #193

I applied panel-1's must-fix items in one follow-up commit (`21fb3cf`) on `build/ocapn-guest-canary`. CI is **green**: the Actions run passed with 0 failed, and `ci-wait-merge` returned rc 0. The offline suite passes locally, 25/25.

## Fixes in `deploy/probe/ocapn-canary.mjs`
- **BigInt message numbers** (assessor, spec-keeper, engine-realist): `listMessages` now returns message numbers as decimal strings, so `JSON.stringify` no longer throws on them. `adopt` and `dismiss` get the number back as a BigInt literal (`${n}n`).
- **The shared capability** (locksmith, typist, prover): the operator-chosen `share` field is gone. Instead, the sending guest creates a fresh probe whose only method echoes its argument (`Far('OcapnCanaryProbe', { echo })` via `E(guest).evaluate("@main", …, probeName)`). A reference the recipient keeps therefore carries no authority. The exercise step checks that the probe echoes the run's nonce back. I checked this API shape against the Endo daemon source (`guest.js`, `worker.js`).
- **Locator vs. invitation** (integrator): the guests-file field `locator` is renamed `invitation`. The docs now say it is the invitation `endo accept` reads, not the bare formula id from `GET /account/guest-formula-id`.
- **Duplicate guests** (saboteur, breaker, corner-prober): duplicate guest names or invitations are rejected with a new not-provisioned reason, `duplicate-guests`.
- **Redaction** (purist, breaker, corner-prober): secrets are now scrubbed longest-first, so one invitation that is a prefix of another can't leak a suffix. `auditRecord` also scrubs each step's detail.
- **Stalled calls** (saboteur): every CLI call is now limited by a 12-minute run deadline, inside the unit's 15-minute limit, and each poll gets a 60-second deadline. If the run deadline passes, a `run-deadline` step fails the run and the audit record is still written.
- **Cleanup** (wire-watcher, engine-realist): every name and message the canary creates is removed after arrival, on every path, using `try`/`finally`. Plain messages are now dismissed too. A failed cleanup step fails the run.
- **Design citations** (archivist, integrator): sections 4 and 6 now point to `designs/root-canary-reader-identity.md` (on #191). The exit-code contract points to `root-canary-principal.md` §2.6.
- **Naming and comments** (stylist, pruner): abbreviated variable names are spelled out in both files, and comments that only restate the code are removed.

## Other changes
- **Tests** (`ocapn-canary.test.mjs`): the fake Endo CLI now uses bigint message numbers, so a list that isn't converted fails the same way the live one would. New tests cover:
  - duplicate names and duplicate invitations;
  - one invitation that is a prefix of another;
  - scrubbing inside the audit record;
  - which leg fails when creating the probe fails;
  - a failing `remove` cleanup and a failing `dismiss` cleanup;
  - cleanup running after a failed exercise step;
  - a stalled `listMessages` hitting the run deadline.
- **systemd unit** (transplanter's should-fix): the service now runs an explicit `NODE_BIN` and cites the corrected design.
- **PR title and body** (integrator, pruner): the title is now "OCapN guest canary, offline slice". The body is shorter and names a successor job for the remaining work.
- **Successor job:** I parked `minion-town-ocapn-canary-live-run` in `plan/` with a go-ahead gate. It owns the first live run on endolin-garden1, the acceptance evidence, and the guest operated by a Claude session. It needs the maintainer to provision invitations on that host first.

## Not changed
- **Changeset** (releaser): minion.town has no `.changeset/` directory or changeset convention, so I didn't add one.
- **Design `Status` line** (archivist): it lives in the design doc on #191, not in this PR.
- **Live acceptance evidence** (integrator): this needs the live Endo stack on endolin-garden1, so the successor job above owns it.
- **Assumptions still unchecked against a live daemon:** the shape of the `endo eval` output, `endo net ensure ocapn`, and the guest `evaluate` call working over OCapN.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3175483 cached reads)
- Output: 30205 tokens
- Cost: $2.0640925999999995
- Wall-clock: 1492s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
