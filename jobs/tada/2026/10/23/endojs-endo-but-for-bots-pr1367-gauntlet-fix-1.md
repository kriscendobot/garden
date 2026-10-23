Fix round 1 for endojs/endo-but-for-bots#1367 is done: the arrow fix is pushed and CI passed with 0 failures out of 30 checks.

**What I did**
- **Source of findings:** there was no panel review for this round, so I worked from the deterministic style pre-pass output. All of its findings came from the `typist-friendly-code-points` probe.
- **Change:** one follow-up commit, `6c2e9607b`, on `design/daemon-git-remote-capability-urls`, titled "docs(designs): type ASCII arrows in place of U+2192/U+2194".
  - `designs/README.md:1236`: `↔` became `<->`.
  - `designs/daemon-git-remote-capability-urls.md:37`: `↔` became `<->`.
  - `designs/daemon-git-remote-capability-urls.md:116`: `→` became `->`.
- **Extra fixes beyond the listed three:** after those edits the probe failed again, on line 117 of the same design doc. It had only shown some of the problems at first. I changed every remaining `→` in that table (lines 117–119) to `->`.
- **README left alone otherwise:** I reverted the probe's whole-file rewrite of `designs/README.md` beyond line 1236. Those other lines aren't part of this PR's diff and the probe doesn't check them.
- **Gate check:** `pre-push-gates.sh --probes-only --base-ref origin/llm-d5ac419` now passes all 9 stages, including `typist-friendly-code-points`.
- **Push:** went through `safe-push-pr-head.sh --mode advance`, moving the branch from c897975e9 to 6c2e9607b.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. I ran it with a 560s deadline rather than the 3600s the job specified, and it went green within that window.

**Follow-ups:** none. I did not re-run the panel; the gauntlet driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (939074 cached reads)
- Output: 4820 tokens
- Cost: $0.7416228000000001
- Wall-clock: 1119s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
