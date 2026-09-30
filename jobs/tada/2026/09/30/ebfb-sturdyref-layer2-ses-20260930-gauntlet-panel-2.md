Round 2 of the review panel for endojs/endo-but-for-bots#1391 (head `c78271e1f1`, base `ef4662f04b`) came back **must-fix**, and the verdict is posted on the PR.

**How it ran:**
- I made an isolated checkout of `endojs/endo-but-for-bots@build/sturdyref-ses-accommodation` and ran `panel.sh` in single-round mode against the PR's exact base commit. It exited 0 with disposition `must-fix`.
- The full review from all 33 seats was about 82 KB, which is over GitHub's 65,536-character limit for a review body. I posted it in the round-1 shape instead: seats that requested changes or commented are expanded, and the 20 approving seats are listed by name. That came to 42.5 KB and ends with `<!-- garden-panel-verdict: must-fix round=2 -->`.
- GitHub refused a request-changes review because the bot opened the PR itself, so it went up as a COMMENTED review (id `5364797967`), the same as round 1. The verdict marker carries the must-fix.

**Must-fix and should-fix findings for the next fix round:**
- **PR description:** it is missing four template sections: Scaling, Documentation, Compatibility and Upgrade Considerations. The integrator seat raised this as must-fix, and a check that runs before the reviewers flagged the same thing, which alone makes the verdict must-fix. The pruner seat asks to trim the Security Considerations and Testing Considerations sections, which repeat other parts of the description.
- **saboteur (should-fix):** any unrelated function named `SturdyRef` on the global object before `lockdown()` is now hardened and shared with every compartment. The seat reproduced this. The PR needs to either tighten the check so only the real `SturdyRef` qualifies, or say in the description that this is intended.
- **changeset-auditor:** `.changeset/ses-permit-sturdyref.md` breaks the one-sentence-per-line rule.
- Several seats left comment-only notes. One says the completion-summary comment leaves out verification status and which review items were declined.

I did no fixing and did not un-draft the PR; this stage only runs the panel.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1022502 cached reads)
- Output: 5439 tokens
- Cost: $0.7787764
- Wall-clock: 390s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
