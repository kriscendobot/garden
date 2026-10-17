## PR #200 fix round 2: fixes pushed, CI still pending at the deadline

I applied the round-2 must-fix items and pushed them to the head of kriscendobot/minion.town#200, moving it from `c4ebb83` to `908b48a`. CI never started within the 1-hour deadline: all three jobs (`test`, `Claude harness` amd64/arm64) sat `queued` for the whole window.

**Fixes pushed** (with `safe-push-pr-head.sh`):
- **`c98a1e7` — torn tombstone line** (corner-prober's must-fix item; the assessor raised the same point). After a crash, the deleted-guests file could end in a partial line with no newline. The next deletion glued its tag onto that fragment, so the tag was dropped on restart and the deleted guest's credential worked again. Startup now ends the torn line before anything else is appended. A new test loads a torn file, adds a tag, reloads, and checks that both the earlier tag and the new one survive.
- **`55fef95` — daemon cleanup** (assessor's should-fix): it now tries every agent name and reports the first failure, instead of stopping at the first failed cancel.
- **`908b48a` — pruner items 1–11**: cut the comments that repeat their code, and the ENDO_GC rationale now lives only in `deleted-guests.ts`. The warning about what breaks if the app deploys first moved into the `deploy-accounts-store.sh` header, and `DEPLOYMENT.md` points to it.
- **PR body** (pruner item 12): trimmed from about 725 words to 534, keeping the data-deletion table and the remaining choices.

**Left for a follow-up:** I posted a comment on the PR giving the reason for each item I skipped:
- **purist 1:** the guard already fails type-checking when a required method is added to the interface, so a Proxy would lose that check.
- **purist 2–3, migrator 1–2, corner-prober 2–6:** these are should-fix refactors and extra test tables, deferred so this round stayed on the must-fix item.
- **migrator 3:** the no-bond hint's "Add a recovery sign-in" link keeps the bonding flow reachable.

**Local checks:** `tsc --noEmit` is clean. The full test suite has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). It touches none of the changed files, and I took it to be the known false failure caused by the garden's git wrapper, but I did not check that.

**CI stall:** This looks like a stalled runner, not a GitHub rate limit, so it may not clear on its own. No minion.town run has started since 14:18Z, and runs from 13:48Z onward are queued (`main`, `feat/new-clip-inventory`, `feat/chat-clip`, this PR, and two `design/git-remote-*` branches). The `ci-minion-town` runner shows online and busy and is re-minting itself (new instances at 15:21Z and 15:31Z), but nothing advances. The GitHub API quota was at 4992 of 5000, so the rate-limit cause from my notes doesn't fit. The background run of `ci-wait-merge.sh` was killed at the tool's time limit, so I polled CI myself in the foreground until about 15:56Z, roughly an hour after the push. When the driver re-posts this stage, it may hit the same stall unless someone looks at the runner.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2186491 cached reads)
- Output: 12685 tokens
- Cost: $1.3363582
- Wall-clock: 3636s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
