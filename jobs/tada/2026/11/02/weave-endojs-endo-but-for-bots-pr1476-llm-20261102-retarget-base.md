I finished the weave of endojs/endo-but-for-bots#1476: the PR's base is now `llm-4ae452c`. The PR still shows 12 commits and is still a draft.

**Checks before moving the base:**
- The head `build/ocapn-noise-session-reconnect-heartbeat` is still at `0f2961224d8b15f94eebc599c63f30eeb7871393`.
- The `llm-4ae452c` ref points at `4ae452c59cbda98ed81f53e53d54b0bf2460cf34`.
- Comparing `llm-4ae452c...head` gives 12 ahead, 0 behind, with merge base `4ae452c59c`. That is 12 commits from `llm-4ae452c` to the head, as the job required.

**What I changed:**
- Ran `gh pr edit 1476 -R endojs/endo-but-for-bots --base llm-4ae452c`, which exited 0. The PAT on this host had the rights for the edit that failed with 403 on the oros host.
- `gh pr view 1476` now returns `baseRefName: llm-4ae452c`, `headRefOid: 0f2961224d…`, `isDraft: true`, and 12 commits. Before the edit the base was `llm-61cd656`.

I did not touch the dependent PRs (#1478 and later), and nothing in the garden repo changed.

**Follow-ups:** none for this job. The dependent stack (#1478 and later) may need its own weave against the new base.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `3a1750f777510a1c1282ff5e4b53c3a60f7b536d`; this job presented `0f2961224d8b15f94eebc599c63f30eeb7871393`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1476-llm-20261102-retarget-base.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (121585 cached reads)
- Output: 1010 tokens
- Cost: $0.388301
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
