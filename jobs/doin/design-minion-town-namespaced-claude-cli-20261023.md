---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design proposal: confine a subscription-authenticated `claude` CLI with Linux namespaces

Repo context: `kriscendobot/minion.town` (the design lands there; reference
`endojs/endo-but-for-bots` `llm` where it touches `@endo/claude`). Route this to
a designer. Open the resulting design as a PR on the bot fork as a review
surface; do not build it in this job.

**Do NOT run the gauntlet on this.** The maintainer asked for a proposal for
discussion, not a panel-converged merge. The deterministic exemption available
is the `<!-- garden-design-open-questions -->` marker: put it in the PR body so
the completion machinery stages no design panel (`auto-gauntlet-handoff.sh` and
`assert-producer-pr-draft.sh` honor it via `is_open_questions_design_pr`). This
is a deliberate, maintainer-directed use on a fork repo, outside the marker's
usual garden-own-repo scope; say so in the PR body. The design must carry a
non-empty `## Open questions` section. Post no gauntlet job and do not stage
one.

Origin: kriskowal, liaison session 2026-10-23. Verbatim:

> It would also be worthwhile to look into using the conceit in Josh Corbin's
> Unum (devoker, pivoker) project, using Linux namespaces to confine a claude CLI
> with subscription tokens, provided we can do a subscription authentication
> workflow by proxy, possibly using federated identity, and then provide a posix
> namespace with nowhere o write, only essential files to read, and no network
> access except as necessary to reach claude's servers. It would not be as
> confined or ocappy as viewing the world through a tool call surface endo fully
> encapsulates, as we do with lal and fae. Please post a minion.town design
> proposal. Do not run the gauntlet on this.

Context: `claude --bare` does not accept subscription tokens (see the sibling
design job `design-claude-bare-retreat-api-key-agents-20261023`, which proposes
API-key lal/fae agents). This proposal is the **alternative or complement** that
would keep subsidized inference by running the ordinary `claude` CLI under a
subscription login inside a namespace sandbox. Write it so the maintainer can
compare the two.

## What the design must settle
- **Unum study.** Read Josh Corbin's Unum project (devoker, pivoker) and report
  accurately what it does and how it uses Linux namespaces. Link the sources. If
  you cannot find or verify it, say so rather than guessing at its design.
- **Sandbox shape.** A POSIX view with nowhere to write (or only a tightly scoped
  tmpfs), a minimal read-only set of essential files, and no network except what
  reaches Claude's servers. Specify the namespace set (user, mount, pid, net,
  ipc, uts, cgroup), the filesystem layout, how egress is limited to Claude's
  endpoints (netns with an allowlisting proxy, resolver handling, TLS), and how
  this relates to the existing bwrap slice already built in `@endo/claude`
  (endo PRs in the `build-endo-claude-sandbox-bwrap-slice` arc). State what is
  reusable.
- **Subscription authentication by proxy.** How a user's subscription login
  reaches the confined CLI without the CLI or the model gaining access to
  long-lived credentials: the authentication workflow performed by a proxy,
  possibly with federated identity; token lifetime, refresh, and revocation;
  where the credential lives (cf. the root-only credential-expiry and reauth
  work in minion.town #119). Be explicit about whether Anthropic's terms
  permit this use of a subscription token on behalf of other guests, and flag it
  as an open question rather than assuming. Whose subscription pays, and what
  stops it becoming a shared-subscription-reselling arrangement.
- **Honest confinement comparison.** This is weaker than the ocap tool-call
  surface lal and fae get from Endo: the CLI has ambient authority inside its
  namespace and its own tools. Tabulate what each approach can and cannot do to
  the host, to other guests, and to the credential; use the maintainer's test
  that a bearer token is acceptable if it designates a specific object rather
  than an identity (minion.town #180, #203).
- **Integration.** Where this sits relative to the per-guest pinned responders
  (#165), delegation (#120, #140), and `@endo/inference`. Which of the code the
  sibling design proposes to deprecate would instead be kept if this is adopted.
- **Operations.** Host requirements (unprivileged user namespaces, kernel and
  distro settings on the AWS host), failure modes, resource limits, and how it is
  tested and probed in production.
- **Staged plan** fine-grained enough that each phase could be one builder job,
  with a minimal spike first that proves the sandbox runs `claude` end to end.

## Constraints
- Verify claims against `llm` and minion.town `main`; cite file paths and PR
  numbers.
- Do not touch the maintainer-reserved surfaces (ferry, identity switching).
- Do not enable, deploy, or run anything on production.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-23T04:38:16Z
