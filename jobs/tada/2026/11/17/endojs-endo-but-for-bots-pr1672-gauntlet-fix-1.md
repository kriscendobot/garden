Fix round 1 for endojs/endo-but-for-bots#1672 is done: the prepass finding is fixed, pushed, and CI is green (31 checks, 0 failed).

- **The finding:** the prepass flagged one U+2192 RIGHTWARDS ARROW at `designs/endopi-skills-markdown-format.md:232`. The same arrow also appeared on lines 233 and 234 of that table, so I replaced all three with `->`. The file now has no `→` left; I did not re-run the probe itself.
- **The push:** I committed it as a follow-up, `fff66514bb` ("docs(endopi): type ASCII arrows in skills ownership map"). `safe-push-pr-head.sh` moved the PR head `design/endopi-skills-markdown-format` from `7372dd331a` to `fff66514bb`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 6 minutes.

I did not run the panel again; the driver posts panel-2. Nothing else needs doing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1672-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (425548 cached reads)
- Output: 1773 tokens
- Cost: $0.5073056
- Wall-clock: 489s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
