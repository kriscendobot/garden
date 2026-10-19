---
handed-off: endojs-endo-but-for-bots-pr1505-undraft-ready
deliverable-complete: false
---
## Report: endojs-endo-but-for-bots-pr1505-gauntlet-undraft (handed off; PR #1505 is still a draft)

PR #1505 is still a draft. I'm completing this attempt as a handoff to the un-draft job I posted earlier, because another requeue would just repeat the same loop.

**What was done**
- **Advisory appellate pass** (in the first attempt): no significant issues. Two minor points:
  - A peer that connects and never sends anything may hold its socket open after cancellation (`framing.js` sniff path).
  - The Rust frame reader allocates its buffer of up to 16 MiB before any payload arrives (`socket.rs`).
- **Un-draft attempt:** the metadata check passed: OPEN, head `0ba87f2ccc290674174bfc09cd4c6d13def32f17` (the head the panel passed), still a draft. `gh pr ready` then failed with a 403 on `markPullRequestReadyForReview`, because this host's bot token can't write endojs PRs.
- **Successor job:** I posted `endojs-endo-but-for-bots-pr1505-undraft-ready`, pinned to `requires: host=endolin-garden-ece02cb4`. It checks the head before running `gh pr ready` and does nothing else. It is still in `jobs/todo`.
- **Polling:** I watched `isDraft` across four claims, 20:59–22:26Z. It stayed true and the head never changed.

**Why it's blocked:** `endolin-garden-ece02cb4` is over its token cap and isn't claiming work. `endolin-garden2` has no recent journal activity. The watchdog's notice about the stalled job is in the maintainer inbox and has been read. I also sent the maintainer a direct message asking them to un-draft #1505 by hand or free endolin capacity; it was delivered to the maintainer inbox.

**Marker:** I've left out the gauntlet marker on purpose. `undraft=done` would be false while the PR is a draft, and `head-mismatch` / `metadata-unreadable` describe failures that didn't happen. Once the successor job (or the maintainer) un-drafts the PR, the gauntlet still needs its `undraft=done` result recorded.

**Memory:** I added a note to the memory on the bot token's missing endojs write access: the endolin fallback can stall too, so after about an hour, hand off rather than requeue.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1505-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 54 tokens (1602737 cached reads)
- Output: 10621 tokens
- Cost: $3.2535988
- Wall-clock: 3183s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
