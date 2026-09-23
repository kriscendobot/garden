---
title: "Web capabilities: session lifetime and leakage"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-March/
source_snapshot: http://web.archive.org/web/20160729225549id_/http://www.eros-os.org/pipermail/cap-talk/2000-March.txt.gz
source_content_sha256: a61046ff3fa8ac15d0decc34ea3afdfd1ea18a9e4ac6a38e32a0c3026b28b923
source_authors: [David L. Nicol, Jonathan S. Shapiro, Tyler Close, Alan Cox, Juha Saarinen, Lex Spoon]
source_date: 2000-03-02 to 2000-03-10
thread_subject: "story: capabilities in action"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, captp]
status: current
notes: "Derived summary, not the original messages. Added by the 2002-2003 completeness pass."
---

Abstract: A 2000 field report follows a web bearer capability from a help-desk cookie through capability-bearing URLs and exposes the engineering rule behind both: possession authorizes, so authority lifetime and every place the token can leak must be designed together. Nicol replaces IP-address authorization with browser-held capability keys; Shapiro recommends expiring, unguessable form URLs; Close explains that Waterken Droplets binds exported URLs to a disposable HTTP-session context so ending the session invalidates every derived URL. The thread also catches the remaining channels -- browser history, JavaScript cache inspection, swap, crash dumps, and remote retrieval of those dumps -- and distinguishes revoking a server-side context from pretending the bearer token cannot be copied.

## From IP identity to bearer authority

Nicol's help desk originally authorized requests by registered source IP. DHCP broke that identity approximation, so authorization moved to an unguessable cookie held by the browser: the authority follows possession of the token rather than the current network address. Shapiro treats this as a legitimate user-space capability and suggests time-bounded, hashed form URLs for delegating one operation.

## Lifetime is part of the capability design

Nicol objects that URLs appear in caches and can be recovered by hostile JavaScript. Close's Droplets answer is not that URL strings are uncopyable. Each exported capability belongs to a context associated with one HTTP session; destroying the session destroys the context and makes copied URLs useless. This also bounds authority recovered later from swap or a stolen machine.

The group then widens the threat model: a browser crash may preserve memory in a core or log, and a network attacker with access to the host can retrieve that artifact. Close's conclusion is conditional, not absolute: session revocation protects capabilities recovered after the session dies; an attacker who can force a crash, retrieve live memory, and replay before termination already controls enough of the endpoint that any bearer scheme is in danger.

Source: [cap-talk 2000-March archive](http://www.eros-os.org/pipermail/cap-talk/2000-March/) (Internet Archive original-bytes snapshot `web/20160729225549id_/.../2000-March.txt.gz`, sha256 `a61046ff`), messages dated 2000-03-02 to 2000-03-10.
