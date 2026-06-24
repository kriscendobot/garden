---
title: §Two-modes-of-weblet-hosting (designated-port + virtual-host)
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

§Two-different-modes-for-two-different-clients:

| Mode | Client | URL form |
|------|--------|----------|
| Designated-port | Conventional browser | `http://127.0.0.1:<port>/<accessToken>/` |
| Virtual-host | Familiar's `localhttp://` | `localhttp://<accessToken>/path` |

§Borrowable-pattern: §the-same-content-served-two-different-ways for §two-different-client-capabilities. §The-Familiar-can-receive-`localhttp://` + §a-regular-browser-cannot. §Two-clients-with-different-URL-handling-each-get-the-URL-form-they-support.

### §Caveat-emptor-disclosure for the conventional-browser mode

> This gives conventional browsers a navigable URL. Caveat emptor — there is no `localhttp://` origin isolation in a regular browser. The access token (first 32 characters of the weblet's formula ID) provides URL-level access control but not same-origin isolation between weblets.

§Honest-disclosure-named-`Caveat-emptor`. §Borrowable-pattern: §when-a-feature-has-a-known-trade-off + §the-trade-off-can-be-acceptable-for-some-users + §but-cannot-be-removed, §the-design-document-names-it-`Caveat-emptor` and §discloses-the-specific-limitation.

§Sibling to cycle 218's §`@host`-explicitly-labeled-development/trusted-only (similar shape — §named-warning-on-a-less-safe-mode).

§Three-different-shapes-for-honest-disclosure-of-a-known-trade-off in library:
- Cycle 218 (familiar-chat-weblet-hosting): §`@host`-explicitly-labeled-development/trusted-only.
- Cycle 220 (familiar-localhttp-protocol): §Research-needed-section as honest-acknowledgment-of-incomplete-verification.
- Cycle 224 (daemon-web-gateway): §Caveat-emptor-disclosure for the less-safe mode.

§Three-different-rhetorical-shapes for §the-same-underlying-discipline: §be-honest-about-the-limits.
