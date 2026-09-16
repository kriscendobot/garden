# cap-talk provenance for Endo's capability model

> Abstract: What the cap-talk mailing-list archive (founded 1998 by Jonathan Shapiro of EROS) says that bears directly on Endo's design and open questions. Endo is an object-capability platform; several of its load-bearing patterns, including caretaker revocation, connectivity discipline, distributed capability transport, durable retention, eventual send, powerboxes, and refusal to designate authority by identity, were argued out on cap-talk years before or while they were formalized in the Miller and Close papers Endo cites. This file flags the concrete connections so an Endo contributor can reach the primary sources from the project tree, not only from the library. The era indexes run from [`../../library/sources/cap-talk-1998.md`](../../library/sources/cap-talk-1998.md) through [`../../library/sources/cap-talk-2009-2012.md`](../../library/sources/cap-talk-2009-2012.md).

## Revocation: destroyable indirection is the caretaker

Shapiro's 1998 EROS revocation primitive hands the holder a capability to a *destroyable indirection object* rather than to the target, so destroying the indirection rescinds access without disturbing any other reference. This is the primary-source ancestor of the pattern Endo and Agoric call the **caretaker**, and of the library's [revocation-by-withdrawal](../../library/concepts/revocation-by-withdrawal.md) concept. Charles Landau's companion point says a *rescinded key must return a message just like any other key*. Endo and E instead make a broken reference a *distinguishable* terminal state a client can react to (`_whenBroken`). The tension between transparent revocation and reactable broken references matters for Endo's disconnection and disincarnation semantics.

- [`../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md`](../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md)
- [`../../library/sections/cap-talk-1998--rescinded-keys.md`](../../library/sections/cap-talk-1998--rescinded-keys.md)

## The connectivity discipline

"You can only transmit a capability by invoking some other capability that you already have" (Shapiro, 1998) is the operational statement of *only connectivity begets connectivity*, the axiom Endo's whole reachability and retention story rests on. The corollary that objects are *allocated, not created* (a space bank sells storage; the payer can reclaim it) is a direct antecedent of Endo's explicit-storage-accounting stance over transparent garbage collection.

- [`../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md`](../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md)

## Designation, not identity

Endo's refusal to grant authority by ambient identity is exactly Shapiro's argument that a capability fuses designation and authority while an ACL must reconstruct "who is calling" and can be fooled. The later proxy-attribution debate adds a limit to telemetry claims: an audit record can prove which reference was exercised, but not whether its named holder acted directly, delegated, proxied, or was confused.

- [`../../library/sections/cap-talk-1998--card-keys-are-capabilities.md`](../../library/sections/cap-talk-1998--card-keys-are-capabilities.md)
- [`../../library/sections/cap-talk-1998--acls-on-capabilities.md`](../../library/sections/cap-talk-1998--acls-on-capabilities.md)
- [`../../library/sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md`](../../library/sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md)

## Authentication produces a capability set

The April 1998 CGI thread gives Endo a practical gateway rule: authenticate at the protocol edge, then deliberately map the result to the smallest and weakest **bucket of capabilities** sufficient for the session. The bucket is the operational identity past the authenticator. Authentication does not justify ambient socket creation, file-system access, or a machine-wide user object.

- [`../../library/sections/cap-talk-1998--cgi-confinement-and-capability-buckets.md`](../../library/sections/cap-talk-1998--cgi-confinement-and-capability-buckets.md)

## Distributed references are more than RPC object identifiers

The October 1999 thread names the distinction Endo's CapTP must preserve. The tuple "object ID, method ID, arguments" only has capability meaning if possession authorizes invocation, an endpoint cannot forge designation of an arbitrary hidden object, reference identity survives transport, and introductions are mediated. Miller's closure connection gives the local half of the same model: a closure's captured state is its authority-bearing acquaintance set.

- [`../../library/sections/cap-talk-1999--distributed-capabilities-rpc-and-closures.md`](../../library/sections/cap-talk-1999--distributed-capabilities-rpc-and-closures.md)

## Retention, reclamation, and covert channels

Landau's shared-object puzzle shows why cross-peer retention needs explicit per-holder state and a cleanup signal when a holder disappears. Shapiro, Miller, and Frantz then expose a second-order hazard: returning storage when the last capability disappears can reveal that event through observable quota. Endo's formula retention graph should therefore treat retention changes as authority-sensitive state and avoid promising that local reclamation is information-free.

- [`../../library/sections/cap-talk-1999--shared-object-lifetime-reference-counting.md`](../../library/sections/cap-talk-1999--shared-object-lifetime-reference-counting.md)
- [`../../library/sections/cap-talk-1999--storage-gc-and-covert-channels.md`](../../library/sections/cap-talk-1999--storage-gc-and-covert-channels.md)

## Durable state is not transaction agreement

System-wide persistence can preserve a circular capability graph, but it does not eliminate lost commit acknowledgments, network failure, or check-then-update races. Endo's durable vats and formulas need application operations with explicit retry and idempotency semantics. Reconstructing the object graph after a restart answers "what survived," not "what did the remote caller learn before the failure."

- [`../../library/sections/cap-talk-1999--persistence-and-transaction-failure.md`](../../library/sections/cap-talk-1999--persistence-and-transaction-failure.md)

## Brands and generic makers

The 1999 Trusty Scheme exchange makes a subtle Endo API property explicit: the operation that creates sealer/unsealer or brand pairs may be generally available without weakening any generated pair. Authority comes from holding one of the matching references, not from exclusive access to the generic maker.

- [`../../library/sections/cap-talk-1999--rights-amplification-from-seals-and-equality.md`](../../library/sections/cap-talk-1999--rights-amplification-from-seals-and-equality.md)

## Off-line representation versus on-line protocol (the CapTP split)

The July 2001 web-standardization thread draws the distinction Endo's transport layer keeps to this day: a serialized, storable capability (an off-line *representation*, like a sturdyref or a swiss-number URL) is a different artifact from the live protocol that makes possession authorize invocation (an on-line *protocol*, like CapTP). Miller's own survey names E's `cap://` URI over Pluribus and Waterken's `https:` encoding as the two working instances, and rates SPKI only "approximately a capability system." Endo's OCapN inherits exactly this two-layer shape (locator/sturdyref plus CapTP), and the SPKI verdict is the primary-source ancestor of the reasons Endo does not treat authorization certificates as object capabilities.

- [`../../library/sections/cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md`](../../library/sections/cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md)

## A reference is its behavior, and facets are distinct capabilities

Landau's November 2000 argument that a capability is defined by its behavior under a message (not by an underlying object reference, and not by interface thinning) is the primary-source root of Endo's facet discipline and its `Far`/`Remotable` model: a read facet and a write facet over one state are genuinely different capabilities, not thinned views of a shared identity, and reference equality is behavioral (E's `==`, Endo's marshal identity). It also underwrites why Endo can pass different facets to different clients without leaking that they share an implementation.

- [`../../library/sections/cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference.md`](../../library/sections/cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference.md)

## The lambda-calculus lineage and confinement by immutability

Miller's July 2001 "two threads" history places the object-capability model Endo realizes in the lambda-calculus / Actors lineage (Rees's W7, Joule, E) rather than the OS access-matrix one, which is why a hardened lambda language (SES) can be capability-secure at all. The companion 2000 confinement thread shows E achieving confinement through *observable pure immutability* rather than kernel weakening, the direct ancestor of using `harden` and transitively-frozen objects as Endo's confinement lever.

- [`../../library/sections/cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus.md`](../../library/sections/cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus.md)
- [`../../library/sections/cap-talk-2000-2001--confinement-the-sw-model-e-immutability-and-keybits.md`](../../library/sections/cap-talk-2000-2001--confinement-the-sw-model-e-immutability-and-keybits.md)

## CapDesk and Polaris: dynamic authority at desktop scale

The 2004 discussion is the live workshop around *The Structure of Authority*: Shapiro's non-transferability/confinement doubts do not invalidate POLA, while the CapDesk demonstration makes just-in-time authority legible to practitioners who had rejected the abstract argument. The 2005 shatter-attack thread then shows the hard engineering boundary. A shared GUI message channel lets a low-authority application drive a high-authority PowerBox unless Polaris mediates or removes it.

- [`../../library/sections/cap-talk-2004-2008--confinement-crisis-and-capdesk-pola.md`](../../library/sections/cap-talk-2004-2008--confinement-crisis-and-capdesk-pola.md)
- [`../../library/sections/cap-talk-2004-2008--polaris-shatter-attacks-and-gui-confinement.md`](../../library/sections/cap-talk-2004-2008--polaris-shatter-attacks-and-gui-confinement.md)

## Web-keys and petnames: designation, authority, and human meaning

Endo's sturdy references inherit the web-key split: an unguessable reference supplies secure designation and authorization, but it does not supply a human-recognizable relationship name. Petnames layer user-controlled meaning over the reference through a trusted path. The 2008 web-key thread also supplies the application caveat that Close later formalizes: delegation, revocation, and persistent restoration must be explicit, and an ACL-shaped application can recreate a confused deputy on an ocap substrate.

- [`../../library/sections/cap-talk-2004-2008--firefox-identifiability-and-idn-spoofing.md`](../../library/sections/cap-talk-2004-2008--firefox-identifiability-and-idn-spoofing.md)
- [`../../library/sections/cap-talk-2004-2008--petname-toolbar-as-trusted-path.md`](../../library/sections/cap-talk-2004-2008--petname-toolbar-as-trusted-path.md)
- [`../../library/sections/cap-talk-2004-2008--web-keys-mashing-with-permission.md`](../../library/sections/cap-talk-2004-2008--web-keys-mashing-with-permission.md)
- [`../../library/sections/cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies.md`](../../library/sections/cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies.md)

## Eventual references and the named pattern lineage

Waterken's `ref_send` is a direct Java-library ancestor of Endo's eventual-send surface: sends return promises, permit pipelining, and carry failure through the reference protocol. The 2008 historical inventory then names the wider reusable family Endo draws on: sealers/trademarks, revocable forwarders/caretakers, membranes, powerboxes, and eventual references.

- [`../../library/sections/cap-talk-2004-2008--ref-send-eventual-reference-api.md`](../../library/sections/cap-talk-2004-2008--ref-send-eventual-reference-api.md)
- [`../../library/sections/cap-talk-2004-2008--object-capability-patterns-historical-inventory.md`](../../library/sections/cap-talk-2004-2008--object-capability-patterns-historical-inventory.md)

## Facets, endowments, and enforced dependency injection

The 2006 object/facet debate gives Endo's exo model a precise reading: each facet reference is a distinct authority-bearing object, even when several facets close over one state record. The 2008 dependency-injection comparison then explains SES compartments in familiar engineering terms. Constructor injection makes dependencies visible, but only an ocap runtime ensures omitted powers cannot be recovered through globals, reflection, or an untamed container. Endo endowments are dependency injection plus enforcement.

- [`../../library/sections/cap-talk-2004-2008--objects-facets-and-behavioral-identity.md`](../../library/sections/cap-talk-2004-2008--objects-facets-and-behavioral-identity.md)
- [`../../library/sections/cap-talk-2004-2008--object-capabilities-versus-dependency-injection.md`](../../library/sections/cap-talk-2004-2008--object-capabilities-versus-dependency-injection.md)
- [`../../library/sections/cap-talk-2004-2008--database-query-authority.md`](../../library/sections/cap-talk-2004-2008--database-query-authority.md)

## Budgets must travel with authority

The space-bank and memory-accounting threads are direct antecedents of explicit Endo resource powers. A service capability answers what an object may do; a separate sub-budget answers who sponsors the CPU, storage, or durable retention it consumes. Shared references prevent reachability alone from assigning responsibility, so Endo formula retention and quota designs should preserve visible sponsorship and reclamation authority.

- [`../../library/sections/cap-talk-2004-2008--capability-accounting.md`](../../library/sections/cap-talk-2004-2008--capability-accounting.md)
- [`../../library/sections/cap-talk-2004-2008--memory-accounting-without-partitions.md`](../../library/sections/cap-talk-2004-2008--memory-accounting-without-partitions.md)

## Deep attenuation and trusted user gestures

Deep attenuation says a restriction follows references obtained through the wrapper, but the 2007 thread shows why Endo cannot implement this as global method-name filtering: each interface must define its own read-only, revocable, or otherwise narrowed facet. The companion UI discussions generalize PowerBoxes. A trusted gesture can convey a narrow facet through file-open or drag-and-drop, while an untrusted application must not counterfeit the endpoint or upgrade the grant.

- [`../../library/sections/cap-talk-2004-2008--deep-attenuation-and-typed-operations.md`](../../library/sections/cap-talk-2004-2008--deep-attenuation-and-typed-operations.md)
- [`../../library/sections/cap-talk-2004-2008--user-intent-as-authorization.md`](../../library/sections/cap-talk-2004-2008--user-intent-as-authorization.md)
- [`../../library/sections/cap-talk-2004-2008--attenuated-drag-and-drop.md`](../../library/sections/cap-talk-2004-2008--attenuated-drag-and-drop.md)

## Transport and policy boundaries

Several late-era threads sharpen boundaries around CapTP and sturdyrefs. SAML or another signed assertion can bootstrap an offline delegation, but the live object protocol should remain reference-based. Bearer capabilities leak through `argv`, logs, and URL machinery that assumes identifiers are public. ACL-like tenant policy can safely narrow an already-designated reference, but must not turn a powerless name into stronger authority. Authority-analysis tools must also state whether incoming messages and amplifiers are excluded before claiming authority cannot grow.

- [`../../library/sections/cap-talk-2004-2008--saml-assertions-versus-object-capabilities.md`](../../library/sections/cap-talk-2004-2008--saml-assertions-versus-object-capabilities.md)
- [`../../library/sections/cap-talk-2004-2008--capabilities-in-argv-leakage.md`](../../library/sections/cap-talk-2004-2008--capabilities-in-argv-leakage.md)
- [`../../library/sections/cap-talk-2004-2008--capability-urls-in-practice.md`](../../library/sections/cap-talk-2004-2008--capability-urls-in-practice.md)
- [`../../library/sections/cap-talk-2004-2008--acls-and-object-capabilities-coexistence.md`](../../library/sections/cap-talk-2004-2008--acls-and-object-capabilities-coexistence.md)
- [`../../library/sections/cap-talk-2004-2008--principal-authority-monotonicity.md`](../../library/sections/cap-talk-2004-2008--principal-authority-monotonicity.md)

## Concurrency assumptions are part of a pattern

Authodox's CSP models show that a caretaker or membrane can preserve its advertised property under one concurrency model and fail under another. Endo pattern documentation should name turn, reentrancy, and callback assumptions. Chrome's renderer sandbox supplies the systems-level analogue: process separation helps, but the broker protocol and stripped ambient powers determine the actual authority boundary.

- [`../../library/sections/cap-talk-2004-2008--authodox-object-capability-analysis.md`](../../library/sections/cap-talk-2004-2008--authodox-object-capability-analysis.md)
- [`../../library/sections/cap-talk-2004-2008--chrome-sandbox-and-brokered-authority.md`](../../library/sections/cap-talk-2004-2008--chrome-sandbox-and-brokered-authority.md)

## Persistence does not erase partial failure

The 2008 persistence exchange reinforces the earlier transaction lesson. A durable reference graph and causally consistent checkpoints do not tell a caller whether an unacknowledged operation happened. Endo's durable promises, formulas, and vats still need explicit retry and idempotency semantics. A persisted project must restore actual references through a PowerBox-like trusted mechanism rather than turn them into editable ambient names.

- [`../../library/sections/cap-talk-2004-2008--persistence-session-failure-and-powerboxes.md`](../../library/sections/cap-talk-2004-2008--persistence-session-failure-and-powerboxes.md)

## The web era: ACLs-don't, web-keys, and confused deputies inside ocap

The 2009 archive is where the capability argument meets the Web that Endo now targets, and it sharpens four things Endo still has to get right. First, **the equivalence is still not settled in the wider world**: Tyler Close's "ACLs don't" paper is rejected from Oakland-09 as "probably done before" even as reviewers concede the access-matrix equivalence is "incorrect" — the same fight Shapiro had in 1998, and the reason Endo's docs must keep making the capabilities-vs-ACLs case explicitly rather than assuming it. Second, **object capabilities are not automatically confused-deputy-proof**: Toby Murray shows a service that performs rights amplification (an unsealer, a mint, a facet that upgrades a client reference) can be confused if it does not validate the capabilities it accepts — the primary-source argument for Endo's `Far`/`Remotable` marking, brand/trademark checks, and pattern guards. Third, **CSRF is sharing seen from the attacker's side** (Zooko): the defense is unforgeable references, not unshareable ones, and an authority-carrying session cookie is "in essence a webkey held in a cookie" — a caution for any Endo web gateway not to default the powerbox into an ambient credential. Fourth, **a capability whose whole representation is a URL has nowhere stable to live in a browser session** (Chip Morningstar's web-key/powerbox problem) — precisely the tension Endo's OCapN answers by keeping a durable locator/sturdyref separate from the live CapTP protocol.

- [`../../library/sections/cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09.md`](../../library/sections/cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09.md)
- [`../../library/sections/cap-talk-2009-2012--confused-deputies-in-capability-systems.md`](../../library/sections/cap-talk-2009-2012--confused-deputies-in-capability-systems.md)
- [`../../library/sections/cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable.md`](../../library/sections/cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable.md)
- [`../../library/sections/cap-talk-2009-2012--webkeys-vs-the-web.md`](../../library/sections/cap-talk-2009-2012--webkeys-vs-the-web.md)
- [`../../library/concepts/web-key.md`](../../library/concepts/web-key.md)

## Ambient authority is the hazard; defensive consistency is what Endo guarantees

The rest of 2009 makes two design invariants that Endo enacts explicit. First, **ambient authority is defined by the absence of designation, and eliminating it is the whole point**. The June 2009 encyclopedia thread rejects "shared-with-all" and "no-credential" definitions and settles on *designation* as the discriminator — authority is ambient exactly when the caller does not designate the specific capability an action needs, so a system that presents tokens still has ambient authority if a "helper" facility auto-selects which one to apply. This is precisely what Hardened JavaScript's `lockdown()` reverses (no ambient IO, no mutable shared globals, modules receive only explicitly-passed endowments), and the caution — beware any framework that *automatically* attaches authority on a caller's behalf — is why Endo prefers statically-wired, designated endowments and a `package.json` `powers` manifest over runtime authority-escalation dialogs (the December 2009 "reducing ambient user authority" thread's install-time manifest is the same idea, and its unresolved "consent prompts habituate re-granting" worry is the argument against runtime escalation). Miller's June 2009 CORS/Origin critique — origin-based cross-site access decisions *amplify* ambient authority and leave the browser-as-confused-deputy (CSRF) in place; "a mashup is a self inflicted cross site script" — is the browser-platform motivation for the whole SES/compartment program: code composed into a context must receive only what it was given, not the context's ambient origin-authority. Second, **defensive consistency is what an object-capability language guarantees; defensive correctness is not free**. The July 2009 "controversial article" thread pins the safety/liveness split: SES delivers defensive consistency by construction, but defensive correctness (no client can *deny* another correct service) fails for co-located clients (infinite loop, memory exhaustion) and is impossible over unreliable networks — so Endo/Agoric adopt Miller's third approximation, *budgeted, preemptively-reclaimable resources* (metering and per-vat budgets), and favor Functionally-Pure exos across separate vats.

- [`../../library/sections/cap-talk-2009-2012--defining-ambient-authority.md`](../../library/sections/cap-talk-2009-2012--defining-ambient-authority.md)
- [`../../library/sections/cap-talk-2009-2012--origin-header-amplifies-ambient-authority.md`](../../library/sections/cap-talk-2009-2012--origin-header-amplifies-ambient-authority.md)
- [`../../library/sections/cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md`](../../library/sections/cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md)
- [`../../library/sections/cap-talk-2009-2012--hiding-webkeys-from-the-address-bar.md`](../../library/sections/cap-talk-2009-2012--hiding-webkeys-from-the-address-bar.md)
- [`../../library/sections/cap-talk-2009-2012--defensive-correctness-versus-consistency.md`](../../library/sections/cap-talk-2009-2012--defensive-correctness-versus-consistency.md)
- [`../../library/concepts/ambient-authority.md`](../../library/concepts/ambient-authority.md)

## Petnames name objects; the wire names references

Endo's petname layer (petnames, petname-paths, edgenames) and its formula/locator naming inherit the 2009 warning that per-holder, object-identifying naming can *hide* distinctions the machine layer needs — Karp's petname-versus-E-order question shows two references to the same object obtained by different delegation paths carry different ordering guarantees a single petname would erase. Zooko's Tahoe file-API experience gives the concrete pattern for code that needs relative naming: pass a *(container capability, leaf name)* tuple, not a bare self-reference or an ambient path.

- [`../../library/sections/cap-talk-2009-2012--petnames-versus-e-order.md`](../../library/sections/cap-talk-2009-2012--petnames-versus-e-order.md)
- [`../../library/sections/cap-talk-2009-2012--file-api-taming-tahoe.md`](../../library/sections/cap-talk-2009-2012--file-api-taming-tahoe.md)
- [`../../library/concepts/petname.md`](../../library/concepts/petname.md)

## Managed references, guards, and compilation boundaries

The August-October 2009 threads spell out three assumptions behind Hardened JavaScript. First, an ordinary managed-language object reference can be the capability only after unsafe pointer construction, ambient statics, reflection escapes, and untamed host APIs are removed. Second, well-known guards for pure data are designated validators, not ambient authority, while a guard that recognizes a "real" file or another external power must itself be explicitly endowed. Third, a bytecode verifier that prevents memory corruption is not enough: compiled or supplied bytecode must preserve the source language's semantic invariants, because verifier-accepted target code may construct values no source program can express. SES transforms, bundles, XS bytecode, and serialization boundaries all inherit that full-abstraction obligation.

- [`../../library/sections/cap-talk-2009-2012--managed-language-object-references-as-capabilities.md`](../../library/sections/cap-talk-2009-2012--managed-language-object-references-as-capabilities.md)
- [`../../library/sections/cap-talk-2009-2012--guards-well-known-not-ambient.md`](../../library/sections/cap-talk-2009-2012--guards-well-known-not-ambient.md)
- [`../../library/sections/cap-talk-2009-2012--full-abstraction-at-the-bytecode-boundary.md`](../../library/sections/cap-talk-2009-2012--full-abstraction-at-the-bytecode-boundary.md)

## Browser and broker grants should be explicit, narrow, and visible

The CORS and geolocation threads show the same deputy failure at two browser surfaces. Origin policy automatically supplies cookies or sensitive device authority when the requesting component did not designate a particular grant, while multi-origin composition prevents the user from seeing which principal receives it. Endo powerboxes and web gateways should instead return a narrow session facet, keep sensitive use visible and revocable, and restore persistent authority only through a specifically designated sturdy reference. The RabbitMQ case adds the deployment warning: if a protocol starts with broker-side ACLs, later capability adoption can require coordinated changes across every client even when the checking mechanism itself is small.

- [`../../library/sections/cap-talk-2009-2012--cors-open-review-and-ambient-cookies.md`](../../library/sections/cap-talk-2009-2012--cors-open-review-and-ambient-cookies.md)
- [`../../library/sections/cap-talk-2009-2012--geolocation-origin-authority-and-ui.md`](../../library/sections/cap-talk-2009-2012--geolocation-origin-authority-and-ui.md)
- [`../../library/sections/cap-talk-2009-2012--rabbitmq-capabilities-rejected-by-deployment-friction.md`](../../library/sections/cap-talk-2009-2012--rabbitmq-capabilities-rejected-by-deployment-friction.md)

## Process confinement and object-capability protocols are separate layers

Native Client's brokered sandbox demonstrates why Endo should not call every handle a capability. An OS or process boundary limits effects after compromise, but only the broker protocol determines whether possession designates and authorizes one object or whether ambient identity and names still manufacture authority. XS workers and native subprocess brokers need both layers: coarse machine isolation outside and an explicitly reference-based message surface inside.

- [`../../library/sections/cap-talk-2009-2012--nacl-descriptors-confinement-not-capabilities.md`](../../library/sections/cap-talk-2009-2012--nacl-descriptors-confinement-not-capabilities.md)

## The final Pipermail era: direct Endo design antecedents

The 2013-2016 archive lands close to Endo's present architecture. Persistent objects do not erase the need for an explicit upgrade schema; hostile transport bytes should become validated immutable values before ordinary code sees them; and a return continuation is a narrower capability than a callback reference. `DeepFrozen` receiver **and arguments** can relax E-order because no stateful effect remains to reorder. WeakMaps make identity-based rights amplification and private state direct JavaScript patterns. These are design constraints, not merely historical resemblance.

The same era supplies two cautions for Endo reference identity. A filesystem facet reached through a chain of redirects carries revocation-path provenance, and two remote references to one endpoint are not interchangeable when their membranes carry different revocation, ordering, or audit conditions. Transport-level endpoint discovery must not silently canonicalize away those distinctions.

Finally, the Capper experiment is an application-level sketch: keep durable credentials in a dedicated secret service, derive one narrow account facet, pass module authority explicitly, and store upgradeable state separately from live closure layout.

- [`../../library/sections/cap-talk-2013-2016--persistent-objects-schema-evolution-and-portability.md`](../../library/sections/cap-talk-2013-2016--persistent-objects-schema-evolution-and-portability.md)
- [`../../library/sections/cap-talk-2013-2016--capn-proto-zero-copy-at-untrusted-boundaries.md`](../../library/sections/cap-talk-2013-2016--capn-proto-zero-copy-at-untrusted-boundaries.md)
- [`../../library/sections/cap-talk-2013-2016--return-paths-are-limited-capabilities.md`](../../library/sections/cap-talk-2013-2016--return-paths-are-limited-capabilities.md)
- [`../../library/sections/cap-talk-2013-2016--deepfrozen-e-order-optimization.md`](../../library/sections/cap-talk-2013-2016--deepfrozen-e-order-optimization.md)
- [`../../library/sections/cap-talk-2013-2016--taming-constructors-and-weakmap-amplification.md`](../../library/sections/cap-talk-2013-2016--taming-constructors-and-weakmap-amplification.md)
- [`../../library/sections/cap-talk-2013-2016--filesystem-redirect-revocation-paths.md`](../../library/sections/cap-talk-2013-2016--filesystem-redirect-revocation-paths.md)
- [`../../library/sections/cap-talk-2013-2016--joining-references-across-membranes.md`](../../library/sections/cap-talk-2013-2016--joining-references-across-membranes.md)
- [`../../library/sections/cap-talk-2013-2016--capper-credentials-persistence-and-module-authority.md`](../../library/sections/cap-talk-2013-2016--capper-credentials-persistence-and-module-authority.md)

Scholar jobs `scholar-ingest-cap-talk`, `scholar-ingest-cap-talk-1999`, `scholar-ingest-cap-talk-2000-2003`, `scholar-ingest-cap-talk-2004-2008`, and `scholar-ingest-cap-talk-2004-2008-remainder` (2026-09-16), through the complete 2004-2008 monthly index; `scholar-ingest-cap-talk-2009-2012` (2026-09-16), the JavaScript / Caja / SES / web-key era first pass (2009 Q1); `scholar-ingest-cap-talk-2009-2012-remainder` (2026-09-16), the rest of 2009's fetchable standout threads (April webkey-hiding, June ambient-authority definition and Origin/CORS critique, July defensive correctness, December ambient-user-authority reduction) plus the `ambient-authority` concept page; `scholar-ingest-cap-talk-2013-2016` (2026-09-16), the final Pipermail slice through January 2016.
