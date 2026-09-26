Done. Postmortem posted to issue #22; no follow-on jobs needed.

## Completion report

**Job:** issue-kriskowal-garden-22 — "Postmortem YMax upgrade debug" (kriskowal/garden#22). The issue asked to summarize what was learned from the ymax0 v320 upgrade-debug engagement and what skills were created, with links. This is the formalized twin of the same request left on [issue #9](https://github.com/kriskowal/garden/issues/9#issuecomment-4870104413) ("RSVP").

**What I did:**
- Reconstructed the engagement from issue #9 (82 comments), the `agoric-chain-snapshot` skill, its repro drivers, the capture scripts, and the git history of those artifacts.
- Posted a postmortem **comment** to issue #22 → https://github.com/kriskowal/garden/issues/22#issuecomment-4870384098 (did **not** close it — submitter closes when satisfied).

**What the postmortem covers (with links):**
- **Root cause:** value-stack *width*, not depth — a wide `.flatMap(...)` in `@agoric/internal/src/hex.js` materializes ~1,024 reference slots and overruns XS's 4,096-slot value stack during bundle import.
- **Fix:** rewrite that one `flatMap` to a `new Map` + `for` + `.set()` loop; also documented the taller-`stackCount` alternative (and that it doesn't break snapshots) plus the residual functor-baseline caveat.
- **Real-chain confirmation** via `inquisitor` on a captured Polkachu mainnet swing-store (`agoric-26146641`) through three vectors (createVat A/B, EV-direct, full contract-control protocol), plus mhofman's corrections (devnet origin, install-first, live v290/v288 vs stale bootstrap v275 kit).
- **Artifacts created:** the [`agoric-chain-snapshot` skill](https://github.com/kriskowal/garden/blob/main2/skills/agoric-chain-snapshot/SKILL.md), the two `scripts/agoric/` capture scripts, the durable [`repro/` drivers](https://github.com/kriskowal/garden/tree/main2/skills/agoric-chain-snapshot/repro), and the bot-fork work (`kriscendobot/agoric-sdk#7` fix, #6 methodology/instrumentation, inquisitor overlay fix).

**Changes to the garden:** none required — this was a summarization job; nothing committed to `main2`.

**Follow-ups:** none. The submitter (kriskowal) closes the issue when satisfied.
