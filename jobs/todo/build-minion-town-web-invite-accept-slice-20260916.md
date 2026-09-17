---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
handler-timeout: 10800
---
Build the minion.town WEB invite/accept workflow slice. MAINTAINER DIRECTIVE
(kriskowal, 2026-09-16): go straight to the build — no new design pass first.
Build against the merged design and treat the elements below as the maintainer's
stated intent, which the existing designs only partly record.

## The intent, in the maintainer's own framing

"Any party can visit minion.town and construct an invitation to connect to any
other party in the network, not even necessarily on minion.town. That would
involve a locator URL with a connection hint or hints that would enable
minion.town to establish an ocapn-np-cbor connection, or just create a pet name
for a local formula in place. This would allow guests on minion.town to connect
over simple HTTP, just using their own guest formula identifier as a bearer token.
We capture the guest formula identifier in local storage and also enable the user
holding the guest formula identifier to authenticate with oauth, thereby
establishing a path to recover their guest formula if they move to another host or
lose their identifier. Then introduction becomes trivial to evaluate through a web
workflow, and eventually through an endo CLI invite/accept workflow as well, via
remote control over ocapn-np-cbor."

## What is already recorded (build ON this, do not re-decide it)

`designs/invitation-only-guest-onboarding.md` — design PR kriscendobot/minion.town#56,
MERGED and APPROVED — already establishes the two load-bearing invariants:
- The guest formula identifier IS the credential. "Anyone who possesses a live
  guest formula identifier can connect as that guest." The account row is not the
  credential.
- OAuth is "an optional recovery bond", NOT the admission path. No prior OAuth
  redirect, issuer/subject derivation, or scope grant in the invitation path.
- Pet names are chosen independently by the two parties, are not globally
  meaningful, and are not app-generated. Changing one does not change either
  party's formula identifier.

## What is NOT recorded, and is the substance of this build

1. ANY-PARTY-TO-ANY-PARTY. Both existing designs are narrower than the intent:
   #56 admits a guest TO minion.town; `designs/remote-guest-endo-cli.md` connects
   ONE member's guest to ONE remote Endo daemon. Neither describes any party
   constructing an invitation to any other party in the network, including parties
   not on minion.town. Build the general case.
2. TWO INVITATION SHAPES, and picking the right one is the crux:
   (a) REMOTE — a locator URL carrying a connection hint or hints, from which
       minion.town establishes an ocapn-np-cbor connection to the other party.
   (b) LOCAL — when the other party is already on minion.town, do NOT establish a
       network connection at all: just create a pet name for a local formula IN
       PLACE. This case needs no introduction protocol.
   The local case is the one that collapses the blocker evaluation 7 hit (below),
   so make sure it genuinely short-circuits rather than tunnelling through (a).
3. SIMPLE HTTP, BEARER TOKEN. Guests connect over plain HTTP using their own guest
   formula identifier as the bearer token. The recorded designs route through MCP
   and CapTP; this is deliberately the lower-friction browser path. Reckon with
   what it means to put a credential in an Authorization header: transport
   security, logging/exfiltration exposure, and revocation.
4. LOCALSTORAGE + OAUTH RECOVERY. Capture the guest formula identifier in
   localStorage, and let the holder authenticate with OAuth to establish a recovery
   path for the identifier if they move to another host or lose it. Per #56, OAuth
   is the recovery bond only — never the admission gate.

## Why this is now buildable

- endojs/endo-but-for-bots#340 (OCapN-Noise daemon-to-daemon transport) MERGED
  2026-08-25. The transport for (a) is live.
- endojs/endo-but-for-bots#1125 (guest-owned invitation primitive) is in a parallel
  fix job (`fix-ebfb-1125-guest-invitation-primitive-20260916`). It is the
  guest-OWNED invitation the remote case needs. Where you depend on it, say so
  explicitly and degrade gracefully rather than blocking: the LOCAL case (2b) and
  the HTTP/localStorage/OAuth-recovery work (3, 4) should not need it.

## Reconcile with work in flight — do not duplicate

- kriscendobot/minion.town#81 ("Build: capability-first guest onboarding — browser
  core slice") is an OPEN DRAFT covering browser-core groundwork, untouched since
  2026-09-02. READ IT FIRST. Either extend it or state plainly why a separate PR is
  the better vehicle. Do not silently re-implement it.
- kriscendobot/minion.town#95 ("docs: design MCP guest surface documentation
  contract") is the evaluation campaign's synthesis and already specifies
  host-mediated peer introduction. Check your approach against it.

## Acceptance

Evaluation 7 (`minion-town-eval-mail-pair`) failed with exactly the gap this build
closes. Its finding: "`send` permits only `@self`, `@host`, or a pet name you hold
for another party — and there is no guest-surface route to acquire that pet name.
Two fresh guests cannot introduce themselves." It also needed a human GitHub
federation login to mint a second identity.

The slice is done when two guests on minion.town can introduce themselves to each
other THROUGH THE WEB WORKFLOW and exchange mail, with no host-side manual
introduction and no human browser login in the middle. Demonstrate it end to end
and include the transcript. That is the evaluation's own bar, met.

Do not touch agoric/agoric-sdk. Follow skills/local-verify and the pre-push gates.
If the work does not fit one handler, SPLIT it and say so rather than overrunning.

<!-- garden-reaped: 0 -->
