CI is GREEN. The fix stage is complete.

## Completion report

**Job:** kriscendobot/minion.town PR #60 gauntlet — FIX round 2.

PR #60 is a **design document** (`designs/remote-guest-endo-cli.md`, "connect a local Endo CLI to one minion.town guest"). I applied the panel-2 request-changes must-fix items in one pass, verifying each claim against the live `src/endo/guest-control.ts` before editing (the panel cross-checks source):

- **critic** — `guest_invite` was proposed as an unconditional baseline grant despite being the first guest power that opens an outbound OCapN/Noise correspondent *outside* minion.town. Rewrote §4 to specify it as **structurally gated behind a deployment-wired `inviterFor`**, mirroring the existing `sites`/`publisherFor` precedent, with an explicit rollout path (no broker wired → no `guest_invite`; per-deployment toggle, not per-identity, so the ocap directive still holds).
- **skeptic** — (1) the `expiresAt` rationale falsely claimed the ttl-cache (epoch-ms) and JWT `exp` (`verifier.ts:90`, RFC 7519 epoch-seconds) fields agree; corrected to anchor on the ttl-cache ms convention alone and warn the two fields don't share a unit. (2) Added the missing MCP acceptance test for §3-point-2's accept-time name-collision **rejection** path.
- **decomplector** — gave the invitation its own lifecycle identity: `invitation.cancel()` on the Endo object (§3) and `inviteId` + `cancel(inviteId)` on the MCP `RemoteInviteFacet` (§4), so revoke routes through the value in hand and `localPetName` does naming only.
- **ergonomist** — renamed the returned string field `invitation` → `locator`, matching every prose reference and the sibling `*Result` facets.
- **pedant** — rewrote spaced double-hyphens as parentheses/colons; lowercased the §4 heading to `minion.town`.
- **novice** — glossed "guest" in the Mandate; added an `EndoHost`/`EndoGuest`/`EndoAgent`/`GuestAgent`/`GuestFacet` mapping sentence at first co-occurrence; named the master-pin precedent instead of gesturing at it.
- **copyeditor** (comment-only, applied) — fixed "directed for", the ambiguous "its", "proceed against the assumption", and "assumed mechanical".
- Kept the doc **em-dash-free** (the original had zero; my initial rewrites introduced 13, all recast to periods/parens/colons before commit), plus enumerated the `resolve`/`dismiss` mailbox verbs and gated the weblet power on a wired publisher (skeptic/critic notes).

Committed as review-feedback follow-up `69ee51b` and pushed to the PR head via `safe-push-pr-head.sh` (advanced `2100a3c..69ee51b`, no rewind). Bounded CI wait returned **rc 0 (GREEN)**.

Follow-up: none required for this stage. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr60-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3033353 cached reads)
- Output: 30481 tokens
- Cost: $3.128699499999999
- Wall-clock: 486s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
