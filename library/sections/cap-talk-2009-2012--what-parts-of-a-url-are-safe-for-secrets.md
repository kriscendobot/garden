---
title: "What parts of a URL are safe to hold secrets"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-March.txt.gz
source_content_sha256: 6deacabd27bcb3ca4c363ea790ca8569dd9d5c871cf421de257fec803a82ce29
source_authors: [James A. Donald, David Barbour]
source_date: 2012-03-30 to 2012-03-31
thread_subject: "What parts of a url are safe?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: James Donald raised the confidentiality problem that shadows every URL-borne capability: bookmarks are a convenient place to store non-human-readable secrets, but not a safe one, because browsers and their add-ons "send copies of URLs off to all and sundry." He asked which parts of a URL are *supposed* to be safe to carry a secret, and whether an add-on that phones home with full (rather than truncated) URLs should be classed as spyware. David Barbour's blunt answer: "Nothing in the URL is safe." You could move the secret into a cookie, but that usually defeats the point of a capability-URL. His constructive suggestions were to build a *safe bookmark repository* (encrypt the bookmark file under a password) and a browser plugin that "blacks out" long base16/base32 strings in the address bar while still allowing copy and paste. Donald noted the tension that login URLs routinely *do* carry passwords, so "nothing is safe" cannot be the whole story in practice — which is precisely the unresolved gap between the web-key idea and the web's actual handling of URLs.

## The confidentiality leak in URL-as-capability

The section's point is the standing weakness of treating a URL as a capability: the whole model depends on the secret staying secret, but the URL is the *least* confidential part of a web interaction — it lands in browser history, in `Referer` headers, in server logs, in bookmark sync, and in whatever telemetry an add-on collects. Barbour's "nothing in the URL is safe" is the honest statement: unlike a fragment (`#...`), which browsers do not send in the `Referer` and do not transmit to the server on navigation, the path and query are routinely disclosed, and even the fragment is exposed to scripts and extensions running in the page. Donald's counter — login URLs carry passwords all the time — is not a refutation but a description of the bad status quo the capability community wants to replace: those URLs *are* leaking, which is why session tokens get stolen.

## Mitigations, not a fix

The thread offers mitigations rather than a solution: keep the authority-bearing secret in the URL *fragment* (where the web-key convention puts it, precisely because the fragment is not sent to the server), store bookmarks in an *encrypted* repository rather than the plaintext bookmark file, and reduce shoulder-surfing and casual-copy leakage with an address-bar plugin that visually redacts long random strings while preserving copy-paste. The spyware question (should an add-on that exfiltrates full URLs be blacklisted?) is really a plea for a norm that treats URL contents as sensitive — a norm the web never adopted.

## Bearing on Endo

This thread is the confidentiality caveat on the web-key model that runs through [opinions-of-oauth](cap-talk-2009-2012--opinions-of-oauth.md), [supplanting-passwords-and-the-master-capability](cap-talk-2009-2012--supplanting-passwords-and-the-master-capability.md), and the earlier [hiding-webkeys-from-the-address-bar](cap-talk-2009-2012--hiding-webkeys-from-the-address-bar.md) section, and it is a reason Endo does *not* rely on URL-borne bearer secrets for its primary capability transport. Endo passes capabilities as live references over an authenticated OCapN connection, not as secrets embedded in URLs that browsers and add-ons leak, so the "nothing in the URL is safe" failure mode does not apply to Endo's own references. Where Endo or an Endo-hosted app must mint a URL-shaped capability for a legacy web client, this thread is the checklist: put the secret in the fragment, treat the URL as compromised the moment it leaves the intended holder, and prefer a revocable reference behind a stable URL over a long-lived secret baked into the URL itself.

Source: [cap-talk 2012-March archive](http://www.eros-os.org/pipermail/cap-talk/2012-March/) (Internet Archive original-bytes `id_` snapshot of `2012-March.txt.gz`, sha256 `6deacabd`), thread "What parts of a url are safe?", 2012-03-30 to 2012-03-31.
