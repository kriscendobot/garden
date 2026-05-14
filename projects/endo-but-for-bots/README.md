# Project: endo-but-for-bots

The endo fork the garden actively develops. Upstream is [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots). This is where most of the garden's per-PR work happens: fixers, weavers, shepherds, designers, conductors all operate on PRs in this repo, and the *Pending kriskowal reviews* and *PR backlog* sections of `journal/README.md` are dominated by its PRs.

## Rules of engagement

- **Default branch for active development: `llm`.** The garden's `garden` branch (a separate, far more developed instance of this same garden concept) and the `llm` branch carry the active design work; PRs land on `llm` and are merged with merge commits per the repo settings (`merge_commit_title=PR_TITLE`, `merge_commit_message=PR_BODY` since 2026-05-10).
- **Bot-fork roadmap branch: `llm` (designs); implementation base: `master` (implementations).** Designs land as draft PRs against `llm` per `roles/designer/AGENT.md` § Operating norms; implementations of those designs are separate builder dispatches that land on `master` per `roles/builder/AGENT.md`. The two PRs are never combined. Reference: `#232` (Node-18-drop design on `llm`) and `#246` (Node-18-drop master-base mirror). The boatman ferries master-base implementations upstream when authorized.
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

Other repos remain under the default rule (per-action authorization in the dispatch prompt). The ocapn project's much stricter rules (`../ocapn/README.md`) are unaffected.

## Upstream

- Repo: <https://github.com/endojs/endo-but-for-bots>
- Active branches: `llm` (active design + implementation), `garden` (the far-developed sibling-garden, integration target), `master` (kept in sync with endojs/endo upstream).
- Standing monitor on this host: `worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307/`; daemon cadence 30s.

## Authority structure

The repo has two kinds of non-default authority. **Maintainer authority** is repo-wide and topic-agnostic: a maintainer's review or directive on any PR routes the same regardless of subsystem. **Senior-contributor authority** is topic-scoped: a senior contributor's review on a topic-matching PR carries maintainer-equivalent (or greater) weight on the technical question within that topic set, and reverts to high-signal input outside it. Both are recorded here; the per-project monitor skill (`garden/skills/monitor-endo-but-for-bots/SKILL.md`) consumes both and routes accordingly.

### Maintainers

- **kriskowal** is the default-authority maintainer for the repo.
- **jcorbin** is a maintainer on this repo, recognized 2026-05-13 per kriskowal's directive at [endojs/endo-but-for-bots#148](https://github.com/endojs/endo-but-for-bots/pull/148) ("Josh is a maintainer on endo-but-for-bots"). His review or comment carries maintainer-equivalent weight across the whole repo, with no topic scope: a `CHANGES_REQUESTED` or substantive `COMMENTED` review from jcorbin on any PR routes the same way a kriskowal review would (fixer dispatch on `CHANGES_REQUESTED`, clear-the-row on `APPROVED`, etc.). The recognition is repo-scoped to `endojs/endo-but-for-bots` and does not extend to `endojs/endo` absent further confirmation; the parallel [endo project README](../endo/README.md#authority-structure) is unchanged.

### Senior contributors

Identical in shape to the [endo project's authority structure](../endo/README.md#authority-structure):

- **erights** (Mark S. Miller) is a senior contributor whose authority meets or exceeds the maintainers' on a defined set of topics: `pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`, `captp`, `patterns`, the OCapN-family protocol, and capability-security generally. These are the subsystems and concepts erights designed or co-authored; his review or substantive comment on a PR that touches any of them carries maintainer-equivalent (or greater) weight on the *technical question*. A `CHANGES_REQUESTED` or substantive `COMMENTED` review from erights on a topic-matching PR routes the same way a maintainer review would: the garden treats it as a directive on the technical merits and the fixer addresses it. (Authorization to *act* still flows through the maintainer authorization chain in `roles/COMMON.md` § External-repo etiquette on the `main` branch; senior-contributor weight changes how the garden reads the technical content, not who can push.)
- Outside those topics, on garden-internal infrastructure (CI, the bulletin's `endo-but-for-bots`-specific machinery, the `garden` sibling branch), or on scope unrelated to the listed subsystems, erights' input is senior-contributor input rather than maintainer-equivalent. Surface it loudly; do not auto-route to a fixer.

### Practical rule

A review or directive from a recognized maintainer (kriskowal or jcorbin) routes as a maintainer signal on every PR, every topic. A review from erights on a topic-matching PR is read as technically authoritative; on anything else, it is high-signal input the maintainers adjudicate. Reviews from anyone else are journal-only by default.

The pattern is reusable. See `roles/COMMON.md` § Authority structure of upstream projects on the `main` branch for the cross-project framing.

## Per-topic detail

(None yet; the scholar grows this set.)

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/194807Z-worktree-liaison-619681.md`](../../entries/2026/05/12/194807Z-worktree-liaison-619681.md): the bare-clone setup, the discovery that the `garden` branch already carries a far-developed sibling garden, and the bare-clone `info/exclude` mechanism.
- Steward and journalist cycle entries for PR backlog churn (heaviest project).
- The `process/` documents mirrored into the journal (`STEWARD-STATE-*`, `major-generalship.md`, etc.) under the `endo-but-for-bots` slug; grep `^project: endo-but-for-bots$` over `entries/`.

The `endo-but-for-bots` project's interaction surface is unusually broad; topic candidates as the scholar grows this directory include `pr-flow.md`, `merge-mechanics.md`, `ci-workflow-failures.md`, `dependency-registry.md`.
