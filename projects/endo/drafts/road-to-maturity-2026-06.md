---
created: 2026-06-11
updated: 2026-06-11
author: journalist
status: draft-for-maintainer-triage
identity_sensitive: true
project: endo
---

# The Road to Maturity

*Draft for maintainer review; not for publication or attribution until explicitly approved.*

*A successor to "A Choice of Giants." Where that essay named the problem and
gestured at Endo, this one shows the machine, lays out the road, and says
what a mature ecosystem would look like in terms specific enough to be
proven wrong.*

---

## I. The argument

Two years ago I wrote that we had a surplus of giants. The social, search,
and artificial-intelligence giants had herded us into their pens, and we
fed them for lack of a better option. The browser we still politely call a
"user agent" had stopped representing the user: a web page keeps an
umbilical cord to the server that served it, the user cannot cut that cord,
and so a vast network of pervasive surveillance is born. The app store
offered to guard the gate and used the gate to collect the rent. One does
not archive an app, keep an app, send an app to a friend, or pass an app on
to one's children. I proposed a better dream that begins with chat, where
all social problems and solutions begin and end: chat as a medium of
distribution for confined, saveable little applications, weblets, that must
obtain their authority through the grace of the user rather than holding it
ambiently. I said we should do that, in the open, with federation, on a
grander scale than has ever been seen before.

The essay named the dream. It did not show the engine. This document is the
engine.

Something has changed in two years that the essay could not have foreseen,
and it is worth being plain about it because it is the reason there is a
machine to describe rather than a manifesto to repeat. The problem found a
new and acute form. Agents arrived. A developer with an agent in Claude
Desktop or Cursor reaches for a tool, installs an integration, and hands
that integration a bearer token to an entire GitHub, a whole Notion, the
full surface of whatever it touches. The Model Context Protocol that wires
agents to tools has its own word for this in its own security guidance:
ambient authority. The guidance recommends least privilege; the guidance is
advisory; most shipping integrations grant everything up front to save a
later prompt. The over-permissioning the essay described in the abstract is
now a board-level worry with a name, and it arrived on a schedule that no
capability project before this one enjoyed. The remedy is thirty years old.
The demand is new.

So the argument widens by one move, and the move is the whole of the
platform thesis. Endo is not a confinement tool and it is not a privacy
posture. It is a platform for selectively empowering peers, applications,
and agents with capabilities. The harness and the sandbox do not merely
keep things apart; they allow a party that holds authority to endow another
party with a narrow, revocable slice of it. An agent in this model holds no
authority of its own. It proposes the attenuation it would like, as code,
derived from interface and behaviour descriptions, and review and endowment
stay with the party that actually holds the right to grant, ultimately the
user. The trusted compute base is the user's own agent, the Familiar.
Inference, the thing everyone now treats as the load-bearing dependency, is
in this model a substitutable input: local, self-hosted, or bought from a
vendor you trust, never a cord to any one giant. The artifacts a user makes
are durable. The capabilities underneath are substitutable. There are no app
stores and therefore no app-store rents.

That is the dream made mechanical: not "trust no one" but "endow precisely,"
not "leave the platform" but "owe it nothing it has not earned." The rest of
this document is how the pieces compose, the order in which they arrive, and
how we will know when it is done.

## II. The machine

A machine is only as honest as its parts list, so I will name each piece and
say, in the design ledger's own words, where it stands. The ledger is
`designs/README.md` on the `llm` branch of `endojs/endo-but-for-bots`; it is
the only source of truth I will cite for status, and where it says Proposed
or In Progress I will not say shipped. Several pieces below are named gaps
with no design file yet; I will say so plainly rather than imply a drawing
that does not exist.

**The Familiar as trusted computing base.** Everything rests on the user's
own agent. The Familiar is the Electron shell that bundles the daemon and
presents chat as the medium through which capabilities are requested and
granted. Its foundations are landed: `familiar-electron-shell`,
`familiar-daemon-bundling`, `familiar-bundled-agents`, and
`familiar-gateway-migration` are all **Complete**. The unified weblet server
that will host application surfaces inside it (`familiar-unified-weblet-server`)
is **In Progress**, and the in-chat hosting pane (`familiar-chat-weblet-hosting`)
is **Not Started**. The point worth holding onto is that the trusted base is
not a future component. A person can download a Familiar today and drive an
agent with their own key and local capabilities; that was the exit criterion
of the first milestone, and the ledger records that milestone Complete.

**The daemon and its capabilities.** Beneath the Familiar sits the daemon,
which holds capabilities as first-class objects and hands them out under
hardened guards. The substrate here is unusually far along for an
unreleased system. The filesystem platform layer (`platform-fs`) is
**Complete**. The mount capability that hands an agent a directory as an
object rather than a path string (`daemon-mount-capabilities`) is
**Complete**, with the broader mount work (`daemon-mount`) **In Progress**.
The content-store garbage collection (`daemon-content-store-gc`) and
cross-peer retention sync (`daemon-cross-peer-gc`) are **Complete**. The git
capability that lets an agent read, edit, commit, and push against a
version-controlled tree (`daemon-git-capability`, `daemon-git-remotes`,
`daemon-git-next-steps`) is Proposed as forward design over substrate that
has largely landed. The four-layer registry-and-import stack that lets a
daemon worker import a package tree through the compartment mapper
(`registry-capability`, `mvs-resolver`, `snapshot-mapper`, and the
integration layer `daemon-worker-import-from-mount`) is **Proposed**. The
worker metering that counts a unit of computation (`daemon-xs-worker-metering`)
is **Complete**, which matters later when we get to billing.

**Agents as zero-authority proposers of attenuations.** This is the
conceptual hinge of the whole design and the part most easily misread, so I
will be careful. The agent does not receive a broad grant and promise to
behave. It receives nothing, and proposes the narrow thing it needs. The
machinery that makes this real is partly landed and partly designed. The
guest-eval simplification that removed the old proposal handshake
(`daemon-guest-eval-simplification`) is **Implemented**. The agent tool
surface that an agent actually drives (`daemon-agent-tools`) is **Not Started**.
The confinement that keeps a proposing agent from reaching past its
endowment (`endo-posix-sandbox`) is **In Progress**, Phases 0 and 1 shipped.
The discipline is therefore real where the substrate has landed and a
roadmap where it has not; I would not claim a fully confined zero-authority
agent runs end to end today.

**Policy as code, reviewed by the user.** Because the agent proposes
attenuations as code, the thing the user reviews is legible. This is the
direct descendant of Polaris confining an unmodified Excel: the system
intercepts the request and conveys only the chosen authority, not a handle to
everything. In Endo this is the trust-on-first-bind pattern
(`trust-on-first-bind`, a **Reference** design) for prompt-and-pin grants,
and the form-request and value-message machinery (`daemon-form-request`,
`daemon-value-message`, both **Complete**) for the dialogue itself. The
user-facing review surface beyond chat is mostly Not Started; the
substrate it would sit on is mostly done.

**Attestations: signed, endorsed, reused across a community.** Here I must be
honest that the machine has a hole. The vision calls for capability and
policy attestations that one party signs, another endorses, and a community
reuses, so that a good attenuation policy can be shared the way a good
recipe is shared. The substrate exists: per-agent network identity gives the
signing key (`daemon-agent-network-identity`, on which the ledger and the
design file disagree, see the discrepancy note below), and the secure
transport to carry an endorsement exists. But there is **no design file for
the attestation format, the endorsement graph, or the policy market**. This
is a named future, not a drawn one. I flag it as the largest gap between the
vision and the ledger, and the maturity section returns to it as the thing
whose absence is most measurable.

**Substitutable inference.** The thesis insists inference is an input, not a
dependency. The ledger supports this in the agent-harness lineage: the
provider-registry-and-OAuth design (`endopi-provider-registry-and-oauth`,
Proposed, partially satisfied by the `packages/genie` package) and the
iterative-compaction work are the pieces that make the inference source a
configured choice rather than a wired-in vendor. The unit that meters
inference, the cogitron, is named in the roadmap but is **new vocabulary
with no design file**; see the resource-class gap below. Substitutability is
architecturally true and commercially under-specified.

**OCapN-Noise peering.** Federation rests on two daemons being able to find
each other and speak securely. The Noise-IK netlayer for OCapN
(`ocapn-noise-network`) is **Complete** and landed via a merged pull request;
it is the most load-bearing finished piece in the whole federation story.
The transport separation that makes relays and NAT traversal pluggable
(`ocapn-network-transport-separation`) is **In Progress**, and the
session-reconnect layer for members behind flaky links
(`ocapn-noise-session-reconnect`) is **Proposed**.

**The gateway: MCP termination and OAuth bonding.** This is the product
surface, and it is the part the road section is mostly about, so I will be
brief here and precise about status. The overarching gateway design
(`endo-gateway`) is **Proposed**, with its implementation in flight as a
stack of pull requests; the bearer-token authentication it extends
(`gateway-bearer-token-auth`) is **Implemented**. MCP termination
(`endo-gateway-mcp`) has its design merged but its implementation **Not
Started** in the ledger's terms. The two pieces that turn a self-host story
into a commercial front door, OAuth identity bonding (`gateway-oauth-bonding`)
and operator-side key recovery (`gateway-key-recovery`), are **named design
gaps with no design file**. The metering taxonomy (`gateway-resource-classes`)
and the Stripe billing adapter (`gateway-stripe-adapter`) are likewise
**named gaps**. I want this exact shape understood: the substrate is largely
built and merged, the product layer is in flight, and the commercial layer is
specified and scheduled but not yet drawn. A subtlety the resequencing
proposal surfaces and I will not paper over: the gateway-package, AWS, and
packaging-CI designs the ledger lists as Proposed are not actually present on
the `llm` branch; they live on an unmerged pull-request branch. The ledger
presents them as extant; they are not yet. This is one of the discrepancies
recorded at the end.

**Weblets and chat as the medium of distribution.** This is where the 2024
essay's promise becomes a feature. A weblet is a confined, saveable
application delivered through chat; the designs that make it real
(`daemon-weblet-application`, `familiar-app-ui-hosting`, the app-sharing cut)
are **Proposed** or **Not Started**. The substrate they sit on, the unified
weblet server and the exo-zip package that gives a weblet a durable backing
(`exo-zip-package`, **Proposed**), is partly in flight. Chat itself, the
medium, is the most finished surface in the system: the chat UI designs are
almost uniformly **Complete**. The medium is built; the thing it will
distribute is designed.

**Federated hubs.** The community shape, one operator serving many members,
is the second commercial objective and the federation seed. Its most precise
description in the ledger is a single deferred open question inside the
gateway design: a variant of the gateway that manages virtual users rather
than system-level user daemons. That open question is the spine of the whole
community-hub idea, and it is **explicitly deferred**. The member-onboarding,
multi-tenancy, hub-economics, abuse-moderation, and operator-liability
pieces are all **named gaps with no design files**, enumerated in the
resequencing proposal. The federation the essay called for is, in ledger
terms, almost entirely ahead of us. The transport it will run on is done.

A machine described this honestly does not read as finished, and it is not.
What it reads as, I hope, is a substrate that is real and merged, a product
layer in active flight, and a commercial-and-community layer that is named,
sequenced, and undrawn. That is the true state, and the road is how the
undrawn parts get drawn.

## III. The road

The hosted-gateway north star resolves into two staged objectives on one
body of technology, and the order is chosen so that each stage is a product
a person would pay for, not a way-station toward an ideology. The staging
below follows the resequencing proposal of 2026-06-11
(`resequencing-2026-06.md`), which is a **draft for maintainer triage, not an
applied ledger edit**. Where I describe a milestone renumbering or a new gap
file, I am describing the proposal, not settled fact; the milestone numbers
the ledger carries today are M1 through M11, and the proposal would insert
one new milestone and shift the tail down by one. I mark the proposed shape
as proposed throughout.

**O1, the turn-key self-custodial node.** A user deploys a node from a cloud
marketplace listing, AWS first, in one sitting. The node terminates MCP for
external clients, bonds an OAuth identity to the user's public-key identity,
meters and bills resources, and grants agents attenuated capabilities. The
customer is the operator and the operator is the user.

The proposal re-derives the critical path and corrects one instinct worth
stating, because it changes what "almost done" means. The visible product
feature, MCP termination, is **not** on the longest chain to O1. It can begin
as soon as three gateway phases land (the UDS bootstrap, the apps name hub,
and the resource ledger) and runs in parallel with everything else. The
binding constraint is the packaging-and-listing track: the gateway phases
that produce a deployable image (HTTPS proxy compatibility and operating-system
packaging), which the proposal promotes from a deferrable tail to load-bearing
work, because for a marketplace listing the packaged image *is* the product.
Behind that sit gaps the ledger does not fully name and the proposal does:
the bundled TLS-and-first-boot certificate story (the gateway refuses to
terminate TLS by design, so the appliance must terminate it somewhere inside
the image and obtain a certificate autonomously at first boot), the
first-boot ceremony by which an operator securely receives their initial
bearer before any other channel of trust exists, and the marketplace-listing
requirements themselves, including a two-to-four-week listing review that is a
calendar tax rather than an effort estimate.

The commercial layer for O1 is the four gaps: OAuth bonding, key recovery,
the Stripe adapter, and the resource-class taxonomy. The proposal pulls the
two identity gaps (bonding and recovery) forward into the current design
window even though their implementation may trail, because pinning the
identity model early is cheap insurance against churn arriving after paying
customers exist. It also unfolds the resource-class taxonomy into its own
design rather than letting it hide inside the Stripe adapter, on the
principle that customers forgive rough edges but not metering they cannot
predict. The metering units deserve one plain sentence here, since the
persuasion writing will inherit it: computrons (compute) and cogitrons
(inference) are units of resource accounting, like kilowatt-hours, not
crypto assets and not a token to be traded.

The O1 exit criterion, in the ledger's own words: a user signs into a hosted
gateway via OAuth, purchases tokens via Stripe, drives Endo agents over MCP
from an external client such as Claude Desktop or Cursor, and can recover
their identity if they lose their bearer. One open decision the proposal
flags for the maintainer: whether that exit criterion requires OAuth bonding
*implemented*, or whether O1 may ship on the already-implemented bearer-token
auth with OAuth bonding as a fast follow.

**O2, the community hub.** The same node software operated by one person for
many members, providing the services a good internet service provider once
did: relaying and NAT traversal, mail delivery, anonymisation, curation,
always-online capabilities. Members onboard by invitation; the unit of trust
widens from the single operator to the community. The structural point, and
the reason O2 is not a separate product line, is that every O1 customer is a
latent O2 operator. The commercial channel and the federation seed are the
same artifact. We do not solve federation's cold-start problem by evangelism;
we sell single-operator nodes that are community hubs waiting for a second
member.

O2's technical prerequisites all complete in the O1 milestones. What is
distinctively O2 (the virtual-users multi-tenancy mode that is the deferred
gateway open question, member isolation on one node, hub economics, abuse
moderation given that end-to-end encryption means the operator cannot read
member traffic, and the operator-liability survey the canon's
Mastodon-instance worry demands) is currently scattered or undrawn. The
proposal would gather it into a dedicated community-hub milestone inserted
directly after the O1-completing milestone, on the logic that O2 is the next
thing after O1 ships, not a far-future item. That insertion is the one
structural change the proposal makes to the milestone numbering, and it
shifts the later milestones (weblets and integrations, peer app sharing, UX
and tooling, confinement and ecosystem, and the Rust daemon `endor`) down by
one. Again: proposed, not applied.

**The ecosystem milestones.** After O1 and O2 come the milestones that make
the 2024 essay's dream fully concrete. Weblets and integrations
(`familiar-chat-weblet-hosting`, `daemon-weblet-application`, agent-side OAuth
and webhooks) deliver the confined, saveable applications distributed through
chat. Peer app sharing (`endo-app-sharing`, `familiar-deep-link-invitations`,
`familiar-app-ui-hosting`) delivers "make a thing, send it to a friend, they
run it" with the application's interface in a partial sandbox. Confinement
and ecosystem (`endo-posix-sandbox` completion, `daemon-capability-bank`,
`daemon-capability-persona`, the channel bridges and skill registry) delivers
full least-authority confinement and the plugin ecosystem. The Rust daemon
`endor` is last in the sequence by design, because it is a research-heavy port
that does not feed the commercial north star. Every one of these milestones'
dependencies lives in an earlier milestone; that invariant is the spine of
the ordering and the proposal preserves it.

**Funding the commons, said honestly in both directions.** The
commercialisable component, O1 and then O2, funds the development of the
commons. I want to be candid about this relationship the way the persuasion
writing must be. The commons is not a loss leader we tolerate to look
virtuous; it is the substrate the product is built from, and starving it
starves the product. And the product is not a betrayal of the commons; it is
how a commons that has historically had the remedy and no revenue finally
gets a revenue that is aligned with it rather than opposed to it. The first
wave of capability systems, E and CapDesk and Polaris, were correct and
unfunded. The thing that is different this time is not only that the demand
arrived; it is that the commercial vehicle and the commons are the same
machine, sold one way and given another, with no contradiction between the
two because the attenuation discipline is what both the buyer and the
community want.

## IV. Maturity

It is easy to call a thing mature when one is tired of building it. I would
rather name the properties a mature ecosystem exhibits and, for each, a sign
that can be measured, so that progress is falsifiable rather than a feeling.
A property without a measurable sign is a vibe, and vibes are how projects
lie to themselves.

**Durable artifacts.** In a mature ecosystem the things a user makes outlive
the service that hosted them. A weblet saved today opens in five years; a node
exported from one cloud restores on another; nothing the user owns is hostage
to a vendor staying in business. *Measurable sign:* a node's full state
(content store, formula store, keys, configuration) exports to a portable
format and restores on a different host with verified integrity, and the
round trip is exercised in continuous integration, not asserted in a brochure.
Today this is a named gap (`gateway-state-custody`) with no design file; the
sign is currently red, and "you can leave" is a promise the architecture
makes but the test suite does not yet keep.

**Substitutable everything.** In a mature ecosystem no single input is
load-bearing: not the inference provider, not the cloud, not the operator,
not the transport. *Measurable signs:* the same agent runs unchanged against
a local model, a self-hosted model, and a vendor model, with the cost
reported in the same metering unit across all three; a node migrates between
two clouds and a homelab without code change; a capability is revoked and
re-granted from a different provider without the agent noticing. The
inference half of this is architecturally present and commercially
under-specified (the cogitron has no design file yet); the cloud half is the
state-custody gap above. The sign is amber: the architecture admits
substitution everywhere, and the proofs exist for some inputs and not others.

**Communities running their own hubs.** In a mature ecosystem the federation
is real: many operators run hubs for their people, and no operator is a
giant. *Measurable signs:* a count of independently operated hubs that is
greater than one and growing without the project's authors operating them;
hubs peering with hubs over OCapN-Noise such that a member of one can be
endowed a capability held by another; the operator-liability posture written
down before the first hub serves a stranger rather than discovered in a
takedown notice. The transport this rests on is **Complete**; the hub itself
is almost entirely undrawn. The sign is red and will stay red until the
community-hub milestone produces design files; this is the honest long pole
of the whole vision.

**A market in attested policy.** This is the property that distinguishes a
mature capability ecosystem from a merely working one, and it is the property
the machine section flagged as most absent. In a mature ecosystem a person
does not author every attenuation from scratch; they adopt a policy someone
they trust has signed, that others have endorsed, and that they can read
because it is code. *Measurable signs:* an attestation format exists and is
signed by more than one party; a policy authored by one person is adopted,
unmodified and verifiably, by another; an endorsement graph exists such that
trust in a policy can be traced to a party the adopter already trusts. Today
there is **no design file** for any of this. The sign is red, and I name it as
the clearest single measure of how far the ecosystem is from mature: when a
stranger's attenuation policy can be adopted on the strength of an endorsement
chain, the dream of "do that in the open, with federation" has a market under
it. Until then it has a transport and an intention.

So the honest scorecard is one property amber and three red, sitting on a
substrate that is real and a product layer in flight. I do not find that
discouraging and I hope the reader does not either. The 2024 essay had four
properties and zero substrate; it was a dream with a link at the bottom. This
document has a machine with merged foundations, a sequenced road, and four
falsifiable tests for done. We said we should do that, in the open, with
federation, on a grander scale than has ever been seen before. The difference
two years on is that "that" now has a parts list, an order of assembly, and a
way to tell when it is finished. The remaining work is to draw the parts that
are still named rather than built, and to turn the red signs green one
measurable test at a time.

---

## Note on status and discrepancies

This document draws status only from the ledger (`designs/README.md` on
`llm`), the canon ("A Choice of Giants"), the shelved library, and the
resequencing proposal where it is explicitly marked as proposal. Three
canon discrepancies bear on claims made above and are recorded here, not
silently resolved (per the strategy brief and the scout reconnaissance at
`journal/entries/2026/06/11/045739Z-result-scout-8f5fb7.md`):

1. **`daemon-agent-network-identity` status conflict.** The ledger summary
   table and the M4 milestone table read "Not Started"; the design file's own
   metadata reads "In Progress" with its first two items marked done. The
   machine section's attestation and federation claims rest on this design;
   the keypair side may be further along than the milestone tables imply.

2. **Gateway-package, AWS, and packaging-CI designs absent from `llm`.** The
   ledger lists `gateway-package`, `gateway-packaging-ci`,
   `gateway-aws-deployment`, and `gateway-aws-attuned` as Proposed designs,
   but the files are not present on the `llm` branch; they live on an unmerged
   pull-request branch. The road section's packaging-track claims describe work
   whose design docs are not yet on the roadmap branch.

3. **`familiar-release.md` referenced but absent from `llm`.** The peer-app-
   sharing milestone treats it as a Proposed design, but the file is not in
   `designs/` at tip; it is linked by raw URL to a feature branch. The upgrade-
   channel discussion in the road section does not lean on it for the gateway
   case, precisely because it targets the desktop app rather than the headless
   node.

A fourth item the scout recorded (the brief-versus-ledger conflict on
sequencing OAuth/key-recovery alongside MCP termination) is not a canon
self-contradiction but a strategy decision the resequencing proposal
reconciles along the design-versus-implementation seam; it is treated as a
proposed plan above, not as settled fact.
