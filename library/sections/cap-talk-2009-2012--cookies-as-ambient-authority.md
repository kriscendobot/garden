---
title: "Cookies are ambient authority: the RFC cookie security-considerations review"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-February/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-February.txt.gz
source_content_sha256: 031e283291d79d59a055a829a4807556952bcb0bd03a28448ad9e3999d9dea35
source_authors: [Adam Barth, Toby Murray, Mark Seaborn, Mark Miller]
source_date: 2010-02-11 to 2010-02-13
thread_subject: "Security considerations for cookies"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: In February 2010 Adam Barth (the editor of what became the HTTP State Management RFC, RFC 6265) brought the draft "Security Considerations" section of the cookie specification to cap-talk for review, and the list read the whole cookie mechanism through the object-capability lens. Barth's own text names the diagnosis without hedging: the reason cross-site scripting and cross-site request forgery afflict cookie-authenticated servers is that "cookies being a form of ambient authority" separate designation (the URL) from authorization (the cookie), so the server and its clients "become confused deputies." His remedy is the capability remedy: "entangling designation and authorization by treating URLs as object-capabilities," storing the secret in the URL so the remote party must supply it rather than having the browser attach it automatically. The thread's lasting artifact for the SES/Endo lineage is twofold: an RFC-blessed statement that the browser's automatic-credential-attachment is the confused deputy, and Mark Miller's careful note on what to *call* a secret-bearing URL (not, strictly, a "cryptographic capability"; "sparse capability" is accurate but obscure; "treating URLs as capabilities" is the honest phrasing).

## The diagnosis, in the spec's own words

Barth's draft enumerates cookies' security weaknesses (clear-text transport, weak confidentiality with no isolation by port or scheme, weak integrity across sibling domains, reliance on DNS), but the load-bearing subsection is "Ambient Authority." A user agent "attaches cookies even if the entity does not know the contents of the cookies, possibly letting the remote entity exercise authority at an unwary server." Because the request is issued on a remote party's behalf (an HTTP redirect, an HTML form), the cookie authorizes an action the requester designated but the browser authorized: the textbook confused deputy. The general recommendation is blunt: "The cookie protocol is NOT RECOMMENDED for new applications," and servers that must use cookies "SHOULD NOT rely upon cookies for security."

Toby Murray's reply frames why the list cared: the section is "an excellent summary of much of the philosophy shared by many on this list." Barth notes he "cheated and got input from Mark Miller before emailing this list," so the capability framing in an IETF specification is not accidental. It is cap-talk vocabulary landing in the standard that governs the web's dominant ambient-authority mechanism.

## What to call a secret-bearing URL

Mark Seaborn pressed on precision: is a secret-in-a-URL really an "object-capability"? He read the term as "reserved for references that are unforgeable (OS and language caps), not merely unguessable." Miller's response is the durable terminology note. The precise term he uses in speech is "cryptographic capabilities," which others on the list have reasonably objected to; "password capabilities" is spoiled by its history; "sparse capability" is accurate and unmisleading but has become obscure. Crucially, "web-keys by themselves are not cryptographic capabilities" (Miller cites his own www-tag posts). His recommendation is the modest one that survives: the phrase "treating URLs as capabilities" makes "no strong statement that these URLs are capabilities" and is "simply fine." Seaborn's other correction stuck too: cross-site scripting "is caused by failure to escape strings, not by cookies," so Barth dropped XSS from the ambient-authority paragraph and kept CSRF as the clean case.

## Bearing on Endo

This thread is the web-facing statement of exactly the hazard SES and Endo remove structurally. The browser's automatic attachment of a cookie to an outgoing request is the ambient-authority helper facility the [[ambient-authority]] concept warns about: authority the caller never designated, selected and attached on its behalf, which recreates the [[confused-deputy]] on top of whatever the page can be tricked into requesting. Endo's answer is the same as Barth's remedy generalized off the web: authority travels only as an explicitly passed reference (a [[web-key]] or an ocap), never as an ambient credential the substrate volunteers. Miller's terminology caution also anchors the library's own care with the word "capability" for unguessable-but-not-unforgeable URLs (see open question 50 and the [[web-key]] concept). See also open questions 44 (reducing ambient user authority) and 46 (CORS leaves ambient cookie authority in place), the same designation-versus-ambient fault line on adjacent web mechanisms.

Source: [cap-talk 2010-February archive](http://www.eros-os.org/pipermail/cap-talk/2010-February/) (Internet Archive original-bytes `id_` snapshot of `2010-February.txt.gz`, sha256 `031e2832`), thread "Security considerations for cookies", 2010-02-11 to 2010-02-13.
