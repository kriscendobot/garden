---
created: 2026-06-11
updated: 2026-06-11
author: journalist
status: draft-for-maintainer-triage
---

# Your agent, your keys

You already have an agent. It runs in Claude Desktop, or Cursor, or
whichever client you reach for, and it is useful right up to the moment it
needs to touch something real. Then you wire it to a tool. You install the
GitHub server and hand it a token; now the agent can reach every repository
you can reach, in every organisation you belong to, until you remember to go
and revoke it. You install the Notion server and hand it a key to your entire
workspace. Each of these is a reasonable thing to want. Each of them is a
bearer token to everything, granted up front, because that is the only shape
the integration offers you.

This is the ordinary way of things, and it is worth naming plainly: the
common MCP integration is an ambient-authority grant. The Model Context
Protocol's own security guidance says as much, warning against publishing
every scope at once and against omnibus tokens that bundle unrelated
privileges to save a later prompt. The guidance is sound. Most shipping
integrations ignore it, because the SaaS on the other end would rather hold
the broad token than negotiate a narrow one. You are not given the choice.

An Endo node is built to give you the choice. The pitch is small and
concrete: you grant your agent a *capability* rather than a key. Not your
disk: one directory. Not your GitHub: one repository. The grant is
revocable, it is auditable, and it can be attenuated further before it is
passed along. The rest of this note is what that looks like in practice, and
then where it leads.

## A word on what exists today, and what does not

Be clear-eyed before the sales pitch. The capability machinery underneath all
of this is real and shipped: the Endo daemon, the mount capabilities that
hand out a directory as a first-class object rather than a path, the
bearer-token authentication that ties a request to a particular agent
identity, the Familiar shell you can already download and run. Those are
landed work, with tests, on the `llm` branch today.

The product described below, the one you deploy from a marketplace and sign
into with your Google account, is the near-term objective, not a shipped
release. The hosted gateway that terminates MCP for an external client is in
active development, most of its phases open as pull requests under review. The
OAuth sign-in that bonds your external identity to your node's key, the
one-click marketplace listing, the metered billing: those are designed gaps
on the roadmap, named and sequenced, with no code yet. So read what follows in
two registers. The *capability discipline* is here now. The *turn-key node*
that wraps it in a deploy-and-sign-in experience is the thing being built, and
it is being built in this order on purpose. Where the difference matters
below, it is marked.

## Day one

Here is the shape of it, once the node ships.

You find the listing on your cloud marketplace, AWS first, and you deploy.
This is a single sitting, not an afternoon of Terraform. The node comes up,
hands you a bearer token on first boot, and waits.

You sign in. The node bonds an OAuth identity, your Google or GitHub or
Microsoft account, to the node's own public-key identity. From then on the
account you already trust is how you prove who you are; the cryptographic key
underneath is the node's business, not yours to memorise. (This bonding step
is the front door of the product, and it is the part still on the drawing
board. The brief is candid that identity and the MCP bridge are being
designed together, not one trailing the other, precisely because identity is
the front door and a front door cannot be an afterthought.)

You point your MCP client at the node. In Claude Desktop or Cursor you add a
server the way you add any remote server: a URL and a token. The difference is
entirely on the other end. Where a SaaS server would now hold a broad grant
to its own product, your node holds nothing it was not handed, and it was
handed nothing yet.

Then you grant a capability. You want the agent to work on a project, so you
give it that project's directory, as a mount: a single directory, exposed as
an object the agent can read and write, with everything above it simply
absent. The agent cannot walk up and out. You want the agent to push a branch,
so you give it one repository over the git capability, not a token to your
account. Each grant is a thing you did, deliberately, and each is a thing you
can take back.

## The three properties, shown

The words for this are *attenuation*, *revocation*, and *audit*. They are
worth showing rather than asserting.

**Attenuation.** You hold a capability to a directory. You can hand the agent
not that capability but a weaker one derived from it: read-only, or scoped to
a subdirectory, or a snapshot frozen at this moment rather than a live view.
The agent receives exactly the authority you chose and no path back to the
authority you kept. This is not a setting you toggle in someone's dashboard;
it is what a capability *is*. A grant is endowed, and endowment can always be
narrower than what you hold.

**Revocation.** The grant is an object your node issued, and your node can
drop it. When you revoke the directory, the next thing the agent tries to read
through it fails, not because a policy server far away got around to syncing,
but because the object is gone. There is no token still valid somewhere that
you forgot to rotate.

**Audit.** Because every reach for a real resource goes through a capability
your node issued, the node can say what happened. The line you want to see
after the fact reads plainly: *this agent, through this grant, read this file
at this time.* Not "an app with your token did something to your account,"
recovered later from a provider's log if it is kept at all, but a record your
own node holds, about grants you made, in terms you set.

None of these is a feature bolted on to make the integration feel safer. They
are the consequences of describing authority as capabilities rather than
tokens, an idea with thirty years of theory behind it and, now, a working
daemon underneath. The agent, for its part, holds no authority of its own. It
can propose what it would like, describe the capability it thinks it needs, and
even write the code that would use one. It cannot grant itself anything. The
granting stays with you.

## The widening horizon

The reason to run your own node is not only that the grants are better. It is
that the things you depend on stop being things you can be cut off from.

**Your inference is yours to choose.** The model behind your agent is an
input, not a master. Run a local model, point at a self-hosted one, or use a
trusted vendor, and switch when the bill or the terms change, without
rebuilding your agent around a new provider's quirks. Inference is
substitutable by design; no single giant is load-bearing.

**Your state is yours to export.** A node you operate is a node you can back
up, restore, and carry from one cloud to another. (The custody machinery for
this, the backup and the cloud-to-cloud migration, is named on the roadmap as
work to be designed, not yet built. It is being treated as a brand promise to
honour rather than a detail to imply, which is the right way round.) The point
of self-custody is that leaving is always available, and a tool you cannot
leave is a tool that does not have to keep you happy.

**Your node can later serve more than you.** The same software you run for
yourself can, in time, be run for a handful of people you trust: a small
community served the way a good local ISP once served one, with always-online
capabilities, relaying, and curation, without any of you becoming a giant. That
is a later chapter, and the designs that lead to it (peer connections over a
secure transport, invitation by link, app sharing) are at varying stages on
the same roadmap. It is mentioned here not as a promise but as a direction:
the node you stand up for one is the seed of the node you might stand up for a
few.

## A note on the meters

When the billing arrives, you will see resources metered in named classes:
compute, inference, storage, network. These are units of account for what your
node actually consumes, measured so that the bill is one you can predict. They
are metering units and nothing more. They are not a crypto asset, not a token
in that sense, not a thing to speculate on. The reason to name them precisely
is the same reason to name the grants precisely: you forgive rough edges, but
you do not forgive a meter you cannot read.

## What you are actually buying

Most of what is described here is, frankly, infrastructure that several
clouds will sell you a version of. Hosting an MCP server that a compliant
client can reach is becoming a commodity, and the node does not pretend
otherwise. The thing that is not a commodity is the authority model: that your
agent's reach into the real world is composed of grants you made, each one
narrower than what you hold, each one revocable, each one accounted for. You
are not buying a place to run a server. You are buying the end of handing over
the keys.

The honest part, which belongs in a pitch and not only in the small print: the
node is a commercial product, and its revenue is what funds the open work
underneath it. That is the arrangement, stated in both directions. The commons
is not a loss leader meant to lure you to the paid thing, and the paid thing is
not a betrayal of the commons. You pay to run a node; the daemon, the
capability discipline, the protocols stay open and yours to leave with. If that
sounds like a fair trade, the rest is a URL and a token.

---

## Sources

- "A Choice of Giants," Kris Kowal, 2024-02-22
  (`journal/library/sections/kriskowal-com--giants--overview.md`): the giants
  problem, the user-agent fiction, the vocabulary of weblets and chat-as-
  permission, and the federation-and-self-custody register. The "leaving is
  always available" framing draws on the essay's app-store critique (one does
  not keep, archive, or pass on an app) recast for nodes and state.
- MCP gateway and remote-hosting landscape
  (`journal/library/sections/mcp-landscape--gateway-hosting-category.md`): the
  ambient-authority status quo (bearer token to your whole GitHub or Notion),
  the MCP security spec's scope-minimisation guidance and the common mistakes
  it names, the transport-layer commoditisation of MCP hosting, and the
  attenuation differentiator. No metrics from this source were quoted as
  product claims.
- The design ledger, `endojs/endo-but-for-bots@llm:designs/README.md`
  (`project/designs/README.md`, tip `72d1c764c`): the sole source of truth for
  status. Shipped today: `gateway-bearer-token-auth` (Implemented),
  `daemon-mount-capabilities` (Complete), `platform-fs` (Complete),
  `familiar-electron-shell` and `familiar-daemon-bundling` (Complete),
  `ocapn-noise-network` (Complete). In active development: the gateway-package
  stack (`endo-gateway`, phases open as PRs #388–#397; phases 10/11 pending).
  Designed gaps with no code: `gateway-oauth-bonding`, `gateway-key-recovery`,
  `gateway-stripe-adapter`, `gateway-resource-classes` (M5); `endo-gateway-mcp`
  is Not Started with its design merged. The two-stage objective (O1 turn-key
  node, O2 community hub) is the maintainer's plan per the strategy brief, not
  a shipped state.

## Status-honesty note

The essay describes the O1 product experience in present-tense product-vision
register, but flags the now/near-term boundary unmistakably in a dedicated
section ("A word on what exists today, and what does not") and again inline at
each forward-looking claim: the OAuth bonding step, the marketplace deploy, the
metered billing, and the state-custody machinery are each marked as roadmap
work rather than shipped, while the capability discipline (daemon, mount
capabilities, bearer-token auth, the Familiar shell) is stated as landed. No
benchmark, latency, price, or customer was invented; the meters are described
as units of account, explicitly not crypto assets, per brief §2.
