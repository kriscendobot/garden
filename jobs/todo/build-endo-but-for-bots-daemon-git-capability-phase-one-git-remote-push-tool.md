---
role: builder
---

Build Phase 1 of the accepted git-capability stack (endojs/endo-but-for-bots, sequenced by design PR #691 / daemon-git-next-steps § Phased Build Plan): implement `makeGitRemoteTool(remoteCap)` exposing `fetch`/`pull`/`push` agent tools bounded entirely by the granted `GitRemote` capability, building on the landed `@endo/agent-tools` daemon-agent-tools § Phase 3 substrate, and open a mergeable feature PR.
