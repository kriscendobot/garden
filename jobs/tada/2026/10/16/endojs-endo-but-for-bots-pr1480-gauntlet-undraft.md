**Completion report: gauntlet UNDRAFT stage for endojs/endo-but-for-bots PR #1480**

PR #1480 (docs(designs): specify the op:start-session extraction from OCapN core; base `llm-61cd656`) is now ready for review. The head is still `d1c0d55c46675548a7497f73aa81d02496ef1f82`, the commit the passing panel reviewed.

**What I did:**
1. **Advisory appellate pass.** I ran one `claude -p` (sonnet) review over the PR diff. It doesn't block the un-draft. Possible issues the panel may have missed:
   - **Phasing:** commit 2 `git mv`s `client/handshake.js` while core's `client/index.js` still imports it until commit 4. The commits in between may not build.
   - **`provideSession` return type:** the doc says core's contract returns `NetworkSession` (reader/writer), but the adapter resolves with an `AdoptableSession` (write/close). The memo/no-reader rule needs an exact statement of which object comes back.
   - **Wire-parity test:** byte-identical hello captures need injected deterministic keypairs or a seeded RNG, and the test plan doesn't mention either.
   - **Missing tests:** Security Considerations says the test suite covers the flood bound and abort paths, but the Test Plan lists no such tests.
   - **README wording:** the README note calls the change a "move", which understates the `adoptSession` push contract and the legacy-factory guard.
   - **Stale framing:** the Prompt section and "Original framing" still describe a "redundant handshake" in `np`. They should be labeled as superseded.

   These are recorded here only; I posted nothing to the PR. A fixer could take them up if the maintainer agrees.
2. **Pre-mutation gate.** Fresh metadata showed state OPEN, `isDraft: true`, and headRefOid matching `d1c0d55c…`.
3. **Un-draft.** I ran `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1480`, which succeeded.
4. **Post-check.** `isDraft: false`, headRefOid still `d1c0d55c46675548a7497f73aa81d02496ef1f82`.

I made no garden repo changes.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1480-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (167980 cached reads)
- Output: 1528 tokens
- Cost: $0.39061999999999997
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
