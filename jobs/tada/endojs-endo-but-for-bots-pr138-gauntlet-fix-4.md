All five checks (browser-tests, build, lint, test, zizmor) pass on my pushed head `d387bf2f7`. CI is GREEN.

## Completion report

Applied the design-panel **round-4 must-fix** items to `designs/ocapn-daemon-integration.md` (PR #138), pushed as follow-up commit `d387bf2f7` to the PR head `endojs:design/ocapn-daemon-integration`, and watched CI to terminal — **all checks green**.

**Must-fix items applied (all four request-changes seats):**

- **critic / skeptic — missing `Updated` field** [designs/AGENTS.md]: added `| **Updated** | 2026-08-31 |` to the frontmatter and corrected the `designs/README.md` table row (was understated at `2026-05-07`).
- **critic — SNI-preamble metadata leak**: added an explicit *Tradeoff* paragraph stating the routing preamble exposes the target Ed25519 identity in cleartext, and why the leak is accepted (under Noise IK the initiator must already know the responder key out-of-band; routing visibility ≠ routing authority; hiding it is an `ocapn-noise-network` wire-format concern out of scope here).
- **skeptic — incomplete caller inventory**: corrected the claim (verified: `manager.js` has *zero* literal `@nets` refs — `makePeer`/`getAllNetworkAddresses` take `networksDirectoryId`), added the four host-privileged `@nets` write sites in `packages/spaces-util/src/command-executor.js` (the `/network*` chat commands) to the cutover and to *Affected Packages*, and showed the grep scope.
- **skeptic — Test Plan gaps**: added entries for Design Decision #5 (`outboundPolicy` matcher), #6 (unregistered scheme throws), #9 (delegated subagent: forked identity + liveness/revocation split), #11 (policy update preserves identity), and `registerNetwork` privilege separation.
- **decomplector — identity/policy complected**: added host method `updateTransportsPolicy(petName, policyPatch)` and Design Decision #11 — policy is revised without regenerating identity; re-`provideTransports` on an existing petName **rejects** rather than silently re-minting.
- **ergonomist — three interface ambiguities**: resolved `connect`'s `{ hints? }` vs the locator's embedded hint (caller-first override of the hint only, never the routing key); stated that `disconnect`'s handle *is* a `Session`/`Listener`; bound CLI `add` → `listen()` and named the delegation surface (`provideTransports` with `delegateFrom`; `endo mkguest --transports-from`).

Comment-only findings (copyeditor double-colon/jargon-order, pedant slash-spacing/list-parallelism, novice forward-refs) were left as-is per the must-fix scope.

**Follow-ups:** none — the driver re-posts panel-5 next. CI green on `d387bf2f7`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 88 tokens (3403781 cached reads)
- Output: 25138 tokens
- Cost: $3.6811325
- Wall-clock: 498s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
