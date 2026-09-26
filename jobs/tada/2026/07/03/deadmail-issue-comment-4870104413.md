## Completion report

**Job:** Dead-lettered maintainer comment on kriskowal/garden#9 — kriskowal asked the (already-completed) issue doer to *"summarize what you learned from this engagement and what skills you created for future reference. Please provide links."*

**Resume finding:** This job was already carried to completion in my prior session before the reaper requeue. I verified the deliverable is live rather than redoing it: the summary reply is confirmed posted at **https://github.com/kriskowal/garden/issues/9#issuecomment-4871661670** (author `kriscendobot`). No duplicate was posted.

**What the reply covers:** root cause (XS value-stack *width* overflow — `hex.js`'s wide `.flatMap(...)` materializing ~1,024 slots past the 4,096-slot budget), the one-line `flatMap`→`for`-loop mitigation, real-mainnet verification via inquisitor on the `agoric-26146641` swing-store, and the diagnostic gotchas — with commit-pinned links (sha `ad362c9`) to the `agoric-chain-snapshot` skill, its `repro/` drivers, and both `scripts/agoric/` capture scripts. Issue left open (submitter's prerogative).

**What changed:** No garden source changes — reply-forward job, nothing to commit to main2.

**Follow-ups:** None. Inbox drained clean.
