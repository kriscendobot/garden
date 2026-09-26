## Completion report

**Job:** `endo-guest-invite-accept-design` (designer). Designed the Endo daemon API for guest-native invitation acceptance on `endojs/endo-but-for-bots@llm`.

**What I did:**
- Researched the current invitation mechanism end to end: `host.invite`/`host.accept` (`src/host.js`), the agent-agnostic `formulateInvitation` and the `makeInvitation` exo (`src/manager.js`), the `Invitation` locator grammar (`src/locator.js`), the mail substrate (`src/mail.js`), guest construction and its attenuated special-name namespace (`src/guest.js`, `src/pet-sitter.js`), formula/crash-recovery makers, and the retained invitation test suites. Confirmed no prior guest-invite work exists.
- Fetched the motivating dependency: kriskowal's review comment `r3909478669` on minion.town PR 56 ("Guests must be able to invite and accept") and its `invitation-only-guest-onboarding.md` guest-to-guest onboarding model, which currently forces the app to act as a host-authority membrane.

**What changed (draft PR [endojs/endo-but-for-bots#1116](https://github.com/endojs/endo-but-for-bots/pull/1116), base `llm`, diff = design files only):**
- New `designs/guest-native-invitations.md`: adds `guest.invite(guestName)` / `guest.accept(invitationLocator, hostName)` as a shared agent vocabulary; specifies reciprocal exchange of each agent's **own handle** with **no replacement guest minted**; independently chosen pet names; same-daemon vs cross-daemon flow; authority attenuation via a narrow injected `registerPeer`/`writeRemoteAgentKey` daemon-core capability (so `GuestInterface` gains only `invite`/`accept`, not public peer methods, and the `EndoHost` cast inside `makeInvitation` is removed); consume-once/cancellation via the invitation controller's `cancelled` signal under the formula-graph lock; concurrency; crash recovery; a concrete implementation sketch; and a test plan retaining the existing host/cross-daemon suites while adding guest-native and transitive-chain cases.
- Added the summary-table row to `designs/README.md`.
- One mermaid diagram, validated parse-OK via `mermaid.parse` (`OK flowchart-v2`).

**Open questions surfaced for the maintainer:** host-path convergence onto the no-mint model; what the vestigial `@pins/guest-*` mint protects; mid-accept idempotent recovery ordering; prior-incarnation revocation across restart (the current `makeInvitation.accept` TODO); and whether guest-triggered peer registration needs bounding.

**Follow-ups:** The design's implementation is a separate builder dispatch (design and implementation are separate PRs with different bases). The PR is left **draft**; its design-panel gauntlet is staged automatically by the completion machinery from this named PR — I did not un-draft it or hand-post a gauntlet job.

**Self-improvement:** nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-guest-invite-accept-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3748094 cached reads)
- Output: 31373 tokens
- Cost: $6.311952999999998
- Wall-clock: 901s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
