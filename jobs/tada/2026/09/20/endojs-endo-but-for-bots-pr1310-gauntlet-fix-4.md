The fix is pushed, CI is green, and the completion-summary comment is posted. Job complete.

---

**Completion report — FIX round 4, endojs/endo-but-for-bots PR #1310**

Applied the panel round-4 must-fix items to `EndoGuest.accept` / `acceptInvitation` (head `c1dd1eb67` → `bc304a241` on `endojs:bot/build/guest-native-accept`):

- **assessor** — closed the unprotected speculative-rollback window: wrapped the entire fallible span (handle-locator build, `getAllNetworkAddresses`, correspondent bind, `provide`, accept) in one try/catch that always retracts both the peer route and the correspondent bind on any failure.
- **saboteur/breaker/engine-realist** — bounded the two network-crossing steps inside the daemon-wide `acceptInvitationJobs` lock with a new `acceptInvitationNetworkTimeoutMs` (2 min), so a hung/malicious inviter can no longer wedge every agent's accept. Kept the queue daemon-wide by design (narrowing reopens the same-peer clobber race) and documented why.
- **breaker/wire-watcher** — made the inviter-side `Invitation.accept` agent-key write additive-only (`getRemoteAgentKey(...) === undefined`), stopping a bearer from redirecting a known correspondent's route; added input-edge validation of `guestHandleNode`.
- **prover** — added a multiplayer-suite test giving both sides reachable `@nets` so the same-daemon skips are the only thing keeping the peer store empty (**verified load-bearing**: removing either skip reddens it); reframed the same-daemon duplicate-accept test to claim the outcome it pins, not the serial queue.
- **changeset-auditor/releaser/pruner** — trimmed the changeset to user-facing guarantees; **typist/duality-auditor/surfacer** — documented the intentionally-unrenamed persisted `InvitationFormula.guestName`.

Local checks (tsc src+tests, eslint 0 errors, prettier, affected same/cross-daemon accept tests) all green before push. CI to terminal: **GREEN** — 32 checks, 0 failed (rc 0). Completion-summary comment posted (`#issuecomment-5747241522`).

Deferred (not must-fix, noted in the PR comment): wire-watcher #2 / engine-realist #1 should-fix concurrency/durability edges; a direct cross-daemon test for the inviter-side agent-key redirect guard (no public `remote_agent_key` read surface). The driver will re-post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 166 tokens (12692787 cached reads)
- Output: 83531 tokens
- Cost: $10.7096315
- Wall-clock: 2373s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
