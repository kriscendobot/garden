---
id: ambient-authority
aliases: ["ambient authority", "ambient authorities", "ambient capability", "ambient permission", "ambient user authority", "identity-based authority", "no-credential authority", "undesignated authority"]
topics: [capability-theory, capability-security]
---

# ambient-authority

Authority a subject can exercise **without designating it** — without naming, presenting, or passing the specific capability the action requires. The June 2009 cap-talk "define ambient authority for Wikipedia" thread ([defining-ambient-authority](../sections/cap-talk-2009-2012--defining-ambient-authority.md)) worked the definition to its sharpest form and rejected two weaker candidates: it is *not* simply "authority shared with all programs" (too narrow to fit usage) and *not* simply "authority exercised without any credential" (that collapses into *identity-based authority*). The discriminator the thread settled on is **designation**: authority is ambient exactly when the requesting party is "not required to explicitly designate the specific authority by which it requests an action," so the required authority is *inferred* — from access-control information, from the caller's identity, from a helper that automatically searches the caller's credentials for one that permits the request (Kerberos ticket caches, `sudo`, the browser auto-attaching cookies). Mark Miller's compact operational form: "if a requesting entity requests an action that it is permitted to perform, then the action is allowed." Ambient authority is the root cause of the confused deputy (the deputy wields authority it holds ambiently, unable to tell on whose behalf it should apply it), and eliminating it is the defining move of the object-capability model, where authority travels *with* a designated reference and a subject holds only what it was explicitly given. Note that even object-capability systems retain *some* ambient-authority pockets — root objects, the powerbox, and Non-Delegatable Authorities — which is why "reduce" and "eliminate" are distinguished carefully in practice.

## Why designation is the discriminator

The competing definitions differ operationally. Under "shared with all programs," a per-user permission is not ambient; under "no credential," presenting a token escapes ambient authority. Both miss the real hazard: a system that *presents tokens* still has ambient authority if a "helper" facility automatically selects which token to apply, because the caller never designated which authority it meant to exercise. The designation reading captures exactly this — the SETUID bit, the cookie jar, the ambient filesystem namespace a path string is resolved against — and it is the reading that maps cleanly onto "make authority travel with the reference." When authority must be designated, excess authority becomes visible at the call site; when it is ambient, excess authority is the invisible default that every deputy must be coded to guard against.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [defining-ambient-authority](../sections/cap-talk-2009-2012--defining-ambient-authority.md) | The 2009 encyclopedia thread; three candidate definitions (shared-with-all, no-credential, not-designated); the "helper facility" that recreates ambient authority atop tokens; Miller's compact operational form. |
| [origin-header-amplifies-ambient-authority](../sections/cap-talk-2009-2012--origin-header-amplifies-ambient-authority.md) | Miller's critique that CORS/Origin access decisions amplify ambient authority and confused-deputy hazards; "a mashup is a self inflicted cross site script"; all scripts on a page share the page's origin authority. |
| [reducing-ambient-user-authority-install-manifest](../sections/cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md) | An install-time authority manifest and a console-free OS (no string→filename→capability resolution); the App→User→Group→Everyone escalation ladder; the unresolved "reduce vs eliminate" gap where consent prompts habituate re-granting. |
| [what-is-hardenedjs](../sections/endo--docs-guide--what-is-hardenedjs-ses-endo--what-is-hardenedjs.md) | Hardened JavaScript removes ambient authority from the JavaScript environment — frozen primordials, no ambient IO, modules receive only endowments explicitly passed — the enacted form of ambient-authority elimination. |
| [cors-open-review-and-ambient-cookies](../sections/cap-talk-2009-2012--cors-open-review-and-ambient-cookies.md) | CORS preflight protects legacy request shapes but does not remove automatically attached ambient cookie authority. |
| [geolocation-origin-authority-and-ui](../sections/cap-talk-2009-2012--geolocation-origin-authority-and-ui.md) | Origin-persistent geolocation is ambient authority; a visible page-lifetime facet narrows and revokes it. |
| [cookies-as-ambient-authority](../sections/cap-talk-2009-2012--cookies-as-ambient-authority.md) | RFC 6265's own security-considerations text names cookies a form of ambient authority: the browser attaches them without the requester designating them, so server and client become confused deputies. |
| [mutable-singletons-are-ambient-authority](../sections/cap-talk-2009-2012--mutable-singletons-are-ambient-authority.md) | A mutable globally-accessible singleton is ambient authority by construction; only mutable ones are harmful, which is why frozen (constant) primordials are fine. |
| [web-powerbox-and-oauth](../sections/cap-talk-2009-2012--web-powerbox-and-oauth.md) | OAuth's redirect dance actively depends on ambient authority via cookies; the powerbox replaces it with a per-connection capability the browser holds. |

## See also

- [[confused-deputy]] — the canonical failure that ambient authority causes: a deputy holds authority ambiently and cannot wield it selectively on the right principal's behalf. Eliminating ambient authority (authority travels with designation) is the structural fix.
- [[principle-of-least-authority]] — POLA is unachievable in the presence of pervasive ambient authority; least authority requires that every authority be designated and granted on a need-to-do basis.
- [[object-capability]] — the substrate that eliminates ambient authority by construction: no designation, no authority.
- [[powerbox]] — the deliberate, user-mediated re-introduction of authority into an otherwise ambient-authority-free application; the controlled exception, not the ambient default.
- [[web-key]] — the web-facing case: a capability *is* an unforgeable URL, so authorization rides a designated reference rather than the browser's ambient origin + auto-attached credentials.

## Common confusions

- **"Ambient authority means no credential is presented."** Rejected by the 2009 thread: that collapses into *identity-based authority* and misses the token-plus-helper case. A system can present credentials and still be ambient if the caller does not designate *which* authority it is exercising.
- **"Object-capability systems have no ambient authority."** Almost, but not entirely: root objects, the powerbox, and Non-Delegatable Authorities (reconstructible in any ocap system with rescinded-on-presentation nonces) are ambient-authority pockets. The claim is that ocap makes ambient authority the rare, visible, guardable exception rather than the pervasive default.
- **"Per-user permissions are not ambient."** By the designation criterion they are: authority indexed to *the acting identity* rather than to a *designated reference the caller passed* is ambient — the action is allowed because of who is asking, not because of what capability was presented.
