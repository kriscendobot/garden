---
title: "Name kinds and the layered petname system"
source_kind: paper
source_url: https://files.spritely.institute/papers/petnames.html
source_content_sha256: c9f221a9a7aa4c2541ce81510aae03c0a1553a0eb867c1b66df7a3fea6982ee2
source_authors: [Christine Lemmer-Webber, Mark S. Miller, Zachary Larson, Kate Sills, Eli Yaacoby]
source_date: 2022
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-security]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
notes: "Derived from the authors' public paper but not the original."
---

Abstract: The paper separates three human-readable name kinds over secure global identifiers: petnames chosen privately by the holder, edge names supplied along paths through other parties' namespaces, and proposed names presented in the current interaction. The combination is a layered system, not one global namespace that simultaneously satisfies Zooko's three properties.

A petname database maps human-readable local names to cryptographically secure identifiers in both directions. A holder's own petnames carry the strongest local meaning. Each entity may also publish edge names, producing paths such as “Uncle Bob ⇒ Sarah Smith”; DNS can be treated as one naming hub among others rather than discarded. A proposed name is only what an introducer or encountered entity suggests, including a self-proposed profile name, and must remain visibly distinct from a name the user chose.

The layering supplies human meaning without changing the underlying decentralized identifier. “All three” therefore describes the complete user-facing system: global uniqueness and decentralization remain properties of the cryptographic identifier, while human meaning is local and contextual. It does not establish a single universal, memorable namespace.

Source: [*Petnames: A humane approach to secure, decentralized naming*](https://files.spritely.institute/papers/petnames.html), retrieved 2026-10-08, sha256 `c9f221a9`.
