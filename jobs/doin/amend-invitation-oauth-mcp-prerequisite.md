---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Maintainer directive (2026-09-02, liaison session): amend the minion.town
invitation/acceptance workflow documentation, and the actual invitation
page's copy, to disclose plainly that MCP access is not available until a
guest has completed its first OAuth bonding.

## What's actually true today versus what's designed for later — verify,
## don't assume this framing is complete

There are two overlapping designs in `designs/`, and this amendment must be
precise about which one describes *today's live behavior*:

- `designs/mcp-endo-guest.md` (2026-07-09, "design only; no live change" —
  but its Gate 1 acceptance criteria V2/V3 require the Claude/MCP surface to
  complete the full Cognito **GitHub-federated OAuth 2.1 PKCE** browser flow
  before any guest tool works at all: the app derives and auto-provisions
  the guest from the verified `iss+sub` identity *at that point*, and no
  guest formula identifier exists as an independent, user-held credential
  before it). This is, as far as the liaison can tell from the design
  corpus alone, the model actually governing production right now.
- `designs/invitation-only-guest-onboarding.md` (2026-08-27, substantially
  revised 2026-09-01, also "design only; no live change") explicitly plans
  to **retire** this: its § 5/§ 6 make OAuth a purely optional *recovery*
  bond, with a guest formula identifier as the sole admission credential,
  independent of any OAuth flow. Its own § 9 lists eleven build gates that
  must all be evidenced before "the production admission flip" happens, and
  states plainly: "until the capability path is proven and the migration
  below is complete, the current production path stays live."

**Confirm which model is actually deployed right now** (read `DEPLOYMENT.md`'s
phase log, the live `src/` code, and if useful a real smoke test) before
writing anything — don't take the liaison's read of the design corpus as
settled fact. If it turns out the invitation-only model has already partly
shipped, the amendment below needs to say something different than assumed
here.

## The amendment needed (assuming the mcp-endo-guest.md gate model is
## indeed still live)

1. **In `designs/invitation-only-guest-onboarding.md`** (or wherever is most
   accurate once confirmed above): add a clear, unmissable call-out —
   someone reading that design cold could easily assume its "OAuth is
   optional" model already describes production. State plainly that this
   is **not yet true**: today, MCP access still requires completing the
   OAuth/GitHub-federated bonding first, per `mcp-endo-guest.md`'s Gate 1,
   until this design's own § 9 build gates are satisfied and the admission
   flip happens. This amendment does not propose changing the future
   direction — OAuth becoming an optional recovery bond stands as designed
   — it's purely about not letting a reader mistake the target state for
   the current one.
2. **On the actual invitation/acceptance page** (the real UI, not just the
   design doc): check whether the current copy already discloses that MCP
   access requires completing sign-in first. If it doesn't — which is the
   liaison's working assumption, prompted by exactly this confusion while
   debugging an unrelated MCP session failure this session — add clear,
   honest copy near wherever a new guest would first try to connect an MCP
   client (or accepts an invitation), stating plainly that MCP support
   becomes available after the first OAuth bonding, before they hit a
   confusing failure. Keep the wording precise about *why* (guest
   provisioning is currently derived from the OAuth identity, not a
   free-standing credential yet) rather than vague.

## One more thing worth checking while in here, not the main point of this
## job

The liaison's own bot session (`kriscendobot`) hit a "No valid session; send
initialize first" error against `mcp__minion-town__*` tools this session,
and a re-authentication (`claude mcp login minion-town`) is in progress.
Whether `kriscendobot`'s own guest has actually completed an OAuth bonding
under the *current* live gate model is a plausible, unverified contributor
to that failure — worth a quick look if it's cheap to check from inside
this job, but don't let chasing it expand this job's scope; the
documentation/copy amendment is the actual deliverable.

## Land it

Standard PR against `kriscendobot/minion.town`'s `main`, in this repo's own
design-doc convention (`Created`/`Updated`/`Author`/`Status`/`Mandate`/
`Grounded against` header — see `designs/mcp-endo-guest.md` for the fullest
example of that shape) for the design-doc portion, plus the page-copy change
in the same PR if it's a small, localized addition — per this repo's rule
that design docs land as PR review while small config/copy fixes may land as
direct commits where pre-deploy review isn't needed; use your judgment on
whether this specific copy change warrants review given it's user-facing
product text, not build/config.










<!-- garden-reaped: 4 -->

<!-- garden-transient-elapsed: kind=signature through=4 values=2 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-02T21:27:05Z
