**FIX round 1 — endojs/endo-but-for-bots PR #1397: CI green, no new push from this attempt**

An earlier claimant of this job had already applied the fixes. The PR head is now `376a462af4`, and the panel reviewed `1eb434a3e8`. So I checked each panel item against what is on the PR now, pushed nothing new, and watched CI to the end.

All panel must-fix items are addressed on the head:
- **integrator 1:** The PR title and the commit `8500979a74` now both read `fix(ocapn): enliven a returning SturdyRef with a wire-decoded swiss number`.
- **integrator 2:** The description now names the correct frozen base, `build/sturdyref-captp-construct-b0778fa`.
- **integrator 3:** The invented `## Stack index` heading is gone. The stack list now sits in `## Description` as a plain list.
- **corner-prober 1–3:** There is a new test, "a byte secret minted at home resolves as a peer fetch would". It covers ASCII-range bytes, the empty secret, and the boundary between `0x7f` (still decodes as text) and `0x80` (passes through as raw bytes).
- **changeset-auditor:** The changeset now has one sentence per line, plus a note that ASCII-range byte secrets reach the locator as a string.

Commit `376a462af4` also covers the should-fix items:
- **breaker 1 and engine-realist 1:** A shared `lookupSecretBytes` helper now prepares the secret bytes (`thawedBytes` first) the same way for the bootstrap `fetch` and the home enliven path.
- **engine-realist 3:** The immediately-invoked thunk is gone.
- **breaker 4:** A comment now explains why the `try` must stay around the decode (its error would leak part of the secret).
- **archivist 1:** `@returns` is added on the helper.
- **procurer and integrator 4:** The test reuses `enliven` from `@endo/sturdyref` and imports `locationToLocationId` through the public `@endo/ocapn/client/util` export.
- **pruner:** The Documentation Considerations section is trimmed and the test counts are dropped from the PR body.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1397 --no-merge` returned rc 0: all 33 checks passed, 0 failed.

**Not done:**
- The suggested CBOR-codec variant of the non-ASCII round-trip test (engine-realist 1, should-fix) was not added.
- The comment-only points were left for panel round 2.

I did not re-run the panel; the driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 82 tokens (3023949 cached reads)
- Output: 17886 tokens
- Cost: $2.1579258
- Wall-clock: 4312s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
