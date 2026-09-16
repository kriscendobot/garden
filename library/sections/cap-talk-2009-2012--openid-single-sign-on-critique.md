---
title: "OpenID single sign-on: convenience traded for phishing exposure"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-November.txt.gz
source_content_sha256: 1b343432bdb27f21a1feb9042d06c9ca2d74be7ba7c7dc43f0ecd29cf5150c64
source_authors: [David Nicol, Alan Karp, Raoul Duke]
source_date: 2011-11-02
thread_subject: "topic: OpenID"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-security, oauth-credentials, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: David Nicol asked whether cap-talk approved of OpenID as decentralized single sign-on. Alan Karp's reply was the thread's verdict: OpenID is "a terrific idea — if you want to train people to be phished," because it habituates users to typing their credentials into a page reached by redirect from an arbitrary relying site, which is exactly the behavior phishing exploits; and it provides convenient Single Sign On across independent sites while providing no Single Sign *Out*, so it "trades off protection for convenience" — the wrong direction. Raoul Duke's end-user experience corroborated both points: the OpenID user interface was miserable, and a single compromised login exposes everything reached through the shared identity. The capability community's objection is structural, not incidental: OpenID authenticates a *global identity* and then lets sites act on it, which re-centralizes authority into one credential whose compromise is total, the opposite of the least-authority, per-resource grant a web-key gives.

## Phishing is trained, not accidental

Karp's phrasing pins the failure mode. OpenID's flow sends the user from a relying site to an identity provider to enter a password, then back — which is behaviorally indistinguishable from a phishing redirect, so a system built on it *trains the reflex* an attacker needs (entering the master credential wherever a login page appears). The design normalizes the very habit security advice tells users to resist. This is the same critique the list levels at any redirect-and-enter-your-password protocol: the human cannot tell the honest identity provider from a spoofed one, so convenience for the honest case is a ready-made channel for the dishonest one.

## No single sign-out, and total compromise on one credential

Two further defects are structural. Single Sign On with no Single Sign Out means there is no reliable way to withdraw the aggregate access an identity has accumulated across sites — the composite authority outlives any single revocation. And because one identity credential unlocks everything federated to it, its compromise is not scoped: as Duke put it, if someone figures out your login they see "everything of mine anywhere." A capability web has the opposite shape: authority is per-resource, held as separate web-keys, so loss of one is loss of one, and revocation is per-capability.

## Bearing on Endo

The OpenID critique is a negative design constraint Endo honors by construction. Endo grants authority as *separate references*, never as one global identity a service then acts on, so there is no master credential whose compromise is total and no need for a "sign out everywhere" primitive — you revoke the specific reference. The phishing-training objection is why Endo introduction happens by passing capabilities (invitations), not by sending a user to type a master secret into a page: there is no reusable credential to phish. Karp's "protection traded for convenience is the wrong trade" is the standing yardstick the [web-powerbox-and-oauth](cap-talk-2009-2012--web-powerbox-and-oauth.md) and [opinions-of-oauth](cap-talk-2009-2012--opinions-of-oauth.md) threads apply to OAuth as well: a mechanism that federates identity for convenience inherits the identity-compromise blast radius that capabilities avoid.

Source: [cap-talk 2011-November archive](http://www.eros-os.org/pipermail/cap-talk/2011-November/) (Internet Archive original-bytes `id_` snapshot of `2011-November.txt.gz`, sha256 `1b343432`), thread "topic: OpenID", 2011-11-02.
