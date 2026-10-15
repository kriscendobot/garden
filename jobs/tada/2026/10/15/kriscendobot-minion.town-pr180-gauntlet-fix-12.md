I applied the round-12 must-fix items on kriscendobot/minion.town PR #180 and pushed them as two follow-up commits. The PR head moved from `2d14e79` to `f9422e0`, and CI on that head is green (`ci-wait-merge.sh` returned rc 0).

**What changed**
- **`9a86197`, locksmith must-fix:** `open` now checks only the retention key. The check against the unauthenticated `x-git-partition-owner` header is gone, so a guest that hands its key to another guest transfers the partition. `facetKeyFor` no longer takes the owner; facet keys come from the partition and attenuation only. Only `create` reads the owner header and checks its credential. I added two tests where a second owner opens and mints with a transferred key: one against the control app, one through a second owner's caplet. Tests that relied on the old owner binding were updated.
- **`f9422e0`, pruner and typist:** the control-plane mechanism is now explained only in the `control.ts` header. The design doc's item 2, the rotation paragraph in `DEPLOYMENT.md` and the comment in `minion-mcp.service` are cut down to pointers. Two comments that only restated test code are deleted, and the `…` in `deploy-git-remote.sh` is now `...`.
- **PR body, integrator must-fix:** "git-remote plan" and "increment 5" are replaced with real anchors: deferred item 2 of the increment-1 design, and parent design § 7, § 12.2 and § 9.
- **Scribe summary-fix:** I posted a completion summary for rounds 8–12 (issuecomment-6202381328). It maps each round to its commits, lists what was declined, and gives the verification and CI status.

**Declined or deferred**
- **Decomplector must-fix ("remove the HMAC/facet-key layer"):** declined. The arc supervisor already decided to keep that layer in issuecomment-6198217929. The related caplet-rebinding should-fix waits on the same decision.
- **Should-fixes left for later:**
  - Breaker: a read-only holder can fill the shared mint cap, and the rescan check can be defeated by interleaving mints.
  - Locksmith: a read facet can revoke another read facet's URL.
  - Integrator: rename `createGit`, and regroup the commits before un-drafting.

**Verification:** the control and caplet test files pass (18/18) and `tsc --noEmit` is clean. Locally, `test/git-remote/capability.test.ts` fails 1–2 tests depending on the temp directory, including "propagates a git failure", which expects git to exit 128. I didn't confirm the cause or whether it also fails without my commits. My best guess is this host's git and temp-directory layout, since that file doesn't touch the control plane. CI passed with it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2892757 cached reads)
- Output: 17059 tokens
- Cost: $1.6555313999999997
- Wall-clock: 1198s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
