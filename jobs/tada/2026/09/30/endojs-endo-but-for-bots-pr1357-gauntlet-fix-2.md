## Gauntlet fix round 2: endojs/endo-but-for-bots#1357

I applied the round-2 panel's must-fix items and pushed them as one follow-up commit, `87adcf3d24`, on top of `3d8974353d` on `design/endo-claude-inference-backends`. CI is green: 28 of 28 checks passed with none failed, and `ci-wait-merge` returned rc 0.

All changes are in `designs/endo-claude-inference-backends.md`:

- **Critic (the blocking item):** Decision 5 now has a section that cites and reconciles `hosted-agent-broker-oauth.md`. That design found Claude Code has no documented way for a third-party broker to carry a subscription.
  - **Vendor text:** Anthropic's gateway documentation keys on the credential variable being set, not on whose token is in it. So the 2026-09-28 probe falls inside the documented case, where the subscription's usage limits don't apply.
  - **Broker subscription mode stays closed.** Passing gate 6 is now "necessary, not sufficient". The `SUBSCRIPTION-AUTH.md` gate also has to open, either through vendor documentation or a maintainer amendment. This design does not amend it.
  - **Downstream text:** the Dependencies row, phase 5, Resolved question 1 and Known Gaps now say the same.
  - **Interim delivery:** it has the same open question about which account the usage is charged to. Gate 1's canary now records where the usage lands.
- **Skeptic:**
  - The design now names the subscription-terms question (is automated, multi-principal use of a personal subscription allowed?) as an unresolved dependency.
  - Gate 3 gains a fourth shape: a turn that hangs with no response, which the probe already saw. The canary must show the backend's own wall-clock limit ends such a turn.
  - If the subscription path stays closed, guests can bring API keys only, and the stopgap way of passing the token straight to the process never becomes the multi-principal policy.
- **Novice:**
  - The Evidence section now states that #105 is "Track A" and #106 is "Track B".
  - Bare "Decision N / gate N / phase N" references are explained there. The forward references in the Revision section are now links.
  - The ownership-map checklist now says where it comes from.
- **Pedant:**
  - Top-level (`##`) headings are now title case, matching the repo's design template. `###` headings stay sentence case.
  - "gate-2 canary" is now "gate 2 canary".
  - I left "TODOs" as it is. It is an acronym and the template's heading, so the suggested "Todos" would be wrong.
- **Copyeditor (optional, done anyway):** I split the sentence joined by "but … so …" and reworded the Decision 9 title.

I left the comment-only items from decomplector and ergonomist alone: moving `budget` out of `limit-exceeded`, and mapping `InferLimits` field names to the `which` tags. The panel-3 round can raise them again if wanted.

I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1600191 cached reads)
- Output: 14913 tokens
- Cost: $1.3711221999999996
- Wall-clock: 1259s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
