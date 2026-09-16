---
title: "Capabilities for legacy web programs: HMAC-signed URLs"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-November.txt.gz
source_content_sha256: 1b343432bdb27f21a1feb9042d06c9ca2d74be7ba7c7dc43f0ecd29cf5150c64
source_authors: [Sandro Magi, David Wagner, David Barbour, Eric Jacobs]
source_date: 2011-11-05 to 2011-11-21
thread_subject: "Capabilities for legacy web programs / Self-authenticating web service protocol"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security]
status: current
notes: "Derived summary, not the original messages. Consolidates the November 'Capabilities for legacy web programs' and 'Self-authenticating web service protocol' threads, which share the HMAC-signed-URL technique."
---

Abstract: Sandro Magi proposed a lightweight, "worse is better" alternative to full Waterken adoption for retrofitting capability properties onto existing web frameworks: each server holds a private key and appends an HMAC of every URL it generates (base URL plus any required cookies) as an extra query parameter; a request simply recomputes and checks the HMAC. Because the HMAC is unforgeable, tampered or fabricated URLs are rejected, which gives the CSRF and clickjacking resistance of capabilities without decomposing the application into fine-grained objects. Magi's framing: if no cookies are needed, the URL *is* a capability; cookies are application-specific delegation restrictions on it. David Wagner raised two concrete problems: with cookie-dependent HMACs, a user with several tabs open breaks links after any cookie change (the HMAC no longer matches), and if the server just auto-regenerates a valid HMAC and redirects on a mismatch, the HMAC's protective value is unclear. In the companion "Self-authenticating web service protocol" thread, David Barbour re-presented the same technique to Eric Jacobs, with the refinement that only *marked* parameters are covered by the HMAC (a mnemonic prefix on the secured parameter name — Magi settled on `!` after newer URL RFCs reserved `$`), so unmarked parameters remain freely editable by forms or JavaScript.

## Worse-is-better web capabilities

Magi's honest accounting is the value of the section. The scheme's virtue is integrability: a REST-style application becomes "capability secure" *at the web-interaction layer* by inserting one HMAC-validate-and-rewrite module into the request pipeline, with no rewrite of the server's internal object model. Its admitted cost is that it delivers unforgeability without the deeper benefits — it does not encourage decomposition into fine-grained objects or clean delegation and revocation patterns. It is a way to get the *anti-forgery* property of capabilities (which defeats CSRF and clickjacking, since an attacker cannot construct a valid signed URL) onto code written the ordinary way.

## Wagner's two objections, and the marked-parameter refinement

Wagner's multi-tab objection exposes the tension between binding the signature to mutable session cookies and the web's shared-cookie-jar reality: if the HMAC covers a cookie that another tab changed, previously-valid links silently fail. His second objection is deeper — if the application responds to a bad HMAC by minting a fresh valid one and redirecting (as the "cookie is a re-authenticatable delegation restriction" case suggests), then the HMAC gates nothing. The marked-parameter refinement (only `!`-prefixed parameters enter the HMAC) is the design's answer to the "which bits are the capability and which are free input" question: the secured parameters are the capability, and everything else is ordinary client-supplied data the application must validate anyway.

## Bearing on Endo

This thread is the pragmatic pole of the same axis Endo sits at the principled pole of. The HMAC-signed-URL scheme is capabilities-as-bearer-tokens retrofitted onto legacy code: unforgeable, possession-proves-authority, no ambient identity — the same properties an Endo reference has — but *without* fine-grained objects, delegation, or revocation, which is exactly the deep structure Endo provides and the legacy scheme forgoes. It is a useful reminder that "unforgeable designation" is separable from "object decomposition," and that you can buy the CSRF/clickjacking win cheaply while leaving the least-authority win on the table. Wagner's objections foreshadow Endo's answer: rather than signing mutable state into a URL, Endo keeps authority in a *reference* whose revocation and attenuation are handled by the object behind it (a caretaker or membrane), so there is no signature to invalidate across tabs and no "regenerate on mismatch" escape hatch.

Source: [cap-talk 2011-November archive](http://www.eros-os.org/pipermail/cap-talk/2011-November/) (Internet Archive original-bytes `id_` snapshot of `2011-November.txt.gz`, sha256 `1b343432`), threads "Capabilities for legacy web programs" and "Self-authenticating web service protocol", 2011-11-05 to 2011-11-21.
