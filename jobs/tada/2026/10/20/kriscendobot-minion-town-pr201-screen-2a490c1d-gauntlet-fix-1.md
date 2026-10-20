**Fix round 1 for kriscendobot/minion.town PR #201: done, and CI is green.**

The job had no deterministic pre-pass block, so I worked from the latest panel review (5579610226, 2026-10-20T01:07Z, posted against head `2a490c1d`). Three jurors requested changes: pruner, coverage-auditor and decomplector. Every other juror approved or left comments only.

**Pushed to `feat/new-clip-inventory`** with `safe-push-pr-head.sh` (advance mode), `2a490c1` → `98fedc9`:

- `4234912` docs(new-clip): point at the header instead of restating it
  - **Pruner 1, 2 and 6:** in `designs/new-clip.md` § 3, the "Every visitor receives the clip power" bullet is now a pointer to the `new-clip.ts` header. The "Framing" bullet no longer lists the CSP, sandbox tokens or PR citations. The prose about the mint's error contract now points to the `mintNewClip` doc comment.
  - **Pruner 3–5:** I removed the two redundant doc comments in `src/endo/gateway/new-clip.ts`. The front-files comment now just says "in serving order". The comment in `test/new-clip.test.ts` is shortened to "Formula numbers are not secrets; no import."
  - **Decomplector 1:** § 3 has a new bullet calling the power's quota interim, to be replaced by the ledger in `clip-usage-metering.md`. § 6 lists that replacement as a follow-on.
  - **Decomplector 2:** § 3 now states that the writable `back` goes against the direction set on #85, and that the power moves behind the #88 session nonce. § 6 now starts with that move.
- `98fedc9` test(new-clip): assert the creator form rejects an invalid name
  - **Coverage-auditor 2:** `dev/new-clip-browser-demo.mjs` now submits `a/b` through the text creator. It checks that the problem line shows the validator's message and that no `a/b` entry appears.

**Checks:**
- Locally, `test/new-clip.test.ts` and `test/new-clip-power.test.ts` pass (34 tests) and `npm run typecheck` is clean.
- I did not run the browser demo locally; it ran in CI.
- I could not run `ci-wait-merge.sh` with the full 3600s deadline in one go. That attempt was stopped at the 10-minute background limit, so I reran it in the foreground with a 540s deadline. It returned rc 0: 2 of 2 Actions runs green on `98fedc9`, read through the Actions runs API because the token can't read `statusCheckRollup`.

**Follow-ups for the maintainer:**
- **Decomplector 2:** the design cites a "closed-beta product pass, kriskowal 2026-10-17" but links no record of it. I couldn't find one and did not invent a link, so the maintainer should add it or confirm the direction before merge.
- **Decomplector 1:** the alternative it proposes, giving the power a separate `meter` object, is a refactor. I only documented the quota as interim.
- **Coverage-auditor 3:** it could not check the Node-side lines because the pre-pass produced no c8 report. That is a pre-pass problem, not something this round could fix.
- **Not adopted:** the proposed rules from pruner, coverage-auditor and decomplector.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-2a490c1d-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1439262 cached reads)
- Output: 8264 tokens
- Cost: $0.9374684000000001
- Wall-clock: 1430s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
