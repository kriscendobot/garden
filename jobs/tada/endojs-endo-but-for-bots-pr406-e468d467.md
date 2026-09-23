The designer job is already **claimed and in progress** — `cleric-6` on host `endolin-garden2` picked it up (it's in `jobs/doin/`). The routing is live and being worked.

My attention/triage job is complete. No garden-library or project-code changes were required (this was a route-the-directive job), so nothing to commit to `main2`; my worktree stays clean.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots **#406** (which is an **issue**, not a PR: *"OCapN/Noise: accept pre-read frames at session init (gateway hack carrier)"*).

**Preflight:** `pr-feedback-preflight.sh … 406 5010306281 kriskowal` → exit 0 (no peer resolution; proceed). Inbox empty at claim and at final drain.

**What the directive said (re-fetched, treated as untrusted data):** kriskowal, on issue #406 — *"Let's go farther and lower the responsibility for peer authentication and encryption to the network layer, such that the ed25519 public key is the only material that passes down for connect and up for accepting a session."* This is a **design refinement** that supersedes the issue's original mechanical `handleIncoming({ stream, prefixedSyn? })` proposal (which still leaks Noise frame bytes across the layer boundary).

**How I routed it** (the "attention → route to the right work" deliverable), grounded in the PR #392 head tree (`design/gateway-package-phase-4`):
1. **Posted a designer job** — `design-ocapn-noise-key-only-session-boundary` (identity `endojs/endo-but-for-bots#406:design-key-only-boundary-followup`) — to produce a reviewable design of the ed25519-key-only session boundary: connect-by-key (already close, via `runInitiator(peerEd25519,…)`) and accept-yielding-key (moving responder-selection + authentication into the network layer so the gateway never peeks at/replays the SYN), deleting `prependFrame`, the Far-tagged reader dance, and the gateway's manual prefix parse — while preserving the every-responder blast radius and the per-identity DoS cap in `handleIncoming`. This job is now **claimed and in progress** (`cleric-6` on `endolin-garden2`).
2. **Posted the follow-up comment** on issue #406 (honoring the bot's auto-ack promise to "follow up here when it lands"): https://github.com/endojs/endo-but-for-bots/issues/406#issuecomment-5010325357 — synthesizing the direction, noting it supersedes the `{stream, prefixedSyn?}` shape, and stating that a design pass (not a build) is queued for kriskowal to steer.

**Board hygiene:** confirmed no pre-existing live job targeted issue #406 before posting (tada matches were coincidental substrings); the `eyes` reactji was already posted by the triager at notice time, so I did not re-react.

**Changes:** no garden-library or project-source mutations (triage/route job). Worktree clean, nothing to push to `main2`.

**Follow-ups:** the design PR from `design-ocapn-noise-key-only-session-boundary` will surface on issue #406 for maintainer review; no build should proceed until that design is steered/landed.
