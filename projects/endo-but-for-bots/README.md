# Project: endo-but-for-bots

The endo fork the garden actively develops. Upstream is [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots). This is where most of the garden's per-PR work happens: fixers, weavers, shepherds, designers, conductors all operate on PRs in this repo, and the *Pending kriskowal reviews* and *PR backlog* sections of `journal/README.md` are dominated by its PRs.

## Rules of engagement

- **Default branch for active development: `llm`.** The garden's `garden` branch (a separate, far more developed instance of this same garden concept) and the `llm` branch carry the active design work; PRs land on `llm` and are merged with merge commits per the repo settings (`merge_commit_title=PR_TITLE`, `merge_commit_message=PR_BODY` since 2026-05-10).
- **Bot-fork roadmap branch: `llm` (designs); implementation base: `master` (implementations).** Designs land as draft PRs against `llm` per `roles/designer/AGENT.md` § Operating norms; implementations of those designs are separate builder dispatches that land on `master` per `roles/builder/AGENT.md`. The two PRs are never combined. Reference: `#232` (Node-18-drop design on `llm`) and `#246` (Node-18-drop master-base mirror). The boatman ferries master-base implementations upstream when authorized.
- **Base-branch inference from package availability** (added 2026-06-14 per kriskowal directive on `#440`): the builder's PR base depends on which packages the implementation touches.
  - **If the implementation touches packages that exist only on `llm`** (i.e., the package directory is present at `git ls-tree origin/llm -- packages/<name>` but absent at `git ls-tree origin/master -- packages/<name>`), the base is **`llm`**. Use a frozen `llm-<sha>` snapshot per `skills/frozen-base-branch/SKILL.md`; the conductor unfreezes to live `llm` at merge time per `roles/conductor/AGENT.md` § Loop step 2.
  - **If every touched package exists on both `llm` and `master`**, the base is **`master`** (the standard implementation trunk). Use a frozen `master-<sha>` snapshot per the same convention.
  - **Mixed touch is an impasse**: if the implementation must touch a package that is `llm`-only *and* a package that is `master`-only, the PR cannot have a single base. Stop and surface to the orchestrator; the resolution is typically either (a) the design should split into two implementations with different bases, or (b) the `master`-only package needs to be merged forward to `llm` before the implementation can proceed.
  - Builders inspect package availability *before* opening the PR. The check is one `git ls-tree origin/<branch> -- packages/<name>` per touched package, against both branches. Precipitating evidence: PR `#440` cut 3 (chat) impasse — the merged design's `packages/chat/*` exists only on `llm`; the builder attempting a `master`-base PR could not proceed because `packages/chat/` was absent on `master` (`packages/goblin-chat/` is the `master`-only sibling).
- **PRs use the standard per-PR role dispatch chain.** Fixers, weavers, shepherds, conductors, designers, scouts, botanists, major-generals all dispatch against PRs in this repo. The full chain is in [`../../../roles/steward/AGENT.md`](../../../roles/steward/AGENT.md) § Subordinate roles dispatched on the `main` branch.
- **Roadmap lives at `designs/README.md` on the `llm` branch.** The journalist (`roles/journalist/AGENT.md` on `main`) classifies PRs into milestones using the Per-Design Estimates table in that file; the bulletin's two delimited sections are bin-rendered against the roadmap.
- **PR dependency registry lives in `journal/pr-deps/`.** Each PR with a declared blocker has a file at `journal/pr-deps/<repo>-<number>.md`; the journalist reads the registry on each cycle via `skills/pr-dependency-graph/SKILL.md` and applies a topological sort within each milestone bin via `skills/pr-dependency-topo-sort/SKILL.md`.
- **Standing-monitor cadence is 30s** (faster than the other repos) because this is where contributor activity is densest and the steward wants short event-to-dispatch latency.

## Identity and credentials

Same shape as endo: `kriscendobot` for routine work on forks, `kriskowal` for upstream landings. Most work in this repo happens on `kriscendobot/endo-but-for-bots` (the bot's fork); landings on `endojs/endo-but-for-bots` use the kriskowal identity per the boatman flow (which here is rare, since the garden owns the upstream `llm` branch and frequently pushes directly with `kriskowal`).

## Standing authorizations

The maintainer's framing on 2026-05-13: "you are generally authorized to post freely on endo-but-for-bots. It is yours." Effect on the per-action authorization model in [`roles/COMMON.md`](../../../roles/COMMON.md) § External-repo etiquette on the `main` branch:

- The garden's roles may **post comments, reviews, review-comments, reactjis, and cross-references** on `endojs/endo-but-for-bots` issues and PRs **without per-action authorization in the dispatch prompt**, for this repository only. This is a repo-scoped relaxation, not a global one; every other repository still requires the per-action authorization the etiquette section describes.
- The relaxation covers commenting; it does not cover **destructive** actions (force-pushes to protected branches, branch deletions, repository-setting changes), which still require explicit per-action authorization.
- The relaxation applies to every role the garden dispatches against this repo: fixer, weaver, shepherd, conductor, scout, builder, designer, assayer, juror, saboteur, journalist, monitor, etc.
- Subagents dispatched against this repo should still **journal** any comment they post (a `tick` or `result` entry with `prs:` and the comment URL), so the garden's transcript carries the outward-facing artifacts.

**Lifecycle directives from a maintainer-authority are self-authorizing.** The destructive-action carve-out above (still-needs-per-action-authorization) is the *default* — it does not require a gardener to go re-collect a separate authorization when the directive to take the action *came from a maintainer-authority in the first place*. A **lifecycle / maintainer-level directive** — close these PRs, withdraw-and-open-fresh, this design disposition — issued by a maintainer-authority on this repo **is** the authorization for that action. The maintainer-authorities are **kriskowal** and **erights** (full authority; see [`roles/COMMON.md`](../../../roles/COMMON.md) § External-repo etiquette → *Maintainer-authority actors* on the `main` branch, and `journal2:maintainers/allowlist`). A gardener that receives such a directive from erights **acts on it directly and does not route it to the maintainer inbox for a separate authorization** — the routing of erights' "withdraw all three and open fresh" to the inbox (because PR-close exceeds the comment/reactji relaxation) is the specific defect this paragraph removes. Per kriskowal on PR #572, 2026-06-30 ("erights has all the authority of a maintainer"). **Boundary:** this is authority on repos the bot can already act on; it confers no upstream `endojs/endo` credentials, so closing/merging/commenting on upstream `endojs/endo` (e.g. a kriskowal-authored `endojs/endo#NNNN`) stays with kriskowal and the boatman path regardless of who issued the directive.

Other repos remain under the default rule (per-action authorization in the dispatch prompt). The ocapn project's much stricter rules (`../ocapn/README.md`) are unaffected.

## Upstream

- Repo: <https://github.com/endojs/endo-but-for-bots>
- Active branches: `llm` (active design + implementation), `garden` (the far-developed sibling-garden, integration target), `master` (kept in sync with endojs/endo upstream).
- Standing monitor on this host: `worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307/`; daemon cadence 30s.

## Authority structure

Per the maintainer's directive on 2026-05-29: the repository's GitHub permissions are guarded so only users with maintainer access can comment, review, or open pull requests. Every commenter on `endojs/endo-but-for-bots` is therefore effectively a maintainer, of equal authority on every subsystem and every topic. There is no topic-scoping that excludes any commenter from any subsystem on this repo.

### The general rule

Every author of a comment, review, review-comment, or pull request on `endojs/endo-but-for-bots` is treated as maintainer-equivalent. A `CHANGES_REQUESTED` or substantive `COMMENTED` review from any commenter routes the same way a `kriskowal` review would (fixer dispatch on `CHANGES_REQUESTED`, clear-the-row on `APPROVED`, etc.). A `@kriscendobot` mention in a comment body from any commenter authorizes the reactji-ack and the consequent dispatch named in `garden/skills/at-mention-surveillance/SKILL.md` § Reaction matrix. The repository's permission gate is the gate; the garden does not impose a second gate inside it.

### Non-exhaustive named list

The maintainer specifically named these users we must not ignore:

- **kriskowal**
- **kumavis**
- **erights** (Mark S. Miller)
- **danfinlay**
- **0xpatrick**

Plus **jcorbin**, recognized 2026-05-13 per kriskowal's directive at [endojs/endo-but-for-bots#148](https://github.com/endojs/endo-but-for-bots/pull/148) ("Josh is a maintainer on endo-but-for-bots").

The list is examples-of, not the closed set. Any user who can comment on this repo is, by virtue of the permission gate, in scope of the general rule above.

### Routing consequence

`@kriscendobot` (or otherwise-directed) instructions from any commenter on this repo route through the normal dispatch chain (fixer, judge, designer, etc.), not journal-only. The previous "Reviews from anyone else are journal-only by default" clause is retired for this repo; the steward's prior journal-only routing of kumavis's review-request comment on [#328](https://github.com/endojs/endo-but-for-bots/pull/328) (per [`../../entries/2026/05/29/015400Z-message-steward-b8c2d3.md`](../../entries/2026/05/29/015400Z-message-steward-b8c2d3.md)) is now overridden by this rule; the next steward cycle picks the comment up under the new routing.

### erights cross-repo note

The elevation of every commenter to maintainer-equivalent authority is **repo-scoped to `endojs/endo-but-for-bots` only**. The topic-scoped erights treatment on `endojs/endo` (per [`../endo/README.md`](../endo/README.md) § Authority structure) is **unchanged**: erights' authority on that repo remains scoped to `pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`, `captp`, `patterns`, the OCapN-family protocol, and capability-security generally, and reverts to high-signal input outside those topics.

The pattern is reusable. See `roles/COMMON.md` § Authority structure of upstream projects on the `main` branch for the cross-project framing.

## Rust crate bring-up

First-time bring-up of the `rust/endo/` crate in a freshly-prepared per-dispatch project worktree needs two priming steps that the long-lived clone does not:

1. **Initialize the moddable submodule.** `git submodule update --init --recursive c/moddable`. The submodule is uninitialized in a fresh worktree even when initialized in the bare clone.
2. **Stub the xsnap JS bundle inputs.** Touch (or `git checkout`) `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js`. The `include_str!` macros in `rust/endo/xsnap/src/lib.rs` make these compile-time dependencies; the real bundles come from `packages/daemon/scripts/bundle-*.mjs` which `cargo test --lib` does not run.

The README at `rust/endo/README.md` covers both steps, but the missing-stub error message ("couldn't read `rust/endo/xsnap/src/ses_boot.js`") sends a first-time reader chasing the bundle generation in `packages/daemon` instead of the README. Surfacing this here so the next builder/cleaner finds it.

Source: cleaner result `e31b72` on 2026-05-18 (one-engagement evidence per [`../../entries/2026/05/18/051155Z-message-cleaner-e31b72.md`](../../entries/2026/05/18/051155Z-message-cleaner-e31b72.md)).

## Per-topic detail

- [`taskpeace.md`](taskpeace.md): competitive study of TaskPeace (an MCP-native ranked task queue for AI coding agents) against our ocap agent substrate — gestalt, feature inventory, two-way gap analysis, and eight recommended design directions ([kriskowal/garden#30](https://github.com/kriskowal/garden/issues/30)).
- [`macos-ci-flake-260.md`](macos-ci-flake-260.md): the macos-15 CI flake investigation (issue #260) — the umbrella cause is DNS, not test flakes.
- [`xs-from-rust-investigation.md`](xs-from-rust-investigation.md): notes from the XS-from-Rust investigation.

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/194807Z-worktree-liaison-619681.md`](../../entries/2026/05/12/194807Z-worktree-liaison-619681.md): the bare-clone setup, the discovery that the `garden` branch already carries a far-developed sibling garden, and the bare-clone `info/exclude` mechanism.
- Steward and journalist cycle entries for PR backlog churn (heaviest project).
- The `process/` documents mirrored into the journal (`STEWARD-STATE-*`, `major-generalship.md`, etc.) under the `endo-but-for-bots` slug; grep `^project: endo-but-for-bots$` over `entries/`.

The `endo-but-for-bots` project's interaction surface is unusually broad; topic candidates as the scholar grows this directory include `pr-flow.md`, `merge-mechanics.md`, `ci-workflow-failures.md`, `dependency-registry.md`.
