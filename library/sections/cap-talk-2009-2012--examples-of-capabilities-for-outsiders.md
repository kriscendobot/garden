---
title: "Examples of capabilities for a wider audience"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-April.txt.gz
source_content_sha256: f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1
source_authors: [Matej Kosik, David Barbour, Kevin Reid, Mark Miller, Nathan Wilcox, Rob Meijer]
source_date: 2011-04-12
thread_subject: "examples of capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Matej Kosik asked the list for real-world examples of capabilities that would land with people outside the object-capability community, distinguishing *unforgeable* capabilities (protected by the language or kernel) from *infeasible-to-forge* capabilities (protected by a large random secret). He was curating the `wiki.erights.org/wiki/Capability` page and had added a Picasa "invitation to view" web album link as an example of an infeasible-to-forge capability, preferring that concrete case to the audience-losing term "password capability." David Barbour offered the email-validation URI (the large randomized link mailed to confirm an address or unsubscribe) as the example most people have already used without noticing its security role. The thread doubled as page maintenance (Kevin Reid asked why the Tamed Pict link was removed and requested edit-summary rationales; Mark Miller supplied fresh links) and settled a naming point: Rob Meijer reported the community consensus that "sparse capability" is the proper modern name for what was called a "password capability," and Barbour seconded it.

## The examples, and the naming they force

Kosik's framing separates two protection mechanisms that both yield a capability. An *unforgeable* capability cannot be fabricated because the language or kernel controls reference creation. An *infeasible-to-forge* capability can in principle be guessed but the secret is large enough that guessing is impractical. The examples the list liked are all of the second kind because they are the ones ordinary users have touched: the Picasa "invitation to view" URL, the email-validation and unsubscribe links carrying a large random token, and by extension any secret-bearing URL. Barbour's point about the email link is pedagogically the sharpest: users routinely exercise it as a capability (possession of the link authorizes the action) without ever conceptualizing the token's role.

The naming question is the same one open question 50 records from the 2010 cookies thread. Kosik doubted "password capability" (is it even the same thing as "infeasible-to-forge capability," and would `captp://` references count?). Meijer reported that when he circulated an article for feedback, consensus favored "sparse capability" as the proper and modern term, and Barbour agreed. The thread thus supplies a small resolution to the naming dispute: for teaching outsiders, use concrete examples (the invitation link, the validation URL) and the term "sparse capability," not "password capability."

## Bearing on Endo

Endo's user-facing surfaces (the powerbox, invitation and connection flows, sturdy references handed between peers) are exactly the "infeasible-to-forge" capabilities this thread collected, and the pedagogy carries over: the way to explain an Endo invitation to a newcomer is the Picasa-album or email-validation-link analogy, not the phrase "password capability." The unforgeable-versus-infeasible-to-forge split is also the architectural boundary Endo straddles: inside a vat, references are unforgeable (the language controls creation); across the wire, a sturdy reference or invitation is infeasible-to-forge (a large secret). Both are capabilities; the pedagogy should name the mechanism honestly rather than blur the two.

Source: [cap-talk 2011-April archive](http://www.eros-os.org/pipermail/cap-talk/2011-April/) (Internet Archive original-bytes `id_` snapshot of `2011-April.txt.gz`, sha256 `f28a7548`), thread "examples of capabilities", 2011-04-12.
