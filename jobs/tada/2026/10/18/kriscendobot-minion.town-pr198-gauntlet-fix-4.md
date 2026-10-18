PR #198 (kriscendobot/minion.town), gauntlet fix round 4: the round-4 fixes were already on the PR when I claimed this job, and CI on head `d9650ae3` is green.

**Background.** The round-4 panel reviewed head `c0f92c1d`. An earlier claimant of this same job, on host endolin-garden-ece02cb4, then pushed three commits (01:40Z) and a follow-up comment listing each fix (02:10Z). I compared every request-changes item in the round-4 panel review against the current head. Each one is either fixed or explicitly declined, so I pushed nothing new and re-posted no comment.

**Fixed:**
- **`54ee0e5`** (the invitation flow in `home.js`):
  - **assessor / breaker:** accepting an invitation now claims it first and only then creates the guest, so a forged or spent invitation no longer leaves a guest behind.
  - **saboteur:** the accept button can't be submitted twice at once, and the guest request is kept apart from the rendering code.
  - **prover:** the test now checks that the link points at `href="/"`.
  - **typist:** `website` is now marked optional (`website?`).
  - **fast-checker:** added a round-trip property test for the guest link.
- **`655b43a`** (the waitlist store):
  - **locksmith:** the public server now gets a frozen object that can only add entries. Only the admin CLI can list or remove.
  - **spec-keeper:** sorting compares strings directly instead of using `localeCompare`, which varies by locale.
  - **breaker:** the deploy script now checks that deletion protection is actually on and fails otherwise.
  - **corner-prober:** lone surrogates and zero or negative limiter settings are rejected, and there is a leap-day retention test.
  - **fast-checker / stylist / pruner:** added the property tests, renamed `cmd` to `command`, and removed a comment that only restated the code.
- **`d9650ae`** (docs):
  - **purist:** the "no enumeration" claim now covers response bodies only, and the docs state that response timing still differs. Timing was not made uniform.
  - **purist:** the CSV docs now cover every escaped prefix (`=`, `+`, `-`).
  - **archivist / integrator / pruner:** finished updating the docs so `/` is described as the public landing page, and trimmed repeated text.

**Declined:** the decomplector's must-fix to replace the whole waitlist with a contact link. The earlier claimant declined it because the maintainer asked for the waitlist (kriskowal, 2026-10-17), so it's their decision, not the panel's. The follow-up comment lists it as an option for them to veto.

**CI:** `ci-wait-merge.sh kriscendobot/minion.town 198 --no-merge` returned 0 (green, 1 of 1 runs passed, 0 failed). This host's token can't read the PR's combined check status, so the script checked only GitHub Actions runs. Any other status checks were not visible.

**Follow-ups:** the driver posts panel round 5 next. The maintainer still needs to decide whether to keep the waitlist.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 124 tokens (6158176 cached reads)
- Output: 35693 tokens
- Cost: $3.4671431999999998
- Wall-clock: 4372s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
