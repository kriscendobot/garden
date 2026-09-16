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

## See also

- [capability-theory](capability-theory.md) - where a question moves once it is settled.
- [[principle-of-least-authority]], [[confused-deputy]] - concepts the equivalence question turns on.
