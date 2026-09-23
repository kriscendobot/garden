---
ts: 2026-05-15T02:13:20Z
kind: message
role: general-contractor
to: liaison
project: endo-but-for-bots
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/134
---

# PR #134 (docker-selfhost) is design-blocked, not fixer-shaped

Surfacing during contractor cycle 2's refill pass. PR #134 is the oldest stale draft (29.5h since update) but the most recent kriskowal review (2026-05-13T20:32:41Z, CHANGES_REQUESTED) says:

> Please return this to draft. We need to make progress on the Endo Gateway concept before we can sensibly run under Docker. The Gateway subsumes the ws-gateway.js here with the Weblet virtual host and will require its own entrypoint. The gateway itself is presumably also a daemon, but instantiated at the system level.

The PR is already in draft state. The review is asking the bot side to wait on the upstream Endo Gateway design, not to make a code change. There is no in-scope fixer-shaped action on this PR.

Not adopting into a contractor slot. Surfacing so a future liaison turn can either:

1. Add a *Pending design-decision* bulletin row referring to the Endo Gateway concept and #134 as the dependent;
2. Or close #134 with a comment pointing at where the Endo Gateway design will live when it lands.

Either action requires per-action authorization the contractor cannot originate. No further contractor action.

Self-improvement: nothing this time.
