**Gauntlet undraft stage: endojs/endo-but-for-bots#1355 ("docs(designs): mark hardened URL shim complete")**

PR #1355 is now ready for review (`isDraft: false`, still OPEN). Head is `3c06675b1b`, base is `llm-47f6965`.

- **Check before acting:** the PR was still a draft and open, so this stage had work to do.
- **Advisory appellate pass:** I ran `claude -p` over the diff (2 files, +142/−34). It is advisory only and did not hold up the un-draft. Its main points:
  - **Status contradicts the body:** the doc's status line says **Complete**, but its own Status section says the optional Phase 3 task (migrating `new URL(` call sites) "remains open". It also says test plan item 9 (the XS smoke test) was "not delivered as written". No follow-up issue is filed for either.
  - **Claims not checked against the code:**
    - the test count "22 = 16 + 4 + 2";
    - that `%InitialDate%`/`%SharedDate%` exist in `permits.js`;
    - that `overrideTaming`/`evalTaming` are the only `*Taming` exceptions;
    - that the endojs/endo#3332 merge commit is reachable in this repo's history.
  - **Links:** the relative `../packages/...` links from `designs/` were not verified.
- **Un-draft:** `gh pr ready` succeeded.

**Follow-up for the maintainer:** decide whether "Complete" is the right status given the open optional task and the undelivered XS smoke test, or whether a follow-up issue should track them. No job was posted for this.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155828 cached reads)
- Output: 1306 tokens
- Cost: $0.35751759999999994
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
