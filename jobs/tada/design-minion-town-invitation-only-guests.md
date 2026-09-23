The PR is a clean single-file draft. The design is complete and delivered on a review surface.

## Completion report

**Job:** `design-minion-town-invitation-only-guests` — design an invitation-only guest-onboarding system for `kriscendobot/minion.town`.

**What I did**
- Read the referenced prior art on `endojs/endo-but-for-bots` @ `llm` (`packages/cli/src/commands/invite.js`, the `host.invite`/`host.accept` surface in `packages/daemon/src/host.js`, `invite-retention{,-ocapn}.test.js` and their multiplayer suite, and `designs/familiar-deep-link-invitations.md`) plus the live minion.town surface (`src/endo/{guest-control,guest-tools,root-control,identity}.ts`, `src/auth/accounts.ts`, and the existing designs `account-creation-open-signup.md`, `mcp-endo-guest.md`, `mcp-daemon-guest-tools.md`).
- Wrote `designs/invitation-only-guest-onboarding.md` (254 lines) and opened it as **draft PR kriscendobot/minion.town#56** against `main` (the repo's design-PR-review norm), via `ensure-pr.sh` under the durable job marker.

**Key design decisions**
- **Explicit reconciliation with open-signup:** the design *supersedes* `account-creation-open-signup.md`'s auto-provision mandate — a guest is provisioned only on **invitation redemption**, not on bare first request. The account store, the authentication-only web gate (no bare 403s), and the styled surfaces are retained; the two do not coexist as rival admission policies. A `Superseded by` note lands on the old design at gate-flip time. The one coexistence option (a zero-authority lobby) is flagged as open question Q1 with a recommend-against.
- **Composes with the real daemon `invite`/`accept`** rather than a bespoke mechanism: redemption binds the mutual inviter↔invitee handle exactly as the retention tests prove; mailbox `send`/`adopt` carries introductions, making the invite graph navigable/social.
- **kriskowal-as-root** reuses the existing `root-control.ts` `bindRoot`; the invite/introduce surface extends the one facet grant site with new cap-shaped (never scope-shaped) tools. The web invite link is framed as the browser analog of the familiar `endo://invite/` deep link + consent/naming screen.
- Metering and per-guest invitation-count limits are held out of scope with their seams named, per the mandate.
- Both mermaid diagrams validated parse-only (`mermaid.parse`: flowchart-v2 + sequence, both OK).

**PR state (verified):** #56 is draft, single-file diff (`designs/invitation-only-guest-onboarding.md`, +254). Left draft so the completion machinery auto-stages its design-panel gauntlet.

**Follow-ups:** five maintainer-facing open questions in § 9 (lobby-open?, members-as-guests vs promote-to-host, revocation cascade depth, kriskowal member-agent bootstrap timing, invite-token store durability). No successor jobs posted — implementation waits on maintainer review of the design.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-invitation-only-guests.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (3464324 cached reads)
- Output: 30042 tokens
- Cost: $3.741079000000001
- Wall-clock: 482s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
