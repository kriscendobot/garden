---
title: "ACLs and object capabilities can coexist, but authority must not grow"
source_kind: mailing-list-archive
source_urls: [http://www.eros-os.org/pipermail/cap-talk/2008-August/, http://www.eros-os.org/pipermail/cap-talk/2008-September/, http://www.eros-os.org/pipermail/cap-talk/2008-October/]
source_snapshots: [https://web.archive.org/web/20160730013840id_/http://www.eros-os.org/pipermail/cap-talk/2008-August.txt.gz, https://web.archive.org/web/20160730002051id_/http://www.eros-os.org/pipermail/cap-talk/2008-September.txt.gz, https://web.archive.org/web/20160729204705id_/http://www.eros-os.org/pipermail/cap-talk/2008-October.txt.gz]
source_content_sha256: [6c53651db296f5e59743f9c82fa172cf3cccd8a15e90648f5a221dd6e8f8b9e6, aec8fe517334dd773f25b70d8d5ab9880184c3bc03ec9e35606d1f5746893177, 73971a84befabcab7f9f664a97e0469de9514614bf287d06716bc3b9b1a57cc8]
source_authors: [Jonathan S. Shapiro, Richard Uhtenwoldt, Baldur Johannsson, Jed Donnelley, Ihab Awad, Sandro Magi, Toby Murray, Rob Meijer, John Carlson, Jonathan Smith, Alan H. Karp, James A. Donald, Charles Landau, Mark S. Miller, David-Sarah Hopwood, Bill Frantz, Kevin Reid, Tony Finch, Mark Seaborn, David Wagner, Marcus Brinkmann, Raoul Duke, Tyler Close]
source_date: 2008-08-30 to 2008-10-09
thread_subject: "More Heresy: ACLs not inherently bad"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary across three monthly bundles, not the original messages."
---

Abstract: ACL machinery is not intrinsically incompatible with object capabilities. It can be useful for centrally administered group membership, especially removing a member later, provided designation remains capability-based and the ACL acts only as an additional deny filter. Using identity policy to add authority or resolve a forgeable object name recreates ambient authority and confused deputies.

Shapiro's “modified ACL” proposal makes a Principal first-class and requires both an object reference and an allowed operation. Karp identifies the crucial fork: if the object is designated by a filename and the ACL grants rights, the confused-deputy problem remains; if the reference already denotes a narrow facet, an ACL may safely deny its use but should not amplify it. Private namespaces and capability passing can therefore coexist with administrative revocation policy.

The debate does not restore ACL/capability equivalence. It narrows a sound hybrid rule: references designate the object and bound maximum authority; policy may subtract from that bound. Endo gateways can apply identity or tenant policy as a narrowing membrane, but must never use it to turn an otherwise powerless name into a stronger reference.

Source: cap-talk [2008-August](http://www.eros-os.org/pipermail/cap-talk/2008-August/), [2008-September](http://www.eros-os.org/pipermail/cap-talk/2008-September/), and [2008-October](http://www.eros-os.org/pipermail/cap-talk/2008-October/) archives (Internet Archive original-bytes snapshots, sha256 `6c53651d`, `aec8fe51`, and `73971a84`), messages dated 2008-08-30 to 2008-10-09.
