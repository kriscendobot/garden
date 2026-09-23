---
title: "Web geolocation: origin authority, framing, and revocable user consent"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-October.txt.gz
source_content_sha256: 68456a3c01818f7a9058548bacac397ab922bcebceacde003f2bd129662a02f0
source_authors: [Mark Seaborn, Adam Barth, David-Sarah Hopwood, Ben Laurie]
source_date: 2009-10-29 to 2009-11-24
thread_subject: "Ambient authority in the Web Geolocation API"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages; thread continues in the 2009-November bundle."
---

Abstract: The proposed Web Geolocation API attached a sensitive capability to an origin and asked the user to grant it once, for a page lifetime, or persistently. Mark Seaborn identifies three confused-deputy surfaces: a previously authorized origin can be embedded and clickjacked; the origin string shown in the prompt is attacker-chosen and phishable; and a page with multiple frames gives the user no reliable way to understand which principal receives location. Hopwood proposes a narrower model: only the top-level frame may request location, a persistent visible indicator accompanies use, access is revoked on tab switch or navigation, and permission never persists across sessions. The thread leaves the general usability-versus-persistence tradeoff open but makes revocation visibility and request scope first-class security properties.

## Origin is not a user-understood principal

Same-origin policy makes an origin string the policy key, but the user sees a composed page that may contain many origins. A previously granted embedded frame can exercise location authority in a context chosen by an attacker. Showing the embedded origin in a prompt does not solve this because the attacker chooses that string and users do not reliably map it to the visual component making the request.

Persistent origin grants also turn location into ambient authority. Any script executing with that origin can ask for the current position without designating a newly granted reference. The application cannot opt out of the browser's origin-based policy even if it otherwise uses capability URLs instead of cookies.

## A narrower authority lifetime

Hopwood's alternative deliberately sacrifices convenience. Only a top-level frame can request location. A non-modal browser-controlled bar stays visible for as long as updates flow and provides revocation. Switching tabs or navigating revokes the grant; returning requires a fresh user action. No permission persists across sessions. This binds authority to a visible page lifetime rather than a durable identity label.

The remaining XSS case is acknowledged: hostile code inside an authorized top-level origin can still read the location. That is a site compromise, not something the permission UI can repair by adding more origin labels.

## Bearing on Endo

Powerboxes for camera, location, files, and signing should return revocable session facets, not set durable ambient flags on an origin or account. The trusted UI must keep use visible, bind the grant to the component the user can actually identify, and define lifecycle revocation on navigation, disconnection, or task completion. Persistent restoration, when needed, should restore a specifically designated sturdy reference with inspectable scope rather than silently recreate the broad live facet. Open question 48 records the unresolved persistence boundary.

Source: [cap-talk 2009-October and November archives](http://www.eros-os.org/pipermail/cap-talk/2009-October/) (Internet Archive original-bytes `id_` snapshots; October sha256 `68456a3c`, November sha256 `ba8f8f33`), thread "Ambient authority in the Web Geolocation API", 2009-10-29 to 2009-11-24.
