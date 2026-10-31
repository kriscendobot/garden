**PR #1588 gauntlet viability: proceed.** I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** endojs/endo-but-for-bots#1588 "feat(fetch,confined-fetch): split the unfettered base from the confined plugin" is open and unmerged. It is a draft and GitHub reports it mergeable. It was opened 2026-10-31T07:19Z by job `build-endoclaw-network-fetch`. Its base is the frozen branch `llm-9a14ddf` (9a14ddf660).

**Deciding question:** Does live `llm` still lack the two-plugin split that `designs/endo-fetch.md` asks for (base `@endo/fetch` plus the confined `@endo/confined-fetch`), with no newer PR or design providing it?

**Evidence:**
- **Base is current:** comparing `llm-9a14ddf...llm` shows `llm` is 0 commits ahead. The pinned base is the current tip, so no newer base history has displaced the PR.
- **Split not on `llm`:** `packages/confined-fetch` does not exist on `llm` (404). The last change to `packages/fetch` on `llm` was 2853ff21d9 on 2026-08-05, a types fix. That is the old single-plugin shape from #723.
- **Design still asks for it:** on `llm`, `designs/endo-fetch.md` is still **Status: Not Started**. It supersedes `endoclaw-network-fetch`, and its "Alignment for Implementation PR #723" section asks for this split in its own PR. That is exactly what #1588 delivers, so the motivating need still holds.
- **No competing PR:** an open-PR search for "confined-fetch" found only #1588. The other hits are unrelated: #673 and #735 are fetch-surface designs this PR links as related, not replacements.

**Follow-ups:** none from this stage. The PR records a known gap as its own follow-up: the confined worker has no timer endowment, so `@endo/confined-fetch` needs `makeUnconfined` for now. That stays with the PR's review.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (182652 cached reads)
- Output: 1723 tokens
- Cost: $0.4489504
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
