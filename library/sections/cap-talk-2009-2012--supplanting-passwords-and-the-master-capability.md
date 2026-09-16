---
title: "What supplants passwords, and the irreducible master-capability bootstrap"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-November.txt.gz
source_content_sha256: 1b343432bdb27f21a1feb9042d06c9ca2d74be7ba7c7dc43f0ecd29cf5150c64
source_authors: [Dan Connolly, David Barbour, Ben Kloosterman, James A. Donald, Rob Meijer, Seth Purcell]
source_date: 2011-11-01 to 2011-11-04
thread_subject: "struggling to learn what techniques supplant passwords"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-security, oauth-credentials, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Dan Connolly, building healthcare web services under object-capability discipline, pressed a practical gap: the Walnut/E literature promises "No Passwords ... POLA, pet names, and other related techniques supplant them all," but he could find no concrete account of *what actually supplants a password* for a network service accessed from a borrowed browser, nor a clear catalog of the patterns for "getting capabilities in the first place." David Barbour gave the standard answer: capabilities are already used on the web today as *password-capabilities* — securely-random URLs — and taken to its conclusion your bookmarks file *is* your capability list, so access to the URL is itself proof of authority and no password is needed; delegation is emailing someone a capability. But Barbour, James Donald, Seth Purcell, and Rob Meijer all converged on the residue: there must be *somewhere* a single point of entry — a master capability holding the rest of your authority — and unless the user can memorize its web-key, it has to live somewhere (a browser bookmark, a sticky note, or behind a password dialog on a server), so you can trade off accessibility against vulnerability but you cannot make the bootstrap disappear. Purcell's sharp observation: a master web-key the user can *choose and remember* "looks suspiciously like password-based authentication by a different name."

## Web-keys replace per-resource passwords, not the last secret

The capability answer to "how do capabilities get rid of passwords" is that most passwords were never authenticating a person — they were gating access to a resource, and an unguessable URL (a web-key) gates that access directly, with possession as proof and no shared secret to phish or reuse. Barbour's bookmarks-are-capabilities picture is the endpoint: each bookmark is authority, delegation is forwarding a URL, and revocation is a caretaker behind the URL. Ben Kloosterman's practical sketch matches it (register, get emailed your web-key, use the URL as the key thereafter) and notes the friction is that today's platforms — Android, Windows 8 Metro — grant *coarse* capabilities (a whole device or file library) while individual files still go through ACLs, so the web-key model is not yet native.

## The bootstrap residue is irreducible

The unanimous caveat is that capabilities live on a machine, not in a human head (James Donald), so *some* secret or trusted device must bootstrap access to the capability store. Three shapes were named, all lossy: memorize the master web-key (only if it is chosen and memorable, at which point it is a password by another name — Purcell); store it (a bookmark à la Waterken, a sticky note, or the app server behind a password dialog — Purcell); or carry the machine that holds the capabilities (an Android phone), which makes login moot but relocates the trust to physical possession (Donald). For the borrowed-computer case Donald's proposal is a zero-knowledge password proof through a *secure* user interface (not a generic web page) that lets you exercise a chosen capability on the client. Rob Meijer added two reframings: persistent processes with their own private secure capability storage largely *dissolve* the need to re-authenticate, and a username-plus-password is itself a weak *discretionary* capability, so replacing passwords needs both stronger authentication *and* capabilities, not either alone.

## Bearing on Endo

This thread is the problem statement Endo's onboarding answers and the caveat it still respects. Endo's model is precisely "your capability store is on your machine": the Endo daemon holds your capabilities (pet-named), and access to a guest is possession of a reference, not a per-service password — the web-key idea generalized to a local capability bank. Barbour's "bookmarks are capabilities" is the pet-name directory; delegation-by-emailing-a-capability is the Endo invitation/introduction flow. The irreducible bootstrap is exactly the surface Endo treats with care: unlocking the daemon (the single point of entry) and the borrowed-device / onboarding problem are where a real secret or trusted device still enters, matching Purcell's "you cannot get rid of the last secret." Meijer's "you need both authentication and capabilities" is why Endo pairs an unlock/identity step with capability-based authorization rather than pretending one eliminates the other.

Source: [cap-talk 2011-November archive](http://www.eros-os.org/pipermail/cap-talk/2011-November/) (Internet Archive original-bytes `id_` snapshot of `2011-November.txt.gz`, sha256 `1b343432`), thread "struggling to learn what techniques supplant passwords", 2011-11-01 to 2011-11-04.
