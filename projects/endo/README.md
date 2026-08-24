# Project: endo

Hardened-JavaScript and SES platform. Upstream is [endojs/endo](https://github.com/endojs/endo); the garden interacts with it primarily through `kriscendobot` forks for branch work and draft PRs, and through the `kriskowal` identity when an output needs to land directly on the upstream `master` branch. This project's most active interaction surface is the boatman ferrying syrups-class work upstream from `endojs/endo-but-for-bots` to `endojs/endo`.

## Rules of engagement

- **Routine work happens on a `kriscendobot` fork.** Default identity for clones, branches, draft PRs, fork-side pushes. Fork name presumed `kriscendobot/endo` per GitHub's convention; confirm before cloning.
- **Upstream pushes use the `kriskowal` identity.** Direct landings on `endojs/endo` require the escalated identity (the maintainer's primary). This identity touches the maintainer's personal reputation on the upstream, so the liaison confirms with the user before any push under it.
- **Boatman handoffs are the typical upstream-PR path.** When a fork branch is ready, the boatman opens the upstream PR under an `identity_switch_authorized: true` flag carried in its dispatch prompt. The cross-link between the source PR (on the `kriscendobot` fork or on `endojs/endo-but-for-bots`) and the target PR is implicit in the boatman's job per `roles/COMMON.md` § External-repo etiquette on the `main` branch.
- **Standing-monitor reactions are silent by default.** `skills/monitor-endo/SKILL.md` on the `main` branch defines per-event-class reactions for the daemon-driven LLM wake; per the current rule set, most non-issue activity is routed to `tick` entries without further dispatch.

## Identity and credentials

The garden uses two GitHub identities (see [`../../entries/2026/05/12/193714Z-message-liaison-d45bb5.md`](../../entries/2026/05/12/193714Z-message-liaison-d45bb5.md)):

- **`kriscendobot`**: default bot identity. Used for routine work on this project's forks.
- **`kriskowal`**: escalated identity. Used only for upstream landings on `endojs/endo`.

Operational details for switching between the two (separate `gh` hosts, separate SSH keys, per-remote `core.sshCommand`, or shell-env switching) are still to be confirmed with the maintainer; the liaison should not push under either identity until pinned down.

## Upstream

- Repo: <https://github.com/endojs/endo>
- Default branch: `master`
- Standing monitor on this host: `worktrees/endojs-endo/watch-endo--monitor--20260512-233305/`; daemon cadence 60s.

## Authority structure

Default authority for technical and project-scope decisions on this repo rests with kriskowal as maintainer. One named exception:

- **erights** (Mark S. Miller) is a senior contributor whose authority meets or exceeds kriskowal's on a defined set of topics: `pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`, `captp`, `patterns`, the OCapN-family protocol, and capability-security generally. These are the subsystems and concepts erights designed or co-authored; his review or substantive comment on a PR that touches any of them carries kriskowal-equivalent (or greater) weight on the *technical question*. A `CHANGES_REQUESTED` or substantive `COMMENTED` review from erights on a topic-matching PR routes the same way a maintainer review would: the garden treats it as a directive on the technical merits and the fixer addresses it. (Authorization to *act* on erights' review still flows through the kriskowal authorization chain in `roles/COMMON.md` § External-repo etiquette; senior-contributor weight changes how the garden reads the review's technical content, not who gets to push.)
- Outside those topics, on garden-internal infrastructure, or on scope unrelated to the listed subsystems, erights' input is senior-contributor input rather than maintainer-equivalent. The garden surfaces it loudly to the maintainer but does not auto-route to a fixer.

The practical rule: on a topic-matching PR, erights' review is read as technically authoritative; on anything else, it is high-signal input the maintainer adjudicates.

The pattern is reusable. Future per-project READMEs may name their own non-default-authority actors and topic-scopes; the section's shape (named actor, topic list, practical rule for in-scope vs. out-of-scope input) is intended to carry over. See `roles/COMMON.md` § Authority structure of upstream projects for the cross-project framing.

### Content-reuse permission (erights' public texts)

Distinct from the two authority axes above (technical review weight, and who may authorize a bot action), erights granted the garden a standing **content-reuse license** for his own writings. Source: [endojs/endo-but-for-bots#632](https://github.com/endojs/endo-but-for-bots/issues/632) (erights, 2026-07-08).

- **Grant.** `@kriscendobot` (and the garden fleet behind it) may reuse and adapt or derive-from any of erights' public texts.
- **Scope, as erights enumerated it** (a floor, not a ceiling): his thesis; all of erights.org not explicitly attributed to someone else; all his published papers; all his public postings on GitHub.
- **The one condition.** Keep making clear that an adaptation is *derived from* the original but *is not* the original. erights noted the garden has been doing this well and asked it to continue; the discipline is the whole basis of the grant, so it is not optional.
- **Extension path.** If a case arises where even this permission is awkward, ask erights on the source issue (or a topic-matching endo thread) and he may extend it further. Do not assume a wider grant than the text above.

Practical effect: the library actively ingests erights.org and the Miller papers into [`../../library/sources/`](../../library/sources/) (the `erights--*`, `web--miller-*`, and `papers--miller-*` pages). Any garden-authored prose (a design, a concept page, a summary) that adapts those sources must carry a plain derived-from-not-the-original attribution to the original text. This license governs *reuse of the texts*; it confers no new authorization to act on any upstream repo (the credential boundary in `roles/COMMON.md` § External-repo etiquette is unchanged).

## Roadmap

The authoritative roadmap is `designs/README.md` on the `endojs/endo-but-for-bots@llm` branch (the shared endo-project milestone ledger, M1–M11). Groom reconciliation snapshots — which reconcile the ledger with recent progress, sharpen open questions, and re-project the near-term sequence without editing the ledger — land here:

- [`roadmap-reconciliation-2026-07-02.md`](roadmap-reconciliation-2026-07-02.md) — reconciles the 2026-06-16 → 2026-07-01 window (fs-interface consolidation, arrow/method house style, plain re-exports, error-tracing, `@endo/pubsub`); prunes the resolved groom #400 questions; flags the un-applied 2026-06-11 resequencing (M7 Community Hub) and PR #356's still-off-`llm` packaging designs. Groom gardener job `groom-refine-endo-roadmap`.

## Drafts awaiting maintainer triage

- [`drafts/exo-import.md`](drafts/exo-import.md) and [`drafts/exo-npm-registry.md`](drafts/exo-npm-registry.md) — sibling designs authored by designer dispatch `e3b1aa` (2026-05-14); not yet committed to `endojs/endo`. See [`drafts/README.md`](drafts/README.md) for lifecycle.

## Per-topic detail

Topic files the [scholar](../../../roles/scholar/AGENT.md) grows from project-tagged material; per the [context-library](../../../skills/context-library/SKILL.md) skill each topic is its own sibling file rather than an expansion of this README.

- [ai-sdk-research.md](ai-sdk-research.md): Vercel AI SDK architecture research (v7 Core / UI / Harnesses surfaces, the language-model provider spec, `ToolLoopAgent`, `HarnessAgent`, streaming, structured output, operational and integration constraints), curated as input for a subsequent design comparing the AI SDK with pi. Disambiguates the two senses of "pi": `@mariozechner/pi-ai` (the provider registry endopi builds on) and `@earendil-works/pi-coding-agent` (the coding-agent harness the `@ai-sdk/harness-pi` adapter wraps). Scholar job `scholar-ai-sdk-research` (2026-07-14).
- [generative-agent-memory.md](generative-agent-memory.md): maps Chinta's Generative Agents memory/retrieval/reflection/planning architecture onto Endo's existing durable formula/petname and transcript substrate. The concrete gap is policy above persistence: bounded context selection, evidence-linked reflection, and forward-only replanning should remain agent-layer capabilities rather than daemon-global behavior. Scholar job `scholar-ingest-generative-agents-talk` (2026-08-24).

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/193651Z-message-liaison-aad0d0.md`](../../entries/2026/05/12/193651Z-message-liaison-aad0d0.md): initial project-context message naming upstream, fork identity, and pushability constraints.
- Recent boatman-ferry handoffs (e.g., PR #3256 syrups-package). Grep `^project: endo$` over `entries/`.
