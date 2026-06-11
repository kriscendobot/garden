---
created: 2026-06-11
updated: 2026-06-11
author: journalist
status: draft-for-maintainer-triage
---

# The host's pitch: run a node for your people

You already run something for other people. Maybe it is a Mastodon
instance with a few hundred accounts, a Discord with a culture worth
protecting, or a homelab that quietly does the chores for a household
and a handful of friends. You know the shape of the job, and you know
the parts of it that nobody warned you about: the moderation queue, the
3 a.m. disk-full alert, the dread of a takedown notice, the slow
realisation that your community now depends on you in ways you did not
sign up for.

This is a pitch for running one more thing. It is also, in fairness, a
pitch that tells you up front which of the hard parts go away and which
do not. The honest answer is that the technical attack surface gets
smaller and the human responsibilities mostly stay. If a vendor tells
you otherwise about a service that hosts what your members say and do,
they are selling you something. We would rather you read the next few
pages and decide with the costs in view.

## The thing you would be running

An Endo node is a small piece of software that holds **capabilities** on
behalf of the people who use it. A capability is a narrow, revocable
permit to do one specific thing: read one directory, send mail through
one relay, talk to one external service. It is not a password and not a
bearer token to your whole account. The distinction is the whole point,
so it is worth dwelling on.

When one of your members today wires an agent into their Notion or their
GitHub, they hand over a token that grants the agent everything they
themselves can do. The agent does not need that much authority; it needs
to file an issue, or read one page. But the grant is ambient: it carries
the user's full reach, and it is hard to scope down and harder to take
back. An Endo node turns that around. Authority arrives **attenuated**:
the member endows an agent with exactly the slice it needs, the grant is
auditable, and it can be revoked without rotating every other secret the
member owns. The agent itself holds no authority of its own. It can
*propose* what it would like to do, as code; the **endowment** stays
with the party who actually holds the right to grant it, and ultimately
with the user.

The same node you would run for yourself can run for your community. One
operator, many members. The vocabulary the project uses for the
community shape is a **hub**: a node operated for a group, where members
onboard by invitation and the unit of trust widens from "do you trust
the operator" to "do you trust the community". That is the whole of the
O2 idea, and it is worth being plain that O2 is the *second* stage of a
two-stage plan. The first stage (a node a single person runs for
themselves) is where the working code lives today. The hub is mostly
design and named gaps. More on exactly which, below, because you should
not operate a hub on the strength of a roadmap.

## The ISP analogy, and where it holds

There was a window, before the giants, when a good internet service
provider did a set of unglamorous things for a community of subscribers.
It relayed your traffic and punched you through NAT. It ran a mail
server so your mail had somewhere to live when your machine was off. It
gave you a stable presence on a network that otherwise forgot you the
moment you disconnected. It did not read your mail to sell you things,
because that was not the business it was in.

The hub is an attempt to give a community those same ISP-like services
without the operator becoming a giant or a single point of
surveillance. The services the project names for a hub are: relaying and
NAT traversal, mail delivery, anonymisation, curation, and always-online
capabilities. Read that list as a description of intent, not an
inventory of shipped features. Some of the substrate exists; the
member-facing hub assembly does not yet.

What makes this *not* a recreation of the surveillance ISP is the
capability discipline underneath. A hub mediates capabilities; it is not
required to read content to do its job. When a member's agent acts
through the hub, the hub sees a request for a narrow, named capability,
not a standing grant over the member's whole life. That is a genuinely
different posture from a platform that needs to see everything in order
to function. It does not, however, make the operator's content-hosting
responsibilities vanish, and I will not pretend it does.

## What is actually built, what is designed, what is a gap

You are an operator. You read changelogs for a living. So here is the
status with the labels the project's own ledger uses, and nothing
dressed up.

**Built and shipped (the substrate you would stand on):**

- The secure peer transport that members and hubs would use to find and
  authenticate each other is implemented (the project ships an
  OCapN-over-Noise network, marked Complete in the ledger). This is the
  cryptographic floor under member-to-hub and hub-to-hub sessions.
- The local capability and content machinery a node runs on (the daemon,
  content-addressed storage, check-in / check-out of readable trees,
  per-worker resource metering) is largely Complete. These are the parts
  a single-user node already exercises.

**Designed but not yet built (Proposed, In Progress, or Not Started):**

- The **gateway** itself, the host-level service that lifts hosting out
  of any one user's daemon and is the thing a hub sits on, is Proposed.
  Its design even names the hub case explicitly, as a deferred "daemon-
  hosting service mode" where the gateway manages virtual members rather
  than operating-system users. Deferred is the operative word: the
  multi-tenant variant is sketched, not specified.
- The networking pieces that the relay and always-online promises depend
  on (transport separation, session reconnect for members who drop and
  return) are In Progress and Proposed respectively.
- The member-onboarding substrate (invitations by deep link) and the
  app-curation cut (sharing apps to members) are Proposed.

**Named gaps with no design yet (the parts the project owes you before
asking you to run a hub):**

This is the section that matters most for your decision, so it is the
longest. Each of these is acknowledged in the project's own gap
inventory as undesigned.

- **Member sign-in and account recovery.** Today a member's identity is a
  256-bit key; a hub member is not going to manage a raw keypair, and
  must not be stranded when they lose it. Binding a normal sign-in
  (OAuth) to a member's node identity, and re-issuing a member's bearer
  on proof of that identity, are both named gaps. Without them, onboarding
  a member means handing them a key out of band, and losing a key means
  losing the account. For a self-custodial node you run alone this is
  tolerable. For a community it is not, and it is not yet designed.
- **First-boot trust.** How an operator securely receives their own
  initial credential on a fresh, headless node, before any other channel
  of trust exists, is undesigned. You would be the first person to walk
  this path on a new hub, and the path is not paved.
- **State custody: backup, restore, migration.** Self-custody and the
  freedom to leave are the project's brand promise. The substrate for it
  exists (content-addressed storage, serialisable trees), but no design
  yet covers backing a node up, verifying a restore, or migrating a
  hub's state from one host to another. A promise of "your state is
  yours" that has no restore ceremony behind it is a promise you should
  discount until the design lands.
- **Upgrade channel.** Signed, safe updates for an always-online node are
  undesigned for the hub case. An always-online box that you cannot
  update safely is a liability you carry personally.
- **Operator observability.** The logs and metrics you need to actually
  run a production box (is it up, is it slow, is it being abused) are not
  yet designed, and the project is deliberately cautious here: it wants to
  give you operational sight without building the member surveillance the
  whole effort exists to refuse. That tension is real and unresolved.
- **Multi-tenancy and hub economics.** Isolation between members on one
  hub, whether members are billed or the operator is, and the abuse-
  handling posture are all undesigned. The gateway's multi-user
  registration model and the planned per-member persona and capability
  scoping are the substrate, but the hub-economics and isolation
  questions are open.

I am laying these out at length because the alternative (discovering them
one at a time, in production, with members depending on you) is the
failure mode this pitch exists to avoid.

## Moderation and liability, said plainly

If your hub hosts what members say and do, you inherit the
content-hosting operator's burdens. The capability model changes the
*technical* attack surface; it does not repeal the law or the moderation
queue. An honest accounting, drawn from what running a Mastodon instance
already demands of an operator:

- **Moderation is human work that does not scale down.** A Mastodon
  operator has a four-level tool for individual accounts (mark sensitive,
  freeze, limit, suspend) and a three-level tool for whole remote servers
  (reject media, limit, suspend), plus spam controls and an appeals
  process they are obliged to run. A community of a few hundred can still
  generate a steady stream of reports, defederation decisions, and
  appeals, each needing human judgement. A hub operator will face an
  analogous surface. The toolset for it on a hub is, at present,
  undesigned.
- **Legal exposure is real and is yours.** Hosting user-generated content
  can expose an operator to liability for defamation, copyright,
  illegal content, and (with criminal weight in most jurisdictions)
  CSAM, with mandatory reporting and removal obligations. Privacy law
  (GDPR, CCPA, and their kin) attaches the moment your members include
  residents of those jurisdictions. Content legal in one country is
  illegal in another, and a federated hub receives content from
  everywhere. A volunteer running a 500-member instance bears
  structurally the same exposure as a commercial host, with a fraction
  of the resources. None of this is legal advice; all of it is the
  weather you would be operating in. Endo's capability discipline does
  not change it.
- **What the capability model genuinely helps with.** Because a hub
  grants attenuated, per-member, revocable capabilities rather than
  ambient access, the operator has *finer-grained technical controls*
  than an open ActivityPub server: you can scope and revoke what a given
  member's agents may do, per capability, without nuking their whole
  account. That is a smaller abuse surface and a sharper instrument than
  "silence the user". It reduces some classes of risk. It does not make
  you not responsible for what your members do.

The fair summary: the machine can give you better controls than you have
today, and it cannot give you immunity. Anyone who conflates the two is
not your friend.

## On metering, and the word "tokens"

If and when a hub meters resources (compute, inference, storage,
network), the units are exactly that: units of measurement for billing
and limits. They are not crypto assets, and the project is explicit on
this point. Inference in particular is treated as a **substitutable**
input: the source of the model behind a member's agent is a choice, not
a lock-in, and never a load-bearing dependency on any one vendor. If a
hub bills, it bills for resources consumed, in plain units, the way an
ISP billed for a connection.

## Why this funds itself, and why that is not a betrayal

It is reasonable to ask what keeps this alive. The plan is that the
commercial side (a node a person runs for themselves, then a hub a person
runs for a community) funds the development of the commons. That cuts
both ways, and the project means it to: the commons is not a loss leader
to be starved once the product ships, and the product is not a betrayal
of the commons it grew from. You running a hub is, in this telling, also
the thing that bootstraps a federation of hubs. The commercial channel
and the federation seed are the same act. I mention it because you have
watched other projects fracture on exactly this seam, and you are right
to be wary; the answer here is to be honest about the dependency in both
directions rather than to deny it.

## What I am actually asking

Not "switch tonight". The hub does not exist yet; most of what makes it a
hub is design and named gaps. What I am asking is narrower and, I hope,
more respectable:

- If you are curious, run the single-user node when it is ready and feel
  the capability model in your own hands. Grant an agent a directory, not
  your disk; one repository, not your whole forge; watch it work
  attenuated and revoke it when you are done. That is real today in
  design and increasingly in code, and it is the experience a hub would
  later extend to your members.
- Hold the project to the gap list above. When member sign-in and
  recovery, first-boot trust, backup and restore, the upgrade channel,
  observability, and a moderation posture are designed and shipped (not
  promised), that is the moment a community hub is a responsible thing to
  operate. Before that, it is a roadmap, and you are too experienced to
  run a community on a roadmap.

The pitch, in one breath: the same node you run for yourself can one day
serve your people the way a good ISP once did, with a sharper set of
controls than you have today and without you becoming a giant or a
surveillance point, and the project will tell you which of those words
are shipped and which are still owed. That last clause is the part most
pitches leave out. It is also the only part that earns an operator's
trust, which is why it is here.

---

## Notes for triage (not part of the essay)

**Open problems acknowledged by name** (per brief §4, candor register; all
sourced from the scout's gap inventory in
`entries/2026/06/11/045739Z-result-scout-8f5fb7.md`):

1. Member sign-in / OAuth bonding (named gap, M5).
2. Member account recovery / key recovery (named gap, M5).
3. First-boot ceremony (undesigned gap).
4. State custody: backup / restore / migration (undesigned gap).
5. Upgrade channel for an always-online node (undesigned gap).
6. Operator observability vs. surveillance tension (undesigned gap).
7. O2 multi-tenancy: member isolation, hub economics, member-vs-operator
   billing, abuse handling, moderation posture (undesigned gap).
8. Operator legal liability (the Mastodon-instance-operator problem),
   stated as structural exposure, not resolved.

**Status claims and their ledger grounding:**

- Shipped/Complete: OCapN-Noise network (Complete, PR #137 per scout O2
  entrainment map); daemon / content-store / check-in-check-out /
  XS-worker metering (Complete per ledger Summary table).
- Proposed / In Progress / Not Started, labelled as such: `endo-gateway`
  (Proposed) including its deferred Open Question 2 daemon-hosting service
  mode; `ocapn-network-transport-separation` (In Progress); `ocapn-noise-
  session-reconnect` (Proposed); `familiar-deep-link-invitations`
  (Proposed); `endo-app-sharing` (Proposed); `daemon-capability-persona`
  and `daemon-capability-bank` (Not Started, M10).
- Named gaps with no design file: `gateway-oauth-bonding`,
  `gateway-key-recovery` (both M5); first-boot, state-custody, upgrade-
  channel, observability, multi-tenancy (all undesigned per scout).

No status was claimed as shipped that the ledger marks Proposed/In
Progress/Not Started.

**Sources cited:**

- Canon: "A Choice of Giants" overview
  (`library/sections/kriskowal-com--giants--overview.md`) for the giants
  framing, the ISP-era contrast, weblet/Familiar vocabulary, and the
  essay's own Mastodon operator-trust observation.
- `library/sections/mastodon-docs--operator-burden-and-liability.md` for
  the moderation tool levels (four account / three server), the legal-
  exposure structure (defamation, copyright, CSAM, GDPR/CCPA, cross-
  border), and the finer-grained-controls positive case.
- Scout reconnaissance
  (`entries/2026/06/11/045739Z-result-scout-8f5fb7.md`) for the O2
  entrainment map and the gap inventory with statuses.
- `project/designs/README.md` (the ledger) for status labels.

**Canon discrepancies observed (reported, not resolved, per brief §6):**

The essay relies on the scout's already-reported discrepancies and does
not re-derive them, but two bear on this essay's status claims:

1. `daemon-agent-network-identity` is "Not Started" in the README summary
   table but "In Progress" (items 1–2 Done) in the design file itself.
   The essay does not lean on this design for any shipped claim; it is
   named only as substrate, sidestepping the conflict.
2. Several M5 designs the hub leans on (`gateway-package`, `gateway-
   packaging-ci`, `gateway-aws-deployment`, `gateway-aws-attuned`) are
   listed Proposed in the ledger but their files are not present on `llm`
   (they live on unmerged PR #356/#343). The essay therefore treats the
   hosted gateway as Proposed-and-partly-on-unmerged-branches rather than
   citing those files as extant designs.
