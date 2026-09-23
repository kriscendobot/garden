---
title: Abstract
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction
---

The paper opens with the framing that programmers write *plans* for machines to execute, and the central problem is **plan coordination**: simultaneously enabling plans to cooperate while avoiding *destructive plan interference*. For sequential single-machine computation, object programming supports plan coordination well — encapsulation limits one plan's ability to disrupt another's assumptions. The paper's thesis is that for **concurrent computation, locking destroys cooperation along with interference**, and the right answer is to change a few concepts of conventional sequential object programming rather than to bolt on locks. Specifically: replace the immediate-call operator with a pair (immediate-call `.` and eventual-send `<-`); replace shared-state concurrency with **communicating event-loops** in *vats*; introduce **promises** for eventual results and **promise pipelining** to tolerate network latency; introduce **broken-reference contagion** and **partial-failure** semantics to handle network partitions; and use the **when-catch** expression to turn data-flow exceptions back into control-flow when needed.

The paper also stakes out the engineering premise that **encapsulation + object programming successes-in-the-small carry over to the large** when the interstitial fabric (the dynamic reference graph that carries messages between objects) is itself engineered. The Hayekian aside (Footnote 1) parallels object encapsulation with *property rights* protecting human plans from interference; "trade brings about their cooperative alignment."

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
