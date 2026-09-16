---
title: "EROS status, and can a capability OS carry legacy Unix?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-February/
source_snapshot: http://web.archive.org/web/20160730014719id_/http://www.eros-os.org/pipermail/cap-talk/2002-February.txt.gz
source_content_sha256: aec16198892bf9cc85916e2c7fa81e609bb807b797c312755b7509ca7c809a85
source_authors: [Alan Cox, Ben Laurie, Jonathan S. Shapiro, Mark S. Miller]
source_date: 2002-02-08
thread_subject: "EROS, please"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. The 'EROS, please' status ping seeds a substantive legacy-deployment debate."
---

Abstract: A status-request ("what is the current status of EROS?") opens into the month's central adoption question: can a capability operating system carry the legacy Unix world, and is it worth doing? Alan Cox argues you can honestly be both EROS and Unix, because the Unix standards are careful to specify error codes rather than a security model, so a Unix environment can be layered on top. Ben Laurie is skeptical: because most Unix software lacks internal decomposition, each program will be handed a large bag of capabilities to work at all and get no noticeable protection, and fine-grained capability management will exceed a sysadmin's patience. Shapiro frames EROS/Linux support as a legacy solution, not an integration, converging with the "Saving the Unix API" thread's conclusion that clean options are limited to true emulation or rewrite.

## Can you be both EROS and Unix? (Alan Cox)

Cox's position is that the incompatibility is overstated: the Unix standards deliberately do not define the security model, only observable behavior such as the error codes returned when the system says "no." Therefore a conforming Unix environment can be created on top of a capability kernel; the way to run legacy code is to build that Unix environment rather than to change the code.

## The decomposition objection (Ben Laurie)

Laurie grants that a Unix environment on top is not a bad thing but suspects its security value is limited. Most Unix software is not decomposed into least-authority pieces, so to run at all each program will be handed a large bundle of capabilities and gain no noticeable protection: partly because programs need many authorities, and partly because doing the fine-grained capability management to withhold them will be beyond the patience of the administrator. Tools to mitigate this will appear, but Laurie expects the result to resemble SELinux in how it is configured. This is the practical counterweight to Cox's optimism: source compatibility does not deliver least authority when the source was never structured for it.

## Legacy solution, not integration (Shapiro)

Shapiro says he has always viewed EROS/Linux support as a legacy solution rather than an integration, and is now less sanguine than ever about saving the POSIX API because the flaw Miller found is in the whole designation model, not a single feature. The open question the month leaves standing: given that legacy Unix compatibility yields little real confinement, what deployment path actually gets a capability OS adopted? The bug-for-bug-emulation and per-launch-box proposals in the sibling "Saving the Unix API / Reframing Boxing" thread are the candidate answers.

Source: [cap-talk 2002-February archive](http://www.eros-os.org/pipermail/cap-talk/2002-February/) (Internet Archive original-bytes snapshot `web/20160730014719id_/.../2002-February.txt.gz`, sha256 `aec16198`), messages dated 2002-02-08 to 2002-02-11.
