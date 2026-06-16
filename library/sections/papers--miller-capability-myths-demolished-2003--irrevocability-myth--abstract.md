---
title: Abstract
source: Capability Myths Demolished (SRL2003-02)
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_year: 2003
source_venue: JHU SRL Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
parent: papers--miller-capability-myths-demolished-2003--irrevocability-myth
---

The Irrevocability Myth claims "capabilities cannot revoke access." The paper acknowledges the literal version is correct — "the capability alone is sufficient to establish access to the resource. These two facts might lead one to reasonably believe that there is no opportunity to revoke access." But the literal version misses the right question: in object-capability systems, an indirect capability *can* revoke. The construction the paper presents is the **forwarder + revoker pair** (Figures 6 and 13 of the paper): Alice gives Bob access not to Carol directly but to a forwarder facet F; Alice retains a revoker facet R; both F and R reference Carol. When Alice wants to revoke Bob's access, she invokes R, which tells F to drop its reference to Carol. F still exists but is now useless. The paper notes "this scheme is not a recent invention. Redell described exactly this method for revoking access in 1974 [18]," and KeyKOS and EROS both implemented optimized versions.

The Endo lineage knows this pattern as the **caretaker pattern**, and this paper is the upstream origin citation for that name's referent.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
