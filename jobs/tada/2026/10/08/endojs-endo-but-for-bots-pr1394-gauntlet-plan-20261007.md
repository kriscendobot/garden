I checked endojs/endo-but-for-bots#1394, "feat(captp,ocapn): layer 5 — CapTP mints SturdyRefs and carries them over the wire". It is still open and not a draft. Its head branch is `build/sturdyref-captp-wire` and its base is the pinned `build/sturdyref-marshal-representation-36c4f40`.

I then ran `scripts/jobs/post-gauntlet.sh --arc endo-ocapn-background endojs-endo-but-for-bots-pr1394-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/1394`. It recorded the gauntlet `endojs-endo-but-for-bots-pr1394-gauntlet-20261007` as a feature gauntlet with these limits: 6 iterations, 6 resumes and 2 retries per stage. That gauntlet now runs clean, then panel review, then the fix-loop, then un-drafting the PR.

No garden files changed and nothing was committed. There are no follow-ups beyond the gauntlet itself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-plan-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (110048 cached reads)
- Output: 698 tokens
- Cost: $0.3343376
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
