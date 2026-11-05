**Fix round 6 on PR #240: most panel must-fix items are applied, but I declined or only partly applied five. CI is green at `b3cb938a`** (`ci-wait-merge` rc 0). The CI logs show the live-daemon and real-browser/Caddy suites ran and passed. The PR is still a draft.

My first push (`1f680de2`) went red because my new guest-link cases made the Caddy access-log counts wrong. I corrected them in `b3cb938a`, so this round has two pushes instead of one.

**Must-fix items applied**
- **Locator length (assessor, saboteur, breaker):** `home.js` now enforces the 4096-character limit, and a test checks both parsers at 4095, 4096 and 4097 characters.
- **Accept faults (breaker, wire-watcher 2):**
  - `acceptLocal` now separates a refusal from a fault by whether the connection closed, using the bridge's existing close check, moved to `src/endo/closes-within-grace.ts`.
  - A refusal answers 404 and a lost connection answers 503, even if the daemon is reachable again. The daemon's error text, which names the locator, is dropped in both cases.
  - A retry with the same link and name now succeeds if the lost attempt had already committed. This needed a new `locate` method on the guest facet. Fault tests cover it, and CI checks a same-name repeat accept against a real daemon.
- **Guest credentials on action paths (corner-prober):** a `guest` fragment on `/accept` or `/adopt` is now malformed and is scrubbed, with browser cases for both.
- **Changeset (packager):** it now says the locator must be percent-encoded.
- **Property test (fast-checker):** added the invitation round trip.
- **PR body (benchmarker):** added an explicit statement that no benchmark is being pursued for the cached node lookup.

**Should-fix and unlabelled items applied**
- **Fast-checker:** added a property test that the two parsers accept the same fragments.
- **Orthographer:** changed `cancelled` to `canceled` in the cited lines.
- **Stylist:** made both renames.
- **Purist (part):** `namesNode` now requires the `endo:` scheme.
- **Pruner:** removed the narrating comments, but kept three test comments that explain why rather than what.
- **Integrator:** the design and envelope comment now describe the POST redemption route, and I refreshed the PR title and body.

**Must-fix items declined or partly applied**
- **Spec-keeper (mixed-case scheme), declined:** the finding is wrong for this pin. The pinned daemon's `parseLocator` requires a literal lowercase `endo://`, so accepting `ENDO://` here would disagree with the daemon.
- **Wire-watcher 1 (inviter's name), partly applied:** when a deletion overtakes a raw-locator accept, the inviter's name is still not released. The web tier has no reference to whoever minted the locator, and finding them would mean untested root-level lookups. The route now logs a warning, and the design and PR body state the limit.
- **Integrator (#1484 conflict), partly applied:** the PR body now states the conflict and explains compatibility, but I found no durable record of the 2026-11-04 direction, so it can't link one. It says so and asks to stay in draft until the maintainer confirms.
- **Curator (`/adopt`), declined:** `/adopt` was in the build brief, so I kept it. Whether it stays is now a question for the maintainer.
- **Decomplector (remove raw-locator accept), declined:** removing it would delete most of this PR and of #239, and that decision belongs to the maintainer.

The purist's request to share one locator parser (should-fix) is also not done, because `guest-locator.ts`'s parser is too strict to reuse without changing it.

**Local tests**
- `tsc` is clean, the pre-push gates pass, and the web suite passes (295 passed, 8 skipped).
- The full local suite hit my 400-second limit, so the full run is CI's only.
- `test/endo-daemon-clients.test.ts` has 4 local failures from `chown: invalid user endo-daemon`. This PR doesn't change that test, and CI passed.

**Follow-ups**
- I messaged the maintainer with three decisions: does the link shape stand, does raw-locator accept stay, and does `/adopt` stay. No reply yet.
- The gauntlet is at iteration 6 of 6, so panel 7 will probably raise the declined items again and the gauntlet may halt on them.
- If it gets past panel 7 instead, its un-draft stage needs to wait for the link-shape answer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (3629332 cached reads)
- Output: 48095 tokens
- Cost: $3.0895904
- Wall-clock: 2039s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
