---
title: "Textual distributed computing protocols"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-February/
source_snapshot: http://web.archive.org/web/20160730014719id_/http://www.eros-os.org/pipermail/cap-talk/2002-February.txt.gz
source_content_sha256: aec16198892bf9cc85916e2c7fa81e609bb807b797c312755b7509ca7c809a85
source_authors: [Mark S. Miller, David Chizmadia, Constantine Plotnikov]
source_date: 2002-02-13
thread_subject: "Textual distributed computing protocols"
ingested: 2026-09-16
ingested_by: scholar
topics: [captp, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A thread on whether distributed-object protocols should have a readable textual wire format, and whether a capability transport could become a mainstream standard. Miller argues that if the OMG had defined a textual format one-to-one meaning-preserving with GIOP/IIOP's binary format, readable and "faddish", then SOAP would never have happened. David Chizmadia relays that OMG considers CORBA near the end of its life and has rechartered its group to consider new technologies, and proposes CapTP-on-VatTP (the E capability transport) as a candidate future OMG protocol, especially if linked to CapIDL as an incremental variation on OMG IDL. The discussion connects capability transport, textual encodings, and standards-body adoption.

## The textual-vs-binary argument

Miller's claim, in 20/20 hindsight: SOAP's rise was avoidable. Had the OMG shipped a textual format that was fully one-to-one meaning-preserving with the binary GIOP/IIOP format, with conversion tools both directions, and had that textual format been both readable and fashionable, the industry would not have reached for a new XML-based RPC. Chizmadia notes prior attempts existed (the XIOP research project) but never went far, and that OMG has since issued RFPs for CORBA-with-WSDL and WSDL-with-CORBA interworking, likely yielding SOAP bindings from OMG IDL and IIOP bindings from WSDL.

## CapTP-on-VatTP as a standards candidate

Chizmadia proposes briefing CapTP-on-VatTP to OMG as a basis for future specifications. His argument: security and reliability are large concerns among OMG members, so a protocol that demonstrably does better on both would get a fair hearing. The strongest opening would be to link CapTP-on-VatTP to CapIDL, which, as an incremental variation on OMG IDL, offers a relatively direct path into the existing specification pantheon (and a link to UML for expressing application design). This situates the E capability transport (later the lineage behind CapTP and OCapN) as a contender for mainstream distributed-computing standardization rather than a niche research protocol.

Source: [cap-talk 2002-February archive](http://www.eros-os.org/pipermail/cap-talk/2002-February/) (Internet Archive original-bytes snapshot `web/20160730014719id_/.../2002-February.txt.gz`, sha256 `aec16198`), messages dated 2002-02-13 to 2002-02-15.
