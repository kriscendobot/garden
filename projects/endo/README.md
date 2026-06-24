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

## Drafts awaiting maintainer triage

- [`drafts/exo-import.md`](drafts/exo-import.md) and [`drafts/exo-npm-registry.md`](drafts/exo-npm-registry.md) — sibling designs authored by designer dispatch `e3b1aa` (2026-05-14); not yet committed to `endojs/endo`. See [`drafts/README.md`](drafts/README.md) for lifecycle.

## Per-topic detail

(None yet. The [scholar](../../../roles/scholar/AGENT.md) on the `main` branch grows topic files from project-tagged journal entries; per the [context-library](../../../skills/context-library/SKILL.md) skill on the `main` branch, new topics get their own sibling file rather than expanding this README.)

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/193651Z-message-liaison-aad0d0.md`](../../entries/2026/05/12/193651Z-message-liaison-aad0d0.md): initial project-context message naming upstream, fork identity, and pushability constraints.
- Recent boatman-ferry handoffs (e.g., PR #3256 syrups-package). Grep `^project: endo$` over `entries/`.
