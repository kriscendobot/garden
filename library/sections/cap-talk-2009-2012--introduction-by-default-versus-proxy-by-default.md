---
title: "Introduction by default versus proxy by default, and Horton responsibility tracking"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-December/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-December.txt.gz
source_content_sha256: b67c8937545b65e5b95609a04c92dd58cf040f5faadcf5bee9ee3ed02c397e8c
source_authors: [Alan Karp, Jed Donnelley, David Barbour, Rob Meijer]
source_date: 2011-12-23 to 2011-12-31
thread_subject: "binder ipc / Introduction by default"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, distributed-objects, capability-security]
status: current
notes: "Derived summary, not the original messages. Grew out of an Android Binder IPC thread; the reference-count-based garbage collection strand continues in 2012-January."
---

Abstract: Discussion of Android's Binder IPC turned into a precise statement of a design fork Alan Karp named: **introduction by default** versus **proxy by default**. In an introduction-by-default system (E, Waterken, and almost all capability systems), when Bob delegates a reference to Carol to Alice, Alice's later invocations go *directly* to Carol. In a proxy-by-default system (HP's Client Utility, the precursor to e-speak), Alice's invocations on a delegated reference route *through Bob* via a path-based proxy — which let Client Utility do distributed reference counting and clean revocation, because dropping Bob's reference severs everything delegated beyond it. The thread also drew the boundary between mechanism and policy: Karp and Jed Donnelley agreed Horton's responsibility tracking is *policy* and does not belong in the kernel, but Karp noted a kernel that supplies an unforgeable sender identity with each invocation can simplify the protocol (it prevents the man-in-the-middle attack that made Horton complex) without building policy in. Donnelley probed how introduction-by-default systems represent Horton's "who" (the responsible entity distinct from the acting object); Karp's answer is that they *cannot*, unless you do something special like handing out a distinct reference per delegation; David Barbour added that a sealer/unsealer pair can *represent* an identity, and Horton tracks responsibility via such a representation but does not *enforce* it — enforcement needs a `loss` model such as a security deposit or reputation system.

## The two propagation regimes

The introduction-versus-proxy distinction is the durable content. Under introduction by default, delegation hands out a reference that the recipient then uses directly, so the delegating object is out of the loop afterward — clean and low-latency, but with no natural chokepoint for revocation or reference counting. Under proxy by default, every delegated use flows back through the delegator's proxy, so the delegator can count references and revoke the whole downstream subtree by dropping its own reference (Karp's Client Utility maintained a local proxy per delegated reference precisely so that "no matter how many times Bob delegated it, all invocations came via Bob," making local reference counting correct for the distributed system). The trade is directness and performance against a revocation-and-accounting chokepoint.

## Mechanism versus policy, and representing "who"

The thread cleanly separates what the kernel should provide from what libraries should implement. Responsibility tracking (Horton) is policy and stays out of the kernel; but an unforgeable *sender identity* per invocation is a mechanism the kernel can supply, and it removes the man-in-the-middle problem that was the hardest part of Horton, letting a recipient distinguish callers without sealed boxes. On representing the accountable "who": introduction-by-default systems have nothing that corresponds to Horton's responsible entity, so tracking who-delegated-to-whom requires a deliberate construction (a fresh reference per delegation, or a sealer/unsealer pair standing in for an identity). Barbour's refinement is the key nuance — Horton *represents* responsibility but does not *enforce* it; enforcement requires modeling `loss` (a forfeitable security deposit, or a reputation stake), so accountability is only as real as the consequence attached to it.

## Bearing on Endo

The introduction-versus-proxy fork is a live choice in Endo's transport lineage. CapTP and OCapN are *introduction by default*: a reference passed across the wire creates a direct three-party handoff (the crossed-hello / gift protocols), so invocations do not route back through the introducer — the efficient regime, at the cost of no built-in revocation chokepoint, which Endo supplies separately as caretaker/membrane objects rather than as a proxy-by-default routing rule. Karp's "unforgeable sender identity as mechanism, responsibility tracking as policy" is the same layering Endo keeps: the transport authenticates the peer, while accountability and audit are library-level concerns, not baked into the protocol. Barbour's "represent versus enforce responsibility, and enforcement needs a loss model" is the honest limit on any audit-trail feature Endo might add — logging who-did-what is representation; making it *matter* requires an economic or reputational stake the object system does not itself provide. The reference-counting strand (proxy-by-default enabling distributed GC) leads directly into the [distributed-reference-counting-garbage-collection](cap-talk-2009-2012--distributed-reference-counting-garbage-collection.md) thread of January 2012.

Source: [cap-talk 2011-December archive](http://www.eros-os.org/pipermail/cap-talk/2011-December/) (Internet Archive original-bytes `id_` snapshot of `2011-December.txt.gz`, sha256 `b67c8937`), thread "binder ipc / Introduction by default", 2011-12-23 to 2011-12-31.
