Panel round 2 on kriscendobot/minion.town PR #173 (the design for treating crawler hits on a clip origin as a leak signal, with automatic rotation) came back **must-fix**.

**What I did**
- Checked out the PR head in an isolated project worktree, at head `d24f3475` on branch `design/ocap-site-crawler-leak-rotation` against base `main-50aa690`.
- Ran `panel.sh` in single-round mode. It exited 0 with disposition **must-fix**. The ownership-map pre-pass flagged cross-boundary concerns, so the decomplector seat was forced on.
- Posted the aggregate review: https://github.com/kriscendobot/minion.town/pull/173#pullrequestreview-5467110908. GitHub rejected a request-changes review because the bot can't request changes on its own PR, so I posted it as a comment, as round 1 was. Its heading reads "Panel review — round 2: **must-fix**".

**Must-fix findings**
- **Skeptic:**
  - Rotation is only triggered by a verified automatic search crawler. Once `noindex` is in place that trigger may almost never fire, and no § 3.4 check measures how often it does.
  - The § 6.1 rotation-intent saga is not crash-safe as written.
- **Novice:**
  - § 1 asks the reader to hold too much before the design starts.
  - The Status block lacks the model that makes § 2 readable.
- **Pedant:**
  - Replace `≤` with `<=`.
  - Use one link format for the three references to PR #37.

**Other seats**
- Critic and decomplector requested changes, at should-fix level. Their points include a holder being able to burn the owner's link daily by getting a search engine to fetch it, the weak degraded mode in § 6.2, and the unverified startup self-check that public locator routes are contained.
- Ergonomist was comment-only.
- Copyeditor, orthographer and thesaurus approved.

**Follow-ups:** I made no fixes and did not un-draft, as this stage requires. The gauntlet driver will run the next fix-loop stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (708013 cached reads)
- Output: 3273 tokens
- Cost: $0.6253745999999999
- Wall-clock: 176s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
