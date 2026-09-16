---
title: "Sitelier: a capability-based operating system for the web"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-July/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-July.txt.gz
source_content_sha256: 807b66a51b579006d17b26a159c5b86b450ccd776e8e137b04353e6e75333da6
source_authors: [Seth Purcell, David Wagner]
source_date: 2011-07-05 to 2011-07-06
thread_subject: "a capability-based OS for the web"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, distributed-objects, identity]
status: current
notes: "Derived summary, not the original messages. Light month (9 messages)."
---

Abstract: Seth Purcell announced Sitelier, a distributed capability-based operating system for the web whose animating goal is to give people real control over their online lives by inverting where application data lives. A user runs a secure private website (the "kernel server") on which they install web apps; those apps then store their data on the user's own site rather than on the app vendor's servers. Sitelier uses OpenPGP to provide decentralized identity for both users and apps and to link users to their apps and to each other, so the network is a decentralized mesh of user-owned sites rather than a set of vendor silos. David Wagner's feedback was practical and skeptical of the crypto: usability is the make-or-break property and should be validated with user experiments; the kernel server should use TLS site-wide with HTTP Strict Transport Security to blunt man-in-the-middle attacks on hostile networks; and it was not obvious why PGP was needed at all if a central site could manage trust. Purcell clarified that the central site (sitelier.com) is informational only and arbitrates no identity: the Sitelier kernel is downloadable software (like the Linux kernel) that anyone runs on any server, and PGP is precisely what lets identity be decentralized across those independently-run sites rather than delegated to a central authority.

## User-owned data on a decentralized mesh

The design's inversion is the notable part: instead of each web app holding a user's data on the vendor's infrastructure, the user hosts a site and apps are installed *onto* it and keep their data *there*. That makes the user, not the vendor, the locus of storage and control, and it makes the network a peer mesh of user sites rather than a hub-and-spoke of vendor services. Decentralized identity is the enabling primitive, which is why Purcell reached for OpenPGP rather than a central account system: there is no arbiter to authenticate against, so identity has to be something each site can carry and verify independently. Wagner's TLS-and-HSTS advice and his insistence on usability testing are the deployment realities any such system faces, and his "why PGP" question is the recurring tension between a genuinely decentralized trust model and the simpler central-site model that most deployments collapse into. Purcell's answer defends the decentralization as the whole point: the central site is a brochure, not a certificate authority.

## Bearing on Endo

Sitelier is a 2011 sketch of the arrangement Endo aims at: a user-run substrate onto which guest applications are installed, where the apps operate on capabilities the user grants and store state the user owns, rather than the user surrendering data to vendor silos. The kernel-server framing prefigures the Endo daemon as the user's own agent, and the app-installs-onto-my-site model prefigures Endo guests confined to the powers their host hands them. The decentralized-identity-by-public-key choice is the same self-authenticating-identity direction as the [YURLs](cap-talk-2009-2012--yurls-hash-length-and-self-authenticating-names.md) thread and Endo's `captp` peer identity. Wagner's cautions are the standing ones for Endo too: the security is only as good as the usability of the granting and connection gestures, and transport hardening is table stakes, not the security model itself.

Source: [cap-talk 2011-July archive](http://www.eros-os.org/pipermail/cap-talk/2011-July/) (Internet Archive original-bytes `id_` snapshot of `2011-July.txt.gz`, sha256 `807b66a5`), thread "a capability-based OS for the web", 2011-07-05 to 2011-07-06.
