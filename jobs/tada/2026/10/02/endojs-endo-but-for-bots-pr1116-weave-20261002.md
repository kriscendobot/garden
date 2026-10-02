## PR #1116 weave: done (endojs/endo-but-for-bots, design: guest-native invitations)

I rebased PR #1116 onto live `llm` (afc72caff91) and force-pushed it with lease (e70a960422 → **1fa38f6da0**). CI is green and GitHub reports the PR as MERGEABLE / CLEAN. I posted a fresh conductor job to merge it: **`endojs-endo-but-for-bots-pr1116-conduct-20261002`**.

**Why I rebuilt the commits instead of a plain rebase.** The old head mixed 9 design commits with 3 merges from `llm`. A straight `git rebase` kept stopping on `designs/README.md` at nearly every step. The "address panel round N" commits had added a "Recently added" blurb to the README that the later `llm` merges took out again, so replaying them would have meant resolving conflicts over text that isn't in the final tree. So I rebuilt the 9 commits linearly on afc72caff91:
- Each commit keeps its original message, author and date, with its own changes to `designs/guest-native-invitations.md` applied.
- **The design file is byte-identical to the approved head** (`git diff e70a960422 HEAD -- designs/guest-native-invitations.md` is empty).
- The first commit adds the README index row in its original "Not Started" form.
- The "reconcile with landed work" commit brings the README to the state the approved head had (that state originally came in through a merge commit):
  - the row is updated to `2026-09-30 | In Progress`;
  - the roadmap-table row for "2 — connect peers" is added;
  - the totals note is added.

**The one judgment call in the README.** The totals note now sits after `llm`'s new Cloudflare-pass sentence and reads "indexed records from **243 to 244**". The approved head said 240 → 241, but `llm` has since moved to 243. In Progress still goes 83 → 84. Net diff against `llm` is still just those 2 files (4 README lines plus the 1126-line design).

**CI on 1fa38f6da0:** lint, zizmor and change-detection pass. The heavy test legs were skipped because the diff only touches docs. Nothing failed.

**For the conductor and maintainer:**
- kriskowal's APPROVED review is still on record, but it points at the old SHA e70a960422. `reviewDecision` shows empty, so if the merge gate wants an approval on the current head, kriskowal may need to re-approve.
- The PR base is still `llm`, not a frozen `llm-<sha>` snapshot. That keeps the merge landing on live `llm` (merging into a snapshot is how #621's content got stranded).
- I left no PR comment because the job didn't authorize one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-weave-20261002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1157682 cached reads)
- Output: 8693 tokens
- Cost: $0.9372843999999996
- Wall-clock: 1287s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
