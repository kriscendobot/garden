I applied panel round 3's must-fix items to [PR #240](https://github.com/kriscendobot/minion.town/pull/240), except the decomplector's two removal requests and the part of the breaker's fix that doesn't hold (both below). The push moved the head from `e5948d7b` to `9e5669e0` with no rewrite, and CI is green there (`ci-wait-merge` rc 0). The PR is still a draft, and I didn't re-run the panel.

**Commits**
- `fd108ce4`: docs, one changeset and the coupon design note.
- `9e5669e0`: code and test fixes.

**Must-fix items applied**
- **Credential counting (assessor, spec-keeper):** `home.js` now counts credential keys by presence, so `#v=1&invitation=&locator=<valid>` is refused. The shared fixture table has new empty-value cases.
- **Wrong-case secret keys (saboteur):** `fragmentHoldsSecret` matches key names case-insensitively, so `#v=1&Locator=…` is scrubbed from the address bar. Parsing stays strict.
- **Malformed origin (typist):** `parseCapabilityUrl` returns `invalid-origin` instead of throwing.
- **Memory backend (typist):** `acceptLocal` now refuses another daemon's locator, using the same `namesNode` check as the socket backend. Tests name the new `MEMORY_LOCATOR_NODE`.
- **Coupon links (archivist):** `designs/guest-coupons.md` marks them as not implemented, and says both parsers must add the key first.
- **Changesets (curator, changeset-auditor, others):** there is now one minor changeset, with one sentence per line and no internal `evaluate` expression.
- **Round-trip test (fast-checker):** added a 200-run property covering format, parse and `toEndoLocator`.
- **Duplicate builder (decomplector #1, part):** the invitation branch of `formatCapabilityUrl` now uses `buildInvitationFragment`.

**Must-fix items not fully applied**
- **Decomplector #1 and #2 (remove `formatCapabilityUrl`'s locator arm and the https parse path):** declined. The maintainer's 2026-11-04 direction asks for a round trip with `endo://` and for `endo://` parsing to keep working during the transition, and fast-checker's must-fix tests exactly that path. Fix round 2 made the same call. This may come up again in panel 4.
- **Breaker (rewritten foreign locator):** partly applied, because the stated failure doesn't hold at the pinned Endo commit `1706e632`.
  - `acceptInvitation` only registers peer hints and writes the agent key when `peerKey !== localNodeNumber`, so a locator rewritten to name the local node writes neither.
  - I still strip hints before the daemon sees the locator, so the claim that foreign hints never reach it holds outright, and added a test.
  - I did not validate `fromNode`. The guest has no capability to check it, and the daemon's check above already covers the write.

**Should-fix and summary-fix items also done**
- Plain `http` is accepted only on loopback.
- Added ASCII spellings and the identifier renames.
- Trimmed the module and test header comments, and the PR body.
- Added a differential property between the two locator predicates, and length tests at 4095, 4096 and 4097.
- Added a real-daemon test of two guests racing one locator.
- Added a workflow comment saying the Caddy tarball needs a Linux x64 runner. I inferred that from CI passing with the amd64 tarball; I didn't confirm the runner's architecture directly.

**Left open (all should-fix)**
- Purist: `/adopt` as a separate typed action, and consolidating the locator grammar around Endo's parser.
- Decomplector #3: confirmation that the 2026-11-04 direction overrides the #1484 review. The PR body cites the direction, but it isn't linked to a durable record.
- Decomplector #4: `/` still takes a locator fragment as well as `/accept`.

**Tests**
- **Local:** `tsc` is clean and the affected suites passed (236 passed, 8 skipped). The skipped tests need `ENDO_CHECKOUT` and didn't run on this host. I didn't run the full suite locally.
- **CI at `9e5669e0`:** both workflow runs succeeded, including the `Test (vitest)` step and the browser test behind Caddy.
- **Not confirmed:** the job log came back empty, so I can't show that the new race test ran rather than skipped. That step does set up the pinned Endo checkout.
- **Visibility limit:** the token can't read the status rollup, so `ci-wait-merge` used the Actions runs API and non-Actions checks aren't visible.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2504088 cached reads)
- Output: 30394 tokens
- Cost: $2.1895376000000004
- Wall-clock: 789s

<!-- garden-usage-end -->
