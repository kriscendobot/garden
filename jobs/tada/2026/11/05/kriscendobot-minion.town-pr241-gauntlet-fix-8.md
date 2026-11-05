**Fix round 8 for kriscendobot/minion.town#241 is pushed and CI is green.** The head is now `e047b2d892b`, and the panel-8 findings came from the pruner and decomplector seats. I applied all of them except decomplector 3 (comment-only), and one suggestion in decomplector 1 was not followed as written.

**Code (`697049e0`)**
- **Decomplector 1:** `create` is now `makeOpenCreate` and `makeFrozenCreate`, with shared admission, reservation and publish helpers. Frozen `create` has no `ChildMinter`, and its rollback only gives back the slot.
- **Decomplector 2:** one `ClaudeOnboarding` value now holds the link registry, form sender, child minter and delegation minting, and is present or absent as a whole.
- **Pruner 3–6:** the repeated comments are cut. The one-liner in `delegate` stays because it names a race.
- **New test:** covers a completed responder disappearing while a frozen `create` awaits.

**Docs (`e047b2d892b`, plus the PR body)**
- **Pruner 2:** the mount-order fact now lives only in the `src/http.ts` comment.
- **Pruner 7:** `DEPLOYMENT.md` links to § Frozen onboarding instead of restating it. The changeset keeps its one line.
- **Pruner 1:** the PR body is down to 391 words. I also dropped the ledger's duplicate `Design:` line, and the phase gate still returns `attention` with the ledger intact.

**Not done as asked**
- **Frozen `create` still reserves a slot:** decomplector 1 suggested skipping it, but a plain child is missing from the tree and ledger after a restart, so skipping would leave a live child uncounted. The slot is also how a `dismiss` of an unrecorded child is noticed.
- **Decomplector 3:** the deprecation notice stays in this PR.

Both points are in the PR comment for reviewers, along with one small behavior change: a frozen `create` with `watchInbox` whose responder disappears now returns before publishing a record.

**Verification**
- **CI:** `ci-wait-merge` returned rc 0 for the head. The bot token can only see Actions runs, not commit statuses or non-Actions checks.
- **Local:** typecheck is clean, and the full vitest run has 1701 passing, 14 skipped and 1 failing. The failure is `test/git-remote/capability.test.ts` › *propagates a git failure rather than reporting the ref absent*, the same one reported in round 6. This PR doesn't touch that file and CI passed, but I didn't run it on the base branch.

The round summary is posted at https://github.com/kriscendobot/minion.town/pull/241#issuecomment-6655872701. The panel was not re-run; the driver posts panel-9.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1905833 cached reads)
- Output: 31789 tokens
- Cost: $2.1321946
- Wall-clock: 2426s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
