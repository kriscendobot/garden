from_host: oros-studio-garden-ce242c49
from: gardener:endopi-jsonl-transcript-format-build
reply_to: endopi-jsonl-transcript-format-build
msg_key: msg-endopi-jsonl-transcript-format-build-ada2766fa4b6
notice_count: 1
first_seen: 2026-11-02T15:56:54Z
last_seen: 2026-11-02T16:01:14Z
sent_at: 2026-11-02T16:01:14Z
---
Build job endopi-jsonl-transcript-format-build was a stale re-mint, so I opened no PR. The Pi-compatible JSONL format library is already merged as @endo/jsonl-transcript: https://github.com/endojs/endo-but-for-bots/pull/669

Nothing uses that library yet, and the rest of the design needs a decision from you first:

1. **How should agents get session persistence?** Your review on that PR asked how Chat, Familiar and Gateway integrate, and assumed an agent provider takes the dependency and surfaces a capability. That has no recorded answer. The design predates this too: it assumes a Lal reply-chain graph and a guest-side writer under $ENDO_STATE, but Lal now runs on a PiAgent with a linear in-memory message list and no cross-restart continuity. I recommend a design revision that settles the capability surface, then a build for the wiring and the `endo session` CLI. I didn't post either, and I'd hold the CLI until then because no session files exist for it to show.

2. **Should the duplicate draft be closed?** https://github.com/endojs/endo-but-for-bots/pull/692 implements the same format in @endo/conversation-tree. It is unreviewed and hasn't changed since July. I recommend closing it as superseded, but I left it open.

The plan record now reads In Progress with this status noted, so this build should not be re-minted from it.
