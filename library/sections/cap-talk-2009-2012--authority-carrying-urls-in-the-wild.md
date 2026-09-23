---
title: "Authority-carrying URLs in the wild: SIAM mails a password-equivalent login link"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-October.txt.gz
source_content_sha256: 6400467f7ecfd40ac0a49d55996a57b16129742f8d3aa84a157c420bea3c5e0f
source_authors: [Alan Karp]
source_date: 2010-10-13
thread_subject: "Authority carrying URLs"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity]
status: current
notes: "Derived summary of a short single-author observation post. Alan Karp forwards a real mailing from SIAM as field evidence."
---

Abstract: A short but pointed field-evidence post from Alan Karp, answering a standing objection to web-keys. The common objection is that people will *share web-keys inappropriately* because they are not used to URLs that carry authority — a habituation argument, not a technical one. Karp's answer: that use of URLs is already becoming mainstream in ordinary commercial practice, whether or not anyone calls it a capability. He forwards a 2011-renewal notice he received from SIAM (the Society for Industrial and Applied Mathematics) containing a link — `http://my.siam.org/d/0006J856489EA8569EB4AE98BE56BC74987858441` — under a security note that reads exactly like a web-key handling instruction: *"This URL will log you directly into your account and it will work for your account only. Please treat this URL as carefully as you would your password as it will allow access to your account. We suggest that you delete this e-mail when you are finished using it. If you reply to this e-mail, we suggest that you delete the URL from your reply."* Karp's dry observation is that the link is not even a use-once renewal token: "It really does take me directly into my account, which means I no longer need a password for this site." A large, non-security organization had, on its own, deployed a bearer URL that fully substitutes for a password — the very design web-keys formalize — and had independently reinvented the correct handling advice (treat it like a password; don't leave it in replies).

## What the evidence shows

The post makes a single argument by example. The objection it answers — that authority-carrying URLs are unsafe because users are not accustomed to URLs that grant authority and will forward them carelessly — assumes such URLs are exotic. Karp's counter-evidence is that they are becoming *ordinary*: a mainstream membership organization mailed one, complete with its own version of the handling discipline (guard it like a password, delete it after use, strip it from replies). Two things follow. First, the *habituation* premise is weakening on its own — bearer URLs are entering everyday commercial email, so users are being taught the handling norms by the sites that use them. Second, the sites that use them are getting the design half-right and half-wrong: SIAM correctly makes the URL a full authority-bearing credential and correctly advises treating it as secret, but the URL is *persistent* (a durable password-equivalent, not a scoped or expiring capability), which is exactly the sharp edge — a leaked persistent login URL is a leaked password. The web-key discipline's advantage over this ad-hoc practice is precisely that a properly designed web-key can be *revocable*, *attenuated*, and *scoped*, rather than being a durable full-account bearer token.

## Bearing on Endo

The thread is a small but useful datapoint for the "capability *is* a URL" model that runs from web-keys through OCapN: the market was already, in 2010, shipping URLs that carry authority and instructing users to guard them like passwords, so the design question is not *whether* to put authority in a URL but *how to make such a URL safe* — unguessable, scoped, attenuable, revocable — rather than a naked persistent password-equivalent. That is the gap between SIAM's ad-hoc login link and a designed [[web-key]]. See the [[web-key]] concept and the neighboring [cap-talk-2009-2012--hiding-webkeys-from-the-address-bar](cap-talk-2009-2012--hiding-webkeys-from-the-address-bar.md) and [cap-talk-2009-2012--webkeys-vs-the-web](cap-talk-2009-2012--webkeys-vs-the-web.md) sections.

Source: [cap-talk 2010-October archive](http://www.eros-os.org/pipermail/cap-talk/2010-October/) (Internet Archive original-bytes `id_` snapshot of `2010-October.txt.gz`, sha256 `6400467f`), thread "Authority carrying URLs", 2010-10-13.
