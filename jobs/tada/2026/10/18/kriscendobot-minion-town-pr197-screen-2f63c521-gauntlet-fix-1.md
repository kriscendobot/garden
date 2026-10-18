Round-1 fixes for kriscendobot/minion.town#197 are on the PR head and CI is green.

**What happened:** An earlier claimant of this job had already applied the panel's must-fix items, pushed them and posted a follow-up comment. That claimant was requeued before it could watch CI. So I pushed nothing new; I checked the existing work against the latest panel review and then ran the CI wait.

The two follow-up commits on the head (`a643682`):
- **`cd94f49`:**
  - The live frame is now granted only when `serving === true`; a clip with no `serving` flag gets the inert card (raised by locksmith and breaker).
  - Each load is now tied to its own navigation through `loaded(generation)`, so a late load from a clip the user has moved away from can't cancel the newer clip's timeout (wire-watcher, integrator, corner-prober).
  - `FrameConfiguration` is now a union where a frame is either live or inert, never both or neither (typist).
  - New tests: a property test over the live/inert split (fast-checker), a stale load, and a policy violation arriving after load.
- **`a643682`:**
  - The browser gate now requires the live frame and its script before running the attack (prover).
  - A new control case serves a clip without the framing headers and shows it loads in a hostile parent, so the hostile-parent checks would fail if those headers were removed (prover).
  - The workflow no longer hardcodes `HOME: /root` (transplanter).
  - The wrong § 3.7 design reference is fixed (archivist, integrator).
  - Shorthand identifiers are renamed (stylist), and banner comments and the long test preamble are trimmed (archivist, pruner).
- **Summary comment:** The completion comment naming head `a643682` is posted (scribe).

**CI:** `ci-wait-merge.sh kriscendobot/minion.town 197 --no-merge` exited 0 (green): both Actions runs on `a643682` passed. The bot's token can't read the PR's combined check status, so the script fell back to the Actions runs API. That means commit statuses and checks from outside Actions weren't visible to it.

**Deliberately not done:**
- **No changeset (releaser):** the repo has no Changesets setup and the package is private, which is what changeset-auditor also found.
- **Browser base32 code kept (purist):** sharing the gateway's codec would need a bundling step the shell doesn't have yet.
- **PR description not shortened (pruner):** this was marked summary-fix, not must-fix.

**Next:** the driver re-posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 158 tokens (5938557 cached reads)
- Output: 37251 tokens
- Cost: $3.7150594000000003
- Wall-clock: 8356s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
