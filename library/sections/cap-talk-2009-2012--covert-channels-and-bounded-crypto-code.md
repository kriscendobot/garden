---
title: "Covert channels and bounded cryptographic code"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-February/
source_snapshot: http://web.archive.org/web/20130603012729id_/http://www.eros-os.org/pipermail/cap-talk/2011-February.txt.gz
source_content_sha256: 04dab0af089f2d19a65291f03086bcc171b5fda8b785f79e64a4633a99b81a85
source_authors: [David Wagner, Mark Miller, Rob Meijer, Ben Laurie, Tim Freeman, Gabriel Gonzalez]
source_date: 2011-02-19 to 2011-02-23
thread_subject: "Covert channels"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, distributed-objects]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A branch of the immutable-data debate asked whether pure computation and access to time can leak secrets. The replies reject a general no-covert-channel guarantee for useful computers: interactive pacing, network timeouts, shared resource use, heat, clock skew, and power consumption all provide signals, and removing a clock does not prevent malicious code from transmitting. Mark Miller narrows the engineering claim. Open-ended application code may leak confidentiality through covert channels, but the small cryptographic boundary between local object-capability islands need only be trusted not to leak secrets accidentally, since a malicious remote island is already outside the local integrity claim. Keeping cryptographic transport code bounded turns an impossible whole-system proof into a reviewable side-channel assumption for the component whose confidentiality protects local integrity.

## Why suppressing time is not enough

David Wagner argued that time is pervasive in interactive applications and protocols, and an application can infer it from human or network rhythms even without a clock API. Blocking observation also does not prevent transmission. Replies named demonstrated clock-skew attacks against Tor and proposed lower-bandwidth channels through CPU heat or power draw. Constant-rate external power conditioning illustrates the cost of closing one channel, while leaving scheduling, storage, and other shared resources to address. The practical conclusion is to state which channels a model excludes and which bandwidth it tolerates, rather than claiming a useful general-purpose machine has none.

## The bounded boundary

Miller separates covert from side channels by the assumed disposition of the code. Cryptographic transport code must keep its keys secret, but it is a small component the local platform chooses and audits. It is presumed non-malicious, so accidental side channels remain the relevant threat. Application code is open-ended and may be malicious; its confidentiality cannot generally be protected against every covert channel. Integrity can still be reasoned about because a malicious remote endpoint leaking its own secrets is equivalent to treating that endpoint as malicious from the start.

## Bearing on Endo

Endo should make its confidentiality claims component-specific. Lockdown and ocap reference discipline constrain explicit authority and preserve integrity; they do not erase timing, resource, or physical channels. CapTP's key-handling and serialization boundary should stay small enough to audit for accidental leakage. Applications that require confidentiality against mutually suspicious code need an explicit leakage model, isolation budget, and channel assumptions beyond ordinary object-capability confinement.

Source: [cap-talk 2011-February archive](http://www.eros-os.org/pipermail/cap-talk/2011-February/) (Internet Archive original-bytes `id_` snapshot of `2011-February.txt.gz`, sha256 `04dab0af`), thread "Covert channels", 2011-02-19 to 2011-02-23.
