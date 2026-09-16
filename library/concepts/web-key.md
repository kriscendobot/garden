---
id: web-key
aliases: ["web-key", "webkey", "web key", "webkeys", "capability URL", "capability-in-URL", "capabilities in URLs", "swiss number URL", "unguessable URL", "Waterken web-key", "https capability"]
topics: [capability-security, capability-theory]
---

# web-key

A **web-key** is Tyler Close's design (Waterken) for representing an object capability as an **unguessable HTTPS URL**: the secret, high-entropy portion of the URL (a "swiss number") *is* the capability, so possessing the URL authorizes the request and forging one is infeasible. Web-keys make ordinary web mechanisms capability-secure without new infrastructure — a link, a bookmark, or an XHR to a web-key is a capability invocation — and they are the web-facing instance of the founding-era distinction between an *off-line representation* of a capability (a storable, shareable string) and the *on-line protocol* that makes possession authorize invocation. Web-keys reframe several standard web vulnerabilities: because authority rides an unforgeable reference the holder deliberately conveys, rather than an ambient credential the browser attaches automatically (a cookie), CSRF/clickjacking/click-fraud lose their footing — those attacks exploit *ambient* authority, and a web-key has none to exploit. The unresolved practical tension is architectural: a capability whose whole representation is a URL is bookmarkable and linkable, but has nowhere stable to *live* in a browser session, so a web UI must decide deliberately where the user's root authorities (their powerbox) are held. Endo's OCapN keeps the same two-layer split — a durable locator/sturdyref you can store or paste, separate from the live CapTP protocol — so a shareable reference is a different artifact from live session authority.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix.md) | The paper's web-key fix: CSRF/clickjacking/click-fraud as confused-deputy instances, resolved by making the reference unforgeable, with no infrastructure change. |
| [cap-talk-2009-2012--webkeys-vs-the-web](../sections/cap-talk-2009-2012--webkeys-vs-the-web.md) | Chip Morningstar's powerbox-boot problem: where a browser holds authority when a capability *is* a URL (bookmarks/history/page state), and why a server-held powerbox breaks on navigation. |
| [cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable](../sections/cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable.md) | Zooko's aphorism: a CSRF attack is structurally identical to sharing, so make references unforgeable, not unshareable; a session cookie carrying authority is "in essence a webkey held in a cookie". |
| [cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol](../sections/cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md) | The founding-era split web-keys instantiate: a stored/serialized capability (representation) versus the live protocol (CapTP) that makes possession authorize invocation; Miller rates SPKI only "approximately a capability system". |
| [cap-talk-2013-2016--google-docs-share-links-as-webkeys](../sections/cap-talk-2013-2016--google-docs-share-links-as-webkeys.md) | Google Docs share-by-link shows webkeys are usable, while exposing the need for per-recipient facets, independent revocation, and browser-safe secret handling. |
| [cap-talk-2009-2012--hiding-webkeys-from-the-address-bar](../sections/cap-talk-2009-2012--hiding-webkeys-from-the-address-bar.md) | The April 2009 sharing hazard: authority-bearing webkeys must not appear in the address bar or page source, because users share URLs believing them inert; deliberate delegation should mint a fresh revocable key rather than expose the live one. |
| [web-powerbox-and-oauth](../sections/cap-talk-2009-2012--web-powerbox-and-oauth.md) | The powerbox introduces a requester to a provider by handing over a web-key scoped to one connection and revocable from one place. |
| [cookies-as-ambient-authority](../sections/cap-talk-2009-2012--cookies-as-ambient-authority.md) | Miller's terminology note: a web-key is not itself a cryptographic capability; 'treating URLs as capabilities' is the honest phrasing for unguessable-but-not-unforgeable secrets. |
| [cap-talk-2009-2012--authority-carrying-urls-in-the-wild](../sections/cap-talk-2009-2012--authority-carrying-urls-in-the-wild.md) | cap-talk 2010-October | Field evidence that authority-carrying URLs are mainstreaming (SIAM's password-equivalent login link), answering the habituation objection; a designed web-key improves on the ad-hoc persistent bearer URL by being scoped and revocable. |

## See also

- [[sturdyref]] — the durable, storable capability reference; a web-key is a sturdyref carried as an HTTPS URL.
- [[confused-deputy]] — CSRF/clickjacking/click-fraud are confused-deputy problems; web-keys remove the ambient authority the confusion exploits.
- [[powerbox]] — the trusted agent that holds a user's root authorities; the web-key-vs-web problem is "where does the powerbox live in a browser session".
- [[capabilities-vs-acls]] — the argument web-keys operationalize on the Web: designation fused with authority, not identity-plus-ACL.

## Common confusions

- **"An unguessable URL is just security-by-obscurity."** No — the unguessability is high-entropy unforgeability (a swiss number), the same property that makes any capability reference unforgeable; the secret is the credential, not a hidden location hoping not to be found.
- **"Web-keys must be kept secret and never shared."** The point (Zooko) is the opposite: web-keys are *meant* to be shareable — sharing a web-key is a deliberate capability delegation. The defense against CSRF is unforgeability, not unshareability.
