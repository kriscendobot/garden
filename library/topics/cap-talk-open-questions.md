# Topic: cap-talk-open-questions

> Abstract: Unsettled, contentious, or never-converged notions surfaced in the cap-talk mailing-list archive. The disagreements themselves are called out explicitly rather than buried in a neutral summary, because in an object-capability discussion the open disagreement is often the useful signal. Each entry names the question, where in the archive it appears, and (when known) whether and how it was later resolved. This is a growing note: each `scholar-ingest-source` cap-talk cycle appends the contentious notions it finds. Distinct from `capability-theory` (settled foundations): an idea earns a row here only while it is genuinely open or was long contested on the list.

## Open / contested notions

### 1. Are ACLs and capabilities equivalent? (the Equivalence question)

The archive's founding dispute. A newcomer's natural intuition (Frascadore, 1998) is that ACLs and capabilities are "inseparable": the owner must consult an ACL to decide whether to grant a capability, so one reduces to the other. Shapiro argued the relationship is *asymmetric* (ACLs build on capabilities cheaply; the reverse is intractable) and posed concrete challenge problems the 1998 thread did not resolve. **Later resolution (external to the list):** Miller-Yee-Shapiro's *Capability Myths Demolished* (2003) formalizes four models and shows Model 4 (object-capabilities) is not equivalent to ACLs, refuting the Equivalence Myth. Contested on-list for years before that paper settled it.

- [cap-talk-1998--acl-vs-capability-challenge-problems](../sections/cap-talk-1998--acl-vs-capability-challenge-problems.md) - the challenge problems and Frascadore's attempted ACL solution.
- [cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys](../sections/cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys.md) - the seeding equivalence intuition.

### 2. What counts as "a capability"? (the definitional dispute)

A recurring, never-fully-converged terminology fight: does syscall-gating, POSIX "capabilities," a parent-monitors-child sandbox, or a "capability URL" deserve the name? Jim Dennis (1998) argued that active syscall-monitoring "isn't a capabilities model" and that misusing the word confuses newcomers and irritates practitioners. The dispute persists in the field (POSIX capabilities, seccomp, and "capability URLs") and is only sharpened by insisting on the *object-capability* qualifier.

- [cap-talk-1998--caos-capability-os-terminology](../sections/cap-talk-1998--caos-capability-os-terminology.md) - the CAOS thread.
- [cap-talk-2000-2001--capability-representation-partitioned-tagged-and-password](../sections/cap-talk-2000-2001--capability-representation-partitioned-tagged-and-password.md) - the 2000 representation-taxonomy facet (do password/sparse capabilities count, and does a system "bottom out" only in capabilities as names?).
- [cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus](../sections/cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus.md) - Miller's 2001 diagnosis that the term carries two incompatible lineages (OS/Lampson vs lambda-calculus), which is part of why the definition never converges.

### 3. Can a machine attribute an action to the human principal behind a proxy?

Shapiro's July 1999 argument says no audit stamp can distinguish direct action, intentional delegation, proxying, or a confused use of authority. The November debate narrows but does not eliminate the disagreement: controlled compartments can enforce program-channel restrictions, while Gilman argues that trusted predicates and multi-party or biometric authentication can still express useful agent classes. The unresolved part is whether such a predicate proves the intended human cause or only a mediated program state.

- [cap-talk-1999--principal-attribution-proxies-and-confinement](../sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md)
- [cap-talk-1999--principal-policy-and-confinement-debate](../sections/cap-talk-1999--principal-policy-and-confinement-debate.md)

### 4. May persistent garbage collection reveal the last-reference event?

Returning reclaimed storage to either the allocating bank or a global bank makes a capacity change observable. Frantz's clean answer is fixed, non-overcommitted pools per security compartment, but that sacrifices fungible global utilization. The archive identifies the covert channel without converging on a generally efficient policy.

- [cap-talk-1999--storage-gc-and-covert-channels](../sections/cap-talk-1999--storage-gc-and-covert-channels.md)

### 5. Do user-level drivers actually reduce the trusted computing base?

Only when hardware constrains their effective authority. A driver for an unrestricted DMA device can alter all physical memory even outside the kernel, so moving it changes fault containment and engineering shape without reducing trust. Channel processors and modern IOMMU-like boundaries can change the answer. The unresolved engineering question is how portable and narrow that hardware interface can be.

- [cap-talk-1999--driver-trust-dma-and-least-authority](../sections/cap-talk-1999--driver-trust-dma-and-least-authority.md)

### 6. Does reference identity survive destruction?

Hardy asks whether two references to the same destroyed object should still compare equal and references to different destroyed objects unequal. KeyKOS and EROS instead collapse them to one zero key. Preserving identity aids stable designation but delays allocation-identity reuse. The archive leaves the semantic tradeoff open.

- [cap-talk-1998--dead-object-sameness](../sections/cap-talk-1998--dead-object-sameness.md)

### 7. What is the right primitive for distributed object lifetime?

Landau can implement shared-object reclamation with per-holder domains, nodes, and destruction callbacks, but judges the machinery expensive for a reference count. The question anticipates distributed retention protocols: explicit lifecycle signaling is understandable and capability-safe, while implicit collection promises a simpler surface but introduces liveness and covert-channel problems.

- [cap-talk-1999--shared-object-lifetime-reference-counting](../sections/cap-talk-1999--shared-object-lifetime-reference-counting.md)

### 8. Is a certificate-chain authorization system (SPKI) a capability system?

The 2001 web-standardization threads leave this genuinely open. Miller calls SPKI "approximately a capability system" that "falls short," and Hanson (designing his own scheme, Goo) rejects it as a substrate on cost-model grounds: an SPKI certificate *chain* makes the token *grow* as authority is *attenuated*, forces disclosure of a delegatee's residual rights, and (via shortcuts) trades revocability for size. The unresolved question is whether an authorization certificate is a weak capability or a categorically different thing with the wrong attenuation economics (attenuation should shrink authority and stay cheap, not grow the token and disclose the residue).

- [cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol](../sections/cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md) - Miller's "approximately a capability system" survey.
- [cap-talk-2000-2001--reviewing-a-home-rolled-capability-design-goo](../sections/cap-talk-2000-2001--reviewing-a-home-rolled-capability-design-goo.md) - Hanson's concrete SPKI critique and Shapiro's "why not SPKI?" gate.

### 9. Is consuming the resume capability on use a security feature or a bug-catching feature?

The November 2000 EROS "call count" exchange leaves the semantics of the once-only resume key unsettled: Bornschein reads user-level serial checking as smuggling in a brute-forceable password capability, while Shapiro argues the once-only consumption "is not a security feature" at all but a way to catch servers that return multiple times. Whether that guarantee deserves kernel enforcement or a cheaper user-level check is left open.

- [cap-talk-2000-2001--process-allocation-branding-and-the-minimal-tcb](../sections/cap-talk-2000-2001--process-allocation-branding-and-the-minimal-tcb.md) - the call-count / resume-key sub-thread.

### 10. What does formal verification add to convincing capability engineering?

Miller argues that Hardy and the KeyKOS community already knew factories could confine through strong informal proof. Shapiro distinguishes that engineering knowledge from a published model that falsifies prior impossibility claims, generalizes beyond one implementation, and identifies preservation invariants. The archive converges on the value of both but not on a single use of "know."

- [cap-talk-2002-2003--formal-proof-engineering-knowledge-and-confinement](../sections/cap-talk-2002-2003--formal-proof-engineering-knowledge-and-confinement.md) - the Knowledge vs Proof exchange and the separate question of whether confinement is necessary for all security.

### 11. Can an access matrix derive the object-capability model?

Wilcox-O'Hearn's S0/S1/S2 construction suggests that letting normal users create fresh subjects and controlling grants by both resource and recipient turns an ACL matrix into a capability system. The list accepts the normal-user least-authority criterion but leaves the proposed equivalence and row-plus-column characterization only semiformal. Miller considers the idea while drafting *Capability Myths Demolished*.

- [cap-talk-2002-2003--normal-users-can-construct-least-authority](../sections/cap-talk-2002-2003--normal-users-can-construct-least-authority.md) - the proposal, corrections, and narrowed desideratum.

### 12. Why did capability critiques exclude KeyKOS counterexamples?

The 2003 review of Li Gong's earlier KeyKOS paper cannot reconstruct a coherent distinction between its "fully armed system" category and an ordinary partitioned capability system. The thread diagnoses authentication/authorization conflation and model selection, but the historical reason the working counterexample was discounted remains open.

- [cap-talk-2002-2003--li-gong-keykos-and-capability-myths](../sections/cap-talk-2002-2003--li-gong-keykos-and-capability-myths.md) - direct preparation for revising *Capability Myths Demolished*.

### 13. Where exactly is the overt/covert boundary?

Miller and Karp propose a semantics-relative test: a channel is covert if some implementation conforming to the same platform specification can make it fail. This makes the boundary precise relative to a model but does not settle terminology (overt/covert versus in-model/out-of-model), treatment of vanishing bandwidth, or which real-time and physical properties a platform should specify.

- [cap-talk-2002-2003--overt-and-covert-causality-relative-to-semantics](../sections/cap-talk-2002-2003--overt-and-covert-causality-relative-to-semantics.md) - the conforming-implementation test and examples.

### 14. Can non-transferability constrain effective authority?

The list converges on "no" for a hostile holder that can communicate: a kernel can block copying a permission token, but the holder can proxy for another party. The remaining open boundary is the trust or confinement assumption under which a transfer restriction becomes meaningful rather than merely advisory.

- [cap-talk-2002-2003--limited-transfer-permission-vs-authority](../sections/cap-talk-2002-2003--limited-transfer-permission-vs-authority.md) - the immediate post-*Paradigm Regained* application of permission versus authority.

## See also

- [capability-theory](capability-theory.md) - where a question moves once it is settled.
- [[principle-of-least-authority]], [[confused-deputy]] - concepts the equivalence question turns on.
