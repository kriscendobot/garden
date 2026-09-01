---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (2026-09-01, liaison session): plan next steps for a
`@primer` readable tree as a default endowment for minion.town guests.

## The proposal, as given

Establish `@primer` — a readable tree available by default in every
minion.town guest's namespace — holding context an agent can explore to learn
how to do things with minion.town, in particular:

- How to create a "backend" for a clip: a live, capability-bearing object
  hosted in the guest's own daemon, distinct from the clip's static served
  files.
- How to connect a published clip's static frontend to that backend: bundle a
  script into the frontend content that opens a WebSocket and negotiates
  CapTP over it to establish a live session that can send and receive
  information with the backend object. (This is the maintainer's own stated
  mechanism, from direct operational knowledge — not something either prior
  evaluation this session discovered, since it isn't exposed as an MCP tool at
  all. It reconciles what `skills/minion-town-clip-publishing/SKILL.md`
  found: clips ARE served as fully static, immutable files with no
  per-request server hook — but a static file can still ship JS that opens a
  live outbound connection at *runtime*. "No per-request dynamic execution"
  and "a live backend is possible" are both true; the primer is what closes
  the gap between them for an agent trying to build one.)

**A load-bearing design constraint**: whatever prompt drives a subagent doing
minion.town work should carry the *least* information possible — the primer's
job is to be findable and self-explanatory through the guest's own ordinary
MCP tool calls (`list`, `has`, `readText`, and onward navigation from there),
not to be pasted into a long system prompt. Design the tree's shape and an
entry point so that a subagent told nothing more than "look in `@primer`" (or
even just told to explore its own guest) can bootstrap from there.

**Staging, not a platform default on day one.** Before committing to `@primer`
as a default endowment for *every* guest on the platform (a guest-provisioning
change, and guest provisioning just proved itself fragile —
`minion-town-fix-publish-invalid-main-pet-name`, filed this session, is a
guest missing an internal `@main` entry that nothing client-side could
detect or repair), first stage an experimental, **mutable** `primer` directory
scoped to just the bot's own guest. Validate content, structure, and
discoverability there — dogfood it the same way this session validated the
Playwright-login and clip-publishing findings, with a subagent evaluation —
before generalizing to every guest.

**The structural analogy the maintainer drew explicitly**: this should look
very much like the garden's own repository — `roles/` and `skills/` as the
relatively static reference material a fresh agent reads — but paired with a
separate **mutable** space for evolving state, analogous to the garden's own
`journal2` (job board, message bus, and the `library/` of accumulated
memories). Work out what the guest-side equivalent of that mutable space
actually is: is it more like a personal memory/library the guest accumulates
over its own operational history, a coordination surface for guest-to-guest
work, both, or something else the garden's own split doesn't map onto
cleanly? Don't force the analogy past where it actually fits.

## Ground this in what's already known

Read both skills this session already landed, since a good `@primer` should
proactively resolve exactly the confusions they document rather than let the
next agent rediscover them: `skills/minion-town-mcp-playwright-login/SKILL.md`
and `skills/minion-town-clip-publishing/SKILL.md` (the static-only clip
reality, the CSP constraints, `evaluate`'s pet-name-not-literal binding
gotcha, and the `@main` publish bug). Also be aware of two other jobs from
this session that touch adjacent ground, so this one complements rather than
duplicates them:

- `design-minion-town-eval-campaign` — a broader, systematic evaluation
  program across the whole `mcp__minion-town__*` surface, converging on a
  design PR against endo/minion.town/both. That job is about *discovering*
  gaps at scale; this one is about a *specific, already-well-formed* proposal
  the maintainer already has the shape of (informed by operational knowledge
  — the WebSocket/CapTP backend pattern — that isn't discoverable through the
  tool surface alone, so the two efforts are complementary, not redundant).
  If useful, cross-link them.
- `minion-town-fix-publish-invalid-main-pet-name` — the guest-provisioning
  bug. Any guest-provisioning change this design proposes (rolling `@primer`
  out as a default endowment) should account for the fact that guest
  provisioning has at least one live, unresolved gap; don't propose a
  platform-wide provisioning change without addressing how it interacts with
  that bug (does the fix need to land first? does `@primer` rollout risk the
  same class of gap for a different reserved name?).

## An open architectural question to resolve, not assume

`journal/projects/minion-town/README.md`'s "maintainer architecture
directive" states minion.town is a **deployment + configuration layer, not a
code home** — that Endo-side capability (guest behavior, provisioning,
default endowments) is meant to grow in `@endo/gateway` + `@endo/mcp` on
`endojs/endo-but-for-bots` @ `llm`, organically with the AWS deployment. A
guest's default endowment tree sounds squarely Endo-side by that boundary,
not a minion.town-repo change — but confirm this rather than assume it.
Whichever repo (or repos) the implementation actually belongs in, land the
resulting design doc as a PR using **that repo's own** conventions: if it's
`kriscendobot/minion.town`, that repo's design docs land as PRs against
`main` (maintainer directive, 2026-07-10) in the repo's own shape (`# Design:
<title>`, a `**Status:** / **Mandate:** / **Grounded against:** /
**Companion:**` header block, numbered sections, mermaid diagrams) — **not**
the garden's frontmatter; if it's `endojs/endo-but-for-bots`, follow that
repo's own design conventions instead.

## Deliverable

A design (or a small design plus explicit open questions if genuinely
unresolved) covering: the primer tree's content and shape; the entry point
and navigation an agent finds via ordinary guest tool calls; the mutable
staging plan scoped to the bot's own guest first, with a concrete way to
validate it (e.g. a follow-up evaluation job, minimally prompted, that
succeeds or fails at finding and using the primer); the mutable-space analogy
worked through rather than asserted; the placement question above resolved;
and a path from the staged experiment to an eventual platform-wide default
endowment, sequenced so it doesn't repeat the `@main` provisioning-gap class
of failure.
