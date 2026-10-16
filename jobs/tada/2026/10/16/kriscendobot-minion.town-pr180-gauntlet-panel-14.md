Panel round 14 on kriscendobot/minion.town PR #180 came back **must-fix**. `panel.sh` exited 0, and I posted the verdict to the PR.

**What ran:** I made a separate checkout of the PR head (`94ce118`, branch `design/git-remote-endo-binding`) and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the base `origin/main-c7bdf20`. All 34 seats returned. The new-mechanism, PR-body-length and repeated-mechanism checks all triggered, so the decomplector and pruner seats were required to run.

**Votes:** 6 request-changes (archivist, decomplector, engine-realist, pruner, purist, saboteur), 7 approve, 21 comment-only.

**Main must-fix findings:**
- **decomplector:** The HTTP control plane is the custom mechanism that fix round after fix round keeps patching. A daemon-hosted registry, like the existing `installSiteRegistry` / `site-register-caplet.ts`, would replace it. The seat says to **get maintainer confirmation before another fix round**. It also says the plain `retentionKey` secret contradicts the parent design (`designs/git-remote-capability.md` § 7), which requires write authority to be a capability object rather than a passed-around secret.
- **engine-realist:** Commit `118e6c1` makes every control call check `/hello` against the credential from the old secret. So rotating the secret breaks every retained partition, which contradicts `DEPLOYMENT.md`. No test covers a caplet on the old secret talking to a listener on the new one.
- **archivist:** The design doc says rotation is documented in the `control.ts` header, but it isn't.
- **Should-fix:**
  - **saboteur:** a read-only holder can fill the 256-URL cap so nobody can mint more.
  - **saboteur:** the mtime check meant to stop repeated rescans doesn't hold.
  - **purist:** the attenuation and the facet key can disagree in `makePartition`.
  - **purist:** hex encoding is hand-written and protocol constants are copied by hand.
  - **pruner:** the PR body is 348 words against a 300-word target, and some comments just restate the code.

**Where it's posted:**
- **Review:** I posted it as a COMMENT review because GitHub won't let the bot request changes on its own PR. Rounds 11 and 12 used the same shape. It opens with "**Panel verdict (round 14): must-fix**", then lists the headline findings and the full text of all request-changes seats. It is about 62,000 characters, under GitHub's size limit for a review.
- **Remaining 17 seats:** their text didn't fit in the review, so I put it in a separate PR comment rather than a second review (https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6213533889).

**Follow-up:** Since the decomplector wants maintainer confirmation before more hardening, the gauntlet driver or liaison may want to bring that to the maintainer rather than run fix round 15 automatically.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-14.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (952557 cached reads)
- Output: 5864 tokens
- Cost: $0.7967993999999999
- Wall-clock: 366s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
