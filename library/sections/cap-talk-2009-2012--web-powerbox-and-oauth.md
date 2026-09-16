---
title: "The Web Powerbox and why it beats OAuth"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-February/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-February.txt.gz
source_content_sha256: 031e283291d79d59a055a829a4807556952bcb0bd03a28448ad9e3999d9dea35
source_authors: [Mark Seaborn, Kenton Varda, William Pearson, Tyler Close, Mark Miller]
source_date: 2010-02-10 to 2010-02-14
thread_subject: "Granting access to web services / Comparing Web Powerbox with OAuth"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, oauth-credentials]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: In February 2010 Mark Seaborn, with Tyler Close and Mark Miller, posted a concrete design for a "Web Powerbox": a browser-mediated mechanism by which a user can grant one web app access to a service provided by another web app (local or remote), sketched at `plash.beasts.org/wiki/WebPowerbox`. The motivating problem, raised by Miller on the W3C device-APIs list, was that exposing local devices (camera, microphone, GPS) as local web services reduces to "the previously unsolved problem" of introducing one web app to another web app's service without hard-coded URLs or the user typing a service URL. The powerbox is the solver: a browser-held broker that introduces a requester to a provider through a user gesture (a browser-implemented widget, or drag-and-drop from provider to requester), issues the connection as a [[web-key]] the requester holds, and offers a management UI to visualize and revoke live connections. Kenton Varda (later Cap'n Proto and Sandstorm) joined the design. Seaborn then wrote a careful comparison showing the powerbox strictly dominates the OAuth-style redirect dance on clickjacking, phishing, XSRF, and asynchrony, precisely because the powerbox replaces ambient HTTP credentials with a per-connection capability.

## The design

The user grants access by acting on a browser-rendered widget rather than a page-drawn one, so the site cannot pop a grant dialog on its own whim: for requesting a service, an `<input>` with a new type (falling back to file upload on unaware browsers); for registering a provider, a new element. Power users can drag-and-drop a provider widget onto a requester widget to perform a grant directly. Varda's design notes anticipate the modern shape: a connection-management UI that shows established requester-provider links and their activity and lets the user revoke; type names identified by URLs of type definitions; provider URLs that are web-keys when the resource is private but need not be when it is meant for all; and automatic revocation when the requester site closes (usually, not always, desirable). The powerbox is thus a trusted-path introducer plus a revocable-connection registry, entirely browser-held.

## Why it beats OAuth

Seaborn's comparison takes the OAuth-like arrangement (buystuff.com redirects to `bank.com/request?amount=10&destination=buystuff`, bank.com confirms) and lists its residual risks: clickjacking if buystuff frames bank (bank must framebust); phishing if bank ever accepts a password on that page; XSRF unless bank requires a secret token and ignores ambient credentials; and an asynchrony/clicking-game attack where the requester chooses when to redirect. The root cause he identifies is sharp: "this OAuth-like arrangement actively depends on ambient authority via HTTP credentials such as cookies." The powerbox removes each risk at the source. It removes the need for buystuff to know about bank in advance (the introduction problem). It removes bank's need for cookies, because the browser holds a secret buystuff cannot read. bank's confirmation page is reached via a web-key buystuff does not have, so no framebusting is needed. The dialog opens only on a user click, blunting the clicking-game. And because the confirmation page is reached through the trusted powerbox path, spoofing it would require spoofing the powerbox dialog itself. Seaborn's telling aside: if buystuff held a web-key to bank's payment-requester form, it "could authorise any payment it wanted without going via the user, by sending HTTP requests directly to bank.com, server-to-server," which is exactly the delegable-authority power OAuth's bearer tokens carry and the powerbox scopes to a user-mediated grant.

## Bearing on Endo

This thread is a direct ancestor of the [[powerbox]] pattern as Endo uses it: authority is introduced to a program only by an explicit, user-mediated grant that yields a capability, never by the program discovering an ambient credential. The comparison with OAuth is the practical statement of the [[oauth-client-credentials-vs-authorization-code]] distinction and the broader ambient-versus-designated fault line: OAuth's security rests on cookies and bearer tokens (ambient, replayable, over-broad), while the powerbox hands out a [[web-key]] scoped to one connection and revocable from one place. Varda's connection-management UI is the revocation surface Endo realizes with caretakers and membranes. See open questions 42 (which layer should own sharing and revocation) and 46 (CORS leaves ambient cookie authority in place), and the companion [cap-talk-2009-2012--cookies-as-ambient-authority](cap-talk-2009-2012--cookies-as-ambient-authority.md) section.

Source: [cap-talk 2010-February archive](http://www.eros-os.org/pipermail/cap-talk/2010-February/) (Internet Archive original-bytes `id_` snapshot of `2010-February.txt.gz`, sha256 `031e2832`), threads "Granting access to web services" and "Comparing Web Powerbox with OAuth", 2010-02-10 to 2010-02-14.
