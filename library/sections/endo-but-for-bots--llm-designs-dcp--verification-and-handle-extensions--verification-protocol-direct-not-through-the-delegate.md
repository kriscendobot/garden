---
title: Verification protocol — direct, not through the delegate
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions
---

Bob holds a Handle for Aifred, whose epithet chain is
`[(assistant to Alice)]`. Bob wants to verify the claim:

```
1. Bob inspects Aifred's Handle to read its epithet chain.
   → [(assistant to Alice)]
   → The epithet includes a reference to Alice's Handle.

2. Bob asks Alice's Handle: "Do you confirm that this Handle
   stands in the 'assistant' relationship to you?"
   → E(aliceHandle).verify(aifredHandle, "assistant")

3. Alice's Handle responds:
   → true:    "Yes, I created this delegate as my assistant."
   → false:   "No, I deny this relationship."
   → silence: "I decline to answer."
```

For chains, each link is verified separately and with a different
principal:

```
Jarvis's epithets: [(majordomo of Aifred), (assistant to Alice)]

Bob verifies link 1: E(aifredHandle).verify(jarvisHandle, "majordomo")
Bob verifies link 2: E(aliceHandle).verify(aifredHandle, "assistant")
```

A break at any link means the chain is not fully verified from that
point onward.
