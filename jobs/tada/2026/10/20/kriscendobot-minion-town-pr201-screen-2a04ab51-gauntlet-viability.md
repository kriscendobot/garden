**Viability gate: kriscendobot/minion.town PR #201** ("feat(shell): New Clip, a blank clip that becomes a pet-name inventory")

I did read-only checks only. Nothing was changed, posted or pushed. The PR is open, unmerged and not a draft, at head `2a04ab51` with CI green.

Deciding question: Is New Clip (the `+` mint, the pet-name inventory metamorphosis, and the writable nested clip space required for the closed beta) still missing from `kriscendobot/minion.town` `main`, with no newer open or merged PR doing the same job?

Answer: yes. The PR is not superseded and its premise still holds.

Evidence:
- **Not on `main`:** `designs/new-clip.md`, `src/endo/gateway/new-clip.ts` and `clips/new-clip/model.js` all return 404 on `main`.
- **Recent `main` history:** the newest commit is `ea08cf05`, which merged #207. The changes back to #206 are about deploy, CI, the harness, git-remote design and a browser-test race. None of them implements New Clip.
- **No replacement PR:** a search for related PRs finds none. The PR this one depends on, #197 (live framing), is merged, which supports the premise. #202 (Chat, a New Clip form) is a draft based on #201's own branch, so it builds on this PR rather than replacing it.
- **The motivation still holds:** the PR body says the writable, nested space is the closed-beta requirement in `designs/new-clip.md` § 3.
- **Why the last gauntlet stopped:** it halted on 2026-10-20 to get a maintainer ruling on decomplector's design question. The question is whether a clip power that visitors can write to may depart from the #85 nonce-locator direction. That is an open authority/design decision, not evidence that the PR has been overtaken; #85 and #88 are still open and unmerged.

Caveat: the maintainer has not answered that ruling yet. If the gauntlet goes ahead now, it will probably halt on the same decomplector must-fix. The remaining should-fix items (from purist, assessor, decomplector and typist) depend on that ruling.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-2a04ab51-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (215231 cached reads)
- Output: 1911 tokens
- Cost: $0.4418902
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
