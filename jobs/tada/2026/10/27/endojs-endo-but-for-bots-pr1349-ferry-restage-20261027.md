The ferry for endojs/endo-but-for-bots#1349 is staged again on the woven head with CI green. Nothing has gone upstream yet: the maintainer still needs to run `scripts/ferry.sh` on the credentialed host.

**What I checked before staging:**
- **Base:** the PR is now based on `master-ebc7904`. That snapshot equals upstream `endojs/endo` `master` at `ebc7904d87b1`.
- **Head:** `b122ff91ef98ac3e151852b58d2cb1110060fb26`, 46 commits ahead of the base and 0 behind. The PR is open, not a draft, and mergeable.
- **CI:** all 16 check runs on `b122ff91ef` passed.
- **Precondition jobs:** `...-pr1349-fix-maintainer-findings-20261027` and `...-pr1349-fix-changeset-range-20261027` are both in `jobs/tada/`.
- **Changeset-range fix:** it landed as `91cca8a551` ("docs(ses): state measured codec range") and the rebased version of that commit is on the woven head. The changeset there names the measured Chromium range (120–137 affected, 138–140 clean), not "all Chromium before 138".
- **Weave job:** its board entry was still in `doin/` when I looked, but its weave summary comment is already posted on the PR.

**What changed:**
- **Directive moved back to pending.** It was sitting in `jobs/ferry/doing/`, left there by an earlier ferry run on host `kmkmbp2026` (20:54–20:56Z). That run was against the old base `master-6ee3fda` and exited without the completion marker. `ferry.sh` only picks up directives in `jobs/ferry/`, so I moved it there. It landed on `journal2` (blob `065b869`) through a scratch clone with a push-and-rebase retry loop, not the root journal worktree.
- **Directive content:**
  - Added the new base, head and upstream base SHAs.
  - Added a "Preconditions (checked at re-staging)" section showing all three as satisfied.
  - Added a "Prior attempt" note about the failed run.
  - Told the boatman to stop with a blocked report if the head has moved or CI is no longer green.
  - Told it to stop if the head doesn't rebase cleanly onto a newer upstream master.
  - Told it to squash the `fixup!` commits in the head. That instruction is my addition, not something the job asked for.
- **Authorization:** `identity_switch_authorized: true` is unchanged and still traces to the maintainer's review. The comment URL https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453429130 is now in the Authorization provenance section.
- **PR comment:** posted https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453977855, saying the ferry is staged again and asking kriskowal to run `scripts/ferry.sh` on the credentialed host.
- **Board:** no boatman job was posted, and there were no garden (`main2`) changes.

**Follow-ups:**
- The maintainer runs `scripts/ferry.sh` on the credentialed host.
- The earlier failed run's log is only on `kmkmbp2026` (`/Users/kris/garden/.garden-ferry/logs/endojs-endo-but-for-bots-pr1349.20261027T205407Z.log`), so I couldn't see why it failed. It may be worth a look if the next run fails too.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `91cca8a5511d5c846eec173989fb025b5e4fa919`; this job presented `b122ff91ef98ac3e151852b58d2cb1110060fb26`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-ferry-restage-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1159570 cached reads)
- Output: 8558 tokens
- Cost: $0.9481140000000001
- Wall-clock: 118s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
