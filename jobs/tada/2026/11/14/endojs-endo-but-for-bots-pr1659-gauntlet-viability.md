**Viability report: endojs/endo-but-for-bots#1659.** "ci: correct peter-evans/create-pull-request pin comment to v8.1.1"

The PR is open and still a draft. It was created 2026-11-14T06:50Z. Its base is the frozen `llm-48d6f3e` and its head is `7c100929`. It changes one line in each of two files under `.github/workflows/`.

Deciding question: Does live `llm` still carry `create-pull-request@5f6978fa… # v8` while the floating `v8` tag points somewhere other than `5f6978fa`, with no other PR or commit already fixing that comment?

Answer: yes.

Evidence:
- **The comment is still wrong on live `llm`.** Line 49 of both `update-action-pins.yml` and `update-action-pins-major.yml` still reads `peter-evans/create-pull-request@5f6978faf089d4d20b00c7766989d076bb2fc7f1 # v8`.
- **The tags confirm the PR's claim.** On peter-evans/create-pull-request, tag `v8.1.1` is `5f6978fa` (the pinned commit). Tags `v8` and `v8.1.3` both point to `3ffccacd`, so zizmor's `ref-version-mismatch` finding still applies.
- **Nothing has fixed it on `llm`.** The newest commit to touch `update-action-pins.yml` there is from 2026-10-18, a setup-node bump that left these lines alone.
- **No other PR does the same work.** No other open or closed PR has "create-pull-request" in its title. The only open grouped dependency PR (#1654) bumps npm packages and doesn't touch workflows.
- **The reason for the PR still holds.** Zizmor CI is red on PRs against `llm` because of this comment. #1659 makes the same comment-only fix as #546, and the pinned commit stays the same.

No clean, panel, fix, CI-wait or un-draft work was done, and nothing was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1659-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (245613 cached reads)
- Output: 1666 tokens
- Cost: $0.4624586
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
