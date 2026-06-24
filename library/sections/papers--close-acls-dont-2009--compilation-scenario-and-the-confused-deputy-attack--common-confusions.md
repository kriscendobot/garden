---
title: Common confusions
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto; references span Hardy 1988 to Close 2008 + Hansen-Grossman 2008 — published ~2009)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "1-3 (§1 Introduction + §2 Access Matrix through §2.3 Confused Deputy attack)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack
---

- **"The Compiler is the attacker."** No — the Compiler is the *victim's* deputy, mediating between Vendor (its principal) and User (its caller). The User is the attacker. The Compiler is *exploited* by the User's malicious choice of output filename.
- **"`log.txt` is the attacker's file."** No — `log.txt` is the *Vendor's* usage log, written-to by the Compiler in the normal course of operation. The User does not have direct write access to it. The attack is *trick the Compiler into writing to it on the User's behalf*.
- **"This is the same as a buffer overflow."** Categorically not. Buffer overflow injects attacker code; the Confused Deputy attack uses the *victim's* legitimate code with attacker-supplied *data* (the output filename). No code injection occurs.
- **"ACL configurations could fix this if you added log.txt-write-protection to the Compiler."** No — the Compiler needs `log.txt` write access to *do its job* (append usage log entries). Removing that permission would break the legitimate Vendor-side functionality. The ACL model cannot express *Compiler may write log.txt for Vendor reasons but not for User reasons*.
- **"The 1971 Protection paper proved ACLs and capabilities are equivalent."** It presented them as two implementation choices for the access matrix model, but did *not* prove access-decision equivalence in multi-party scenarios — the §2.3 paper points out this gap. The presumption of equivalence stuck despite its narrow basis; this section is the explicit refutation.
- **"This applies only to OS-level access control."** No — the worked example is OS-flavored (Compiler, Filesystem, log.txt), but the §3 paper extends it to web applications (CSRF, clickjacking). The structural lesson is *model-agnostic*: any system where a mediating agent acts on multiple principals' behalf is susceptible to the same attack class under ACL.
