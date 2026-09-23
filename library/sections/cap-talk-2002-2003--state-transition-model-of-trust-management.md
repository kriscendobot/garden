---
title: "The Chander-Dean-Mitchell state-transition model, and why its capability is too weak"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-May/
source_snapshot: http://web.archive.org/web/20160729215956id_/http://www.eros-os.org/pipermail/cap-talk/2002-May.txt.gz
source_content_sha256: 331ae0c65a01bd248aaa0a0f7ecfba285daa6c2ec63476b1db7c7087ed726a4b
source_authors: [Ka-Ping Yee, David Chizmadia, Valerio Bellizzomi]
source_date: 2002-05-18
thread_subject: "State-Transition Model by Chander et al"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Ka-Ping Yee brings the list an early formal comparison — Ajay Chander, Drew Dean, and John C. Mitchell's *A State-Transition Model of Trust Management and Access Control* — that models access-control schemes as state machines and compares their expressive power. Its headline results: capabilities-as-rows and ACLs are equivalent in power (each can simulate the other); capabilities-as-references can do things ACLs cannot; and "trust management" can do things none of the others can. Yee accepts the framing as valuable but attacks the modelling. He rejects the paper's opening slogan (ACLs make revocation easy but delegation impossible; capabilities the reverse), calls its "bounded delegation" hop-count integer a red herring, and — the substantive point — shows the paper's capability model is crippled: it can mint a capability from an (object, right) pair and pass one along, but cannot make a capability *from* a capability, i.e. it has no forwarder. Yee argues that missing forwarder is exactly what lets the paper conclude trust management is strictly more powerful; a real capability system such as EROS would implement their trust-management scheme without trouble.

## The comparison and its five claims

The model's value is that it makes different access-control schemes commensurable as state transitions, so equivalence and separation can be argued rather than asserted. But its ranking (references < trust management) depends on the operations each model is granted. By denying the capability model composition — no capability-yielding-capability — the paper measures a strawman.

## Forwarders are the missing operation

Yee's diagnosis is the same lever the caretaker/forwarder pattern turns elsewhere in the archive: a capability that wraps another capability is what makes revocation, attenuation, and delegation-with-policy expressible inside the capability model itself. Without it, any richer policy must live outside, in a "trust management" layer, and the capability model looks weaker than it is. David Chizmadia notes the paper's constructs resemble SESAME's restricted delegation and CORBA security's "privilege attribute," and that useful restricted delegation needs a substantially richer function — restricting by the intermediate subjects, not just a hop count.

## Why it matters for the paper era

This 2002 exchange rehearses, on a concrete external formalism, the distinctions *Capability Myths Demolished* and the 2003 access-matrix threads would sharpen: that a fair model must let capabilities compose (Property E, Composability), and that comparing "capabilities" to "ACLs" is meaningless until you name *which* capability model (row, key, or object-capability) is meant.

Source: [cap-talk 2002-May archive](http://www.eros-os.org/pipermail/cap-talk/2002-May/) (Internet Archive original-bytes snapshot `web/20160729215956id_/.../2002-May.txt.gz`, sha256 `331ae0c6`), messages dated 2002-05-18.
