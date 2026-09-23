---
title: "Capabilities, property rights, and exclusive transfer"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-July/
source_snapshot: http://web.archive.org/web/20160729202529id_/http://www.eros-os.org/pipermail/cap-talk/2003-July.txt.gz
source_content_sha256: f06b013d9e348eccab8e0e2285105f77db40ba85149888469a64bf89b258438e
source_authors: [Jonathan S. Shapiro, Charles Landau, Mark S. Miller, Bill Frantz, Ben Laurie]
source_date: 2003-07-14 to 2003-07-17
thread_subject: "capabilities and economic models"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A discussion of property models makes capability copying and delegation precise. A capability is naturally duplicated, not exclusively transferred; the holder can retain a copy or proxy whenever communication is possible. Exclusive transfer, purses, and title-like ownership are higher-level protocols implemented by mutually trusted services, not capability primitives. Shapiro first argues that this breaks the bearer-instrument metaphor, then reverses perspective: real-world title is likewise an emergent protocol over trusted registrars, law, and insurance. Capability systems make legitimate duplication cheap and forgery impossible; title systems make duplication socially difficult and repair fraud after the fact.

## No primitive owner

ACLs attach one owner identity to a resource and derive other rights from it. Object-capability systems need no recorded first holder. For shared services, Shapiro proposes a behavioral definition: the owners are the programs with enough authority to destroy the object or change its promised behavior -- the parties able to renege on others' access and dependency assumptions.

## Transfer is a protocol

A purse or trusted transfer agent can consume one claim while issuing another, just as a mint or title registry can enforce exclusivity. The impossibility is not building such a service; it is preventing a hostile holder from sharing effective authority outside that protocol when it can proxy. This distinction anticipates the December limited-transfer thread and the paper-era split between permission and authority.

Source: [cap-talk 2003-July archive](http://www.eros-os.org/pipermail/cap-talk/2003-July/) (Internet Archive original-bytes snapshot `web/20160729202529id_/.../2003-July.txt.gz`, sha256 `f06b013d`), messages dated 2003-07-14 to 2003-07-17.
