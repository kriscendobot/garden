# Topic: cap-talk-open-questions

> Abstract: Unsettled, contentious, or never-converged notions surfaced in the cap-talk mailing-list archive. The disagreements themselves are called out explicitly rather than buried in a neutral summary, because in an object-capability discussion the open disagreement is often the useful signal. Each entry names the question, where in the archive it appears, and (when known) whether and how it was later resolved. This is a growing note: each `scholar-ingest-source` cap-talk cycle appends the contentious notions it finds. Distinct from `capability-theory` (settled foundations): an idea earns a row here only while it is genuinely open or was long contested on the list.

## Open / contested notions

### 1. Are ACLs and capabilities equivalent? (the Equivalence question)

The archive's founding dispute. A newcomer's natural intuition (Frascadore, 1998) is that ACLs and capabilities are "inseparable": the owner must consult an ACL to decide whether to grant a capability, so one reduces to the other. Shapiro argued the relationship is *asymmetric* (ACLs build on capabilities cheaply; the reverse is intractable) and posed concrete challenge problems the 1998 thread did not resolve. **Later resolution (external to the list):** Miller-Yee-Shapiro's *Capability Myths Demolished* (2003) formalizes four models and shows Model 4 (object-capabilities) is not equivalent to ACLs, refuting the Equivalence Myth. Contested on-list for years before that paper settled it.

- [cap-talk-1998--acl-vs-capability-challenge-problems](../sections/cap-talk-1998--acl-vs-capability-challenge-problems.md) - the challenge problems and Frascadore's attempted ACL solution.
- [cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys](../sections/cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys.md) - the seeding equivalence intuition.
- [cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09](../sections/cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09.md) - the 2009 reprise: Tyler Close's "ACLs don't" paper, rejected from Oakland-09 as "probably done before" even as reviewers conceded the access-matrix equivalence is "incorrect" — the myth dismissed as obvious yet still unabsorbed.

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

### 15. What deployment path actually gets a capability OS adopted?

Legacy Unix compatibility is the obvious adoption path, but the 2002-February threads leave standing that source-level POSIX compatibility yields little real confinement, because most Unix programs were never decomposed into least-authority pieces and so are handed large bags of capabilities to run at all. Whether the answer is per-launch disposable Unix boxes, bug-for-bug emulation, mechanical source translation, or something else is unresolved.

- [cap-talk-2002-2003--eros-legacy-deployment-path](../sections/cap-talk-2002-2003--eros-legacy-deployment-path.md) - Cox's be-both optimism against Laurie's decomposition skepticism.
- [cap-talk-2002-2003--saving-the-unix-api-and-reframing-boxing](../sections/cap-talk-2002-2003--saving-the-unix-api-and-reframing-boxing.md) - the incompatible designation model and the disposable-box reframing.

### 16. How can a capability system offer diagnostics without leaking authority?

Exceptions with stack traces and logging are ordinary developer conveniences, but a stack trace lets an object observe its own call chain, information its callers never granted, and logging can compromise confinement if carelessly designed. The scheme that works in a strongly-typed setting is unlikely to carry over to a pure capability language; the resolution moved to e-lang and is not settled on cap-talk.

- [cap-talk-2002-2003--exceptions-and-logging-in-capability-systems](../sections/cap-talk-2002-2003--exceptions-and-logging-in-capability-systems.md) - Plotnikov's framing of the stack-trace leakage problem.

### 17. Do Granovetter introductions fully model human encounters?

Close argues that every trust relationship aggregates introductions and that only connectivity begets connectivity. Finney, Wagner, and van Gelderen press chance meetings and gradual familiarity as counterexamples. Treating the shared physical world, proximity, or the senses as an introducer preserves the graph account, but weakens "introduction" to connectivity without endorsement. The archive converges on sparseness as the important boundary: random encounters are plausible in human spaces but negligible among cryptographic references.

- [cap-talk-2002-2003--trust-introductions-and-no-omniscience](../sections/cap-talk-2002-2003--trust-introductions-and-no-omniscience.md) - the shared-world reconciliation and the sparse-reference qualification.

### 18. Where was the original HRU paper available online in 2003?

The October subject line contains only Ganor's request for the Harrison-Ruzzo-Ullman paper, with no answer in the captured bundle. This is an unresolved bibliographic question in the archive, not another treatment of the safety model.

- [cap-talk-2002-2003--hru-paper-source-request](../sections/cap-talk-2002-2003--hru-paper-source-request.md) - the source request and pointer back to the substantive June discussion.

### 19. What does confinement constrain when a hostile holder can proxy?

Shapiro's 2004 "crisis of confidence" separates restricting direct capability transfer from restricting effective authority. A hostile holder with an allowed communication path can proxy an operation even when it cannot transfer the underlying reference. The list preserves POLA and controlled connectivity as useful properties, but does not recover a general non-proxying guarantee without additional confinement assumptions.

- [cap-talk-2004-2008--confinement-crisis-and-capdesk-pola](../sections/cap-talk-2004-2008--confinement-crisis-and-capdesk-pola.md)

### 20. Which component may convert authority into ordinary data?

Descriptor systems make references non-serializable unless the environment provides a transfer operation. Password capabilities can travel through ordinary protocols but may also leak through dumps, logs, or debugging. Proxies and scrubbing can close those channels locally, at the cost of making the runtime part of the security case. The archive does not select one universally superior representation.

- [cap-talk-2004-2008--capabilities-as-data-versus-descriptors](../sections/cap-talk-2004-2008--capabilities-as-data-versus-descriptors.md)
- [cap-talk-2004-2008--password-capability-safety](../sections/cap-talk-2004-2008--password-capability-safety.md)

### 21. Can a callee know the ultimate human invoker?

Delegation and proxying prevent a runtime caller label from proving who intended an effect. Explicit scoped credentials can state a useful attribution claim, but the list does not converge on a universal accountability layer that recovers human causation from reference exercise.

- [cap-talk-2004-2008--why-determining-the-invoker-is-the-wrong-question](../sections/cap-talk-2004-2008--why-determining-the-invoker-is-the-wrong-question.md)

### 22. Can a generic wrapper mediate every object correctly?

Identity tests, callbacks, returned references, exceptions, and protocol invariants defeat the idea of a completely transparent, protocol-independent wrapper. Useful membranes exist, but require a stated value-translation boundary and runtime assumptions. The universal claim remains false or underspecified.

- [cap-talk-2004-2008--generic-wrapping-and-membrane-limits](../sections/cap-talk-2004-2008--generic-wrapping-and-membrane-limits.md)
- [cap-talk-2004-2008--same-key-and-composite-identity](../sections/cap-talk-2004-2008--same-key-and-composite-identity.md)

### 23. Does a pure ocap substrate prevent confused deputies in hybrid applications?

No. The 2008 thread converges on the application caveat: code can rebuild an ACL lookup, firewall, or implicit rights amplification on top of object capabilities and become confusable again. What remains unsettled is how much protective machinery a platform should provide against this attractive nuisance.

- [cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies](../sections/cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies.md)

### 24. Does authority imply information flow?

The list distinguishes potential causal influence, possible communication, actual trace-level information transfer, and authority reachability. Small examples defeat attempts to collapse these into one relation. Authority-analysis tools must state which relation they compute.

- [cap-talk-2004-2008--authority-versus-information-flow](../sections/cap-talk-2004-2008--authority-versus-information-flow.md)

### 25. What durability guarantee should a persistent capability provide?

Persistent reference graphs can survive restarts, and causally ordered checkpoints can recover distributed consistency, but neither eliminates uncertain remote outcomes or replay. The open design boundary is how much retry, idempotency, and reference restoration belongs in the platform versus each application protocol.

- [cap-talk-2004-2008--persistence-session-failure-and-powerboxes](../sections/cap-talk-2004-2008--persistence-session-failure-and-powerboxes.md)

### 26. Who pays for shared durable state?

Space banks and sub-meters make allocation authority explicit, but shared references complicate responsibility after the creator delegates or disappears. Charging creators permits budget pinning; charging holders makes transfer and reclamation observable; partitions waste slack. The archive does not find a universally efficient policy.

- [cap-talk-2004-2008--capability-accounting](../sections/cap-talk-2004-2008--capability-accounting.md)
- [cap-talk-2004-2008--memory-accounting-without-partitions](../sections/cap-talk-2004-2008--memory-accounting-without-partitions.md)

### 27. What does a delegation account prove?

Horton can preserve a sealed chain describing who delegated a reference through which proxy, without making identity the authorization mechanism. It cannot by itself prove human intent, distinguish a compromised delegate, or prevent proxying. The right evidentiary claim for such provenance remains protocol-specific.

- [cap-talk-2004-2008--horton-accountability-without-authority](../sections/cap-talk-2004-2008--horton-accountability-without-authority.md)

### 28. Is trust a substitute for least authority?

No consensus accepts “authority must not exceed trust” as a replacement for POLA. Trust is observer-relative, while restricting even trusted components is part of what justifies trust. The unresolved part is who defines a component's intended function when users, developers, and deployers disagree.

- [cap-talk-2004-2008--authority-must-not-exceed-trust](../sections/cap-talk-2004-2008--authority-must-not-exceed-trust.md)

### 29. When may a UI gesture safely mint authority?

Designation-as-authorization avoids meaningless prompts, but only if a trusted path binds the user's gesture, its recipient, and its scope. The archive does not offer a universal rule for interpreting clicks, URLs, drag-and-drop, undo, and compound GUI transactions.

- [cap-talk-2004-2008--user-intent-as-authorization](../sections/cap-talk-2004-2008--user-intent-as-authorization.md)

### 30. Is non-delegatable authority useful beyond an expressiveness result?

A membrane can prevent transfer of the exact reference while an unconfined holder can still proxy its effects. The construction refutes a narrow impossibility claim, but may force permanent mediation and obstruct refactoring. Its practical benefit over ordinary attenuation and revocation remains disputed.

- [cap-talk-2004-2008--non-delegatable-authority](../sections/cap-talk-2004-2008--non-delegatable-authority.md)

### 31. How much persistence belongs in the language?

Transparent graph persistence preserves identity elegantly but cannot transparently restore sockets, clocks, files, remote peers, code upgrades, or uncertain outcomes. Explicit serialization exposes those boundaries at a higher programming cost. The division between platform and application remains open.

- [cap-talk-2004-2008--persistent-object-capability-language](../sections/cap-talk-2004-2008--persistent-object-capability-language.md)

### 32. Can ACL policy safely coexist with object capabilities?

The mature hybrid rule is plausible but conditional: capability references designate and bound maximum authority; ACL-like policy may subtract rights for administration or group removal. Whether practical systems can preserve that one-way narrowing without identity lookup adding authority remains an engineering question.

- [cap-talk-2004-2008--acls-and-object-capabilities-coexistence](../sections/cap-talk-2004-2008--acls-and-object-capabilities-coexistence.md)

### 33. Under what assumptions is authority non-increasing?

Reference reachability does not spontaneously grow in a closed graph, but active principals can receive messages, exercise amplifiers, and benefit from changing state. Any monotonicity theorem must state which inbound channels and protocols are excluded.

- [cap-talk-2004-2008--principal-authority-monotonicity](../sections/cap-talk-2004-2008--principal-authority-monotonicity.md)

### 34. Does per-holder petname naming conflict with provenance-sensitive message ordering?

Karp (January 2009) poses a tension between a petname system's rule that the same object always gets the same name and E-order's guarantee, which rides the specific delegated *reference*, not the object. A petname collapses a reference Bob already held and one Alice just gave him into one name, but only the delegated reference carries the ordering guarantee — so a petname UI hides which reference is ordering-bearing. Landau replies that references with different properties are, operationally, different references and should have different petnames, but that concedes a strictly object-identifying petname loses information the semantics need. Left unresolved: whether human-facing naming (identity by object) and machine semantics (identity by delegation edge) can be reconciled in one layer.

- [cap-talk-2009-2012--petnames-versus-e-order](../sections/cap-talk-2009-2012--petnames-versus-e-order.md) - the E-order-vs-petname statement and the is-it-a-bug-or-a-feature question.

### 35. Are object-capability systems really immune to confused deputies?

Toby Murray (February 2009) argues the immunity is overstated: a confused deputy can arise inside an ocap system whenever a service fails to validate a capability it is passed and that capability is more powerful in the service's hands than in the client's (via rights amplification). The defense is capability input-validation, which is why ocap systems build authentication in primitively (trademarks, final-type checks). The uncomfortable corollary: if the ocap fix reduces to "validate your inputs", an ACL/identity system can claim the same, weakening the confused-deputy argument. The replies sharpen (not settle) the distinction between eliminating a hazard by construction versus making it visible and locally guardable.

- [cap-talk-2009-2012--confused-deputies-in-capability-systems](../sections/cap-talk-2009-2012--confused-deputies-in-capability-systems.md) - Murray's argument and the ensuing debate.

### 36. Where does a browser hold the user's powerbox when a capability is a URL?

Chip Morningstar (March 2009) shows that if all authority rides web-keys, a browser can hold authority only in bookmarks, history, or open-page state — and bookmarks/history are unreliable roots for a web UI, while a server-held powerbox handed back at login breaks on ordinary navigation (the next page lacks the authorities and cannot even synthesize a "Home" link). His two escapes each sacrifice something: never leaving the home page (breaks the web's bookmark/link nature) or a per-page powerbox module keyed by a session cookie (which is "in essence a webkey held in a cookie", reintroducing the ambient authority web-keys were meant to remove). The architectural tension between capabilities-in-URLs and the stateless, linkable Web is left open.

- [cap-talk-2009-2012--webkeys-vs-the-web](../sections/cap-talk-2009-2012--webkeys-vs-the-web.md) - the three roots of browser authority, the navigation break, and the two unsatisfactory approaches.

### 37. Does creating an object imply a permanent inspection capability?

Creation, resource sponsorship, authorship, and reflective control are often called “parenthood,” but they need not belong to one principal. Retaining inspection helps maintenance and recovery; withholding it can be the confinement guarantee the instance was created to provide. KeyKOS's factory-plus-instance-creator construction suggests explicit cooperative debug authority, but the archive does not settle a universal default.

- [cap-talk-2013-2016--pola-creator-authority-visibility-and-revocation](../sections/cap-talk-2013-2016--pola-creator-authority-visibility-and-revocation.md)

### 38. Can renewable, expiring grants replace stateful membranes?

Continuous renewal makes current grants visible and bounds the lifetime of a leak, but it shifts security into clocks, overlap windows, liveness, and partition behavior. The proponent did not supply the requested concrete example proving that recursive membrane behavior can be recovered without equivalent state.

- [cap-talk-2013-2016--reactive-expiry-versus-stateful-membranes](../sections/cap-talk-2013-2016--reactive-expiry-versus-stateful-membranes.md)
- [cap-talk-2013-2016--substructural-reactive-capabilities](../sections/cap-talk-2013-2016--substructural-reactive-capabilities.md)

### 39. When does a cryptographic string remain an object capability?

Random webkeys, signed self-describing tokens, and macaroons can all be unforgeable bearer artifacts. They differ in whether the token designates one facet, whether use requires a pool of unrelated credentials, where attenuation is interpreted, and what state is needed for revocation. The list agrees that representation alone does not decide the category, but does not produce one accepted boundary.

- [cap-talk-2013-2016--iot-capabilities-as-cryptographic-strings](../sections/cap-talk-2013-2016--iot-capabilities-as-cryptographic-strings.md)
- [cap-talk-2013-2016--macaroons-capabilities-versus-credentials](../sections/cap-talk-2013-2016--macaroons-capabilities-versus-credentials.md)

### 40. Can identity policy narrow grants without recreating IBAC?

The proposed rule permits identity, roles, or labels to decide whether a new reference may be minted, while possession alone decides later use. This appears capability-compatible when policy only subtracts authority, but the object-to-recipient arrow still resembles an ACL and can drift into use-time identity checks. The one-way boundary remains an engineering invariant rather than a property guaranteed by the notation.

- [cap-talk-2013-2016--identity-policy-at-grant-time-not-use-time](../sections/cap-talk-2013-2016--identity-policy-at-grant-time-not-use-time.md)

### 41. What should joining two paths to one endpoint mean?

References carried through different membranes have distinct revocation, attenuation, ordering, and provenance. Revoking the joined result when either path is cut and revoking it only when both are cut each violate a plausible grantor expectation. Endpoint sameness, even when tested cooperatively, does not supply a policy for merging authority.

- [cap-talk-2013-2016--joining-references-across-membranes](../sections/cap-talk-2013-2016--joining-references-across-membranes.md)

### 42. Which layer should own sharing and revocation?

Capper can mint application-level webkeys, while Sandstorm wants the platform to provide sharing, audit, and revocation for the application. Both are capability-shaped, but composing them can produce duplicate policy, invisible outer grants, or an application protocol the platform cannot revoke precisely. The archive identifies the collision without a general layering rule.

- [cap-talk-2013-2016--capper-credentials-persistence-and-module-authority](../sections/cap-talk-2013-2016--capper-credentials-persistence-and-module-authority.md)

### 43. Is "defensive correctness up to resource exhaustion" usefully stricter than mere cooperative progress?

The July 2009 "controversial article" thread sharpens the gap between *defensive consistency* (no client can make a server give incorrect service to another — a safety property object-capability languages deliver by construction) and *defensive correctness* (consistency plus: no client can *prevent* correct service to another — a liveness/availability property). Full correctness is unattainable for co-located clients (one can loop forever or exhaust memory) and impossible over an unreliable network "almost by definition"; Miller offers a ladder of practical approximations, the load-bearing one being *defensive correctness up to resource exhaustion*, in which non-termination is folded into "resource exhaustion" and the standard reduces to a conventional liveness requirement. Miller explicitly declines to settle whether this standard is *usefully* stricter than plain cooperative progress ("we leave [it] to the judgement of the reader"), and the related question — whether E's unbounded message-buffering requirement means sender-side buffering is better for correctness — is raised and left open.

- [cap-talk-2009-2012--defensive-correctness-versus-consistency](../sections/cap-talk-2009-2012--defensive-correctness-versus-consistency.md) - the two definitions, why full correctness is not free (co-location, unreliable networks), and Miller's ladder of practical approximations.

### 44. Can ambient user authority be eliminated, or only reduced and rationed?

The December 2009 "Reducing Ambient user authority" thread proposes an OS with an install-time authority manifest, no command line (so no string→filename→capability resolution under ambient user authority), and an App→User→Group→Everyone escalation ladder with consent prompts. The reviewers press on the gap the thread's own title concedes — *reduce*, not *eliminate*. Two residues resist elimination: the escalation *consent prompt* is a human decision surface that "always allow" trains users to click through (ambient authority with extra steps), and *per-user application settings* keep an identity-indexed component — authority that follows the user rather than a designated reference, which is ambient by the designation criterion the June 2009 thread settled on. Whether an install-manifest-plus-escalation model genuinely removes ambient user authority or merely relocates and rations it is left unresolved.

- [cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest](../sections/cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md) - the manifest, the console-free design, the escalation ladder, and the reduce-vs-eliminate critique.

## See also

- [capability-theory](capability-theory.md) - where a question moves once it is settled.
- [[principle-of-least-authority]], [[confused-deputy]] - concepts the equivalence question turns on.
