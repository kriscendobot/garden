# Project: endo-but-for-bots

The endo fork the garden actively develops. Upstream is [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots). This is where most of the garden's per-PR work happens: fixers, weavers, shepherds, designers, conductors all operate on PRs in this repo, and the *Pending kriskowal reviews* and *PR backlog* sections of `journal/README.md` are dominated by its PRs.

## Rules of engagement

- **Default branch for active development: `llm`.** The garden's `garden` branch (a separate, far more developed instance of this same garden concept) and the `llm` branch carry the active design work; PRs land on `llm` and are merged with merge commits per the repo settings (`merge_commit_title=PR_TITLE`, `merge_commit_message=PR_BODY` since 2026-05-10).
- **PRs use the standard per-PR role dispatch chain.** Fixers, weavers, shepherds, conductors, designers, scouts, botanists, major-generals all dispatch against PRs in this repo. The full chain is in [`../../../roles/steward/AGENT.md`](../../../roles/steward/AGENT.md) § Subordinate roles dispatched on the `main` branch.
- **Roadmap lives at `designs/README.md` on the `llm` branch.** The journalist (`roles/journalist/AGENT.md` on `main`) classifies PRs into milestones using the Per-Design Estimates table in that file; the bulletin's two delimited sections are bin-rendered against the roadmap.
- **PR dependency registry lives in `journal/pr-deps/`.** Each PR with a declared blocker has a file at `journal/pr-deps/<repo>-<number>.md`; the journalist reads the registry on each cycle via `skills/pr-dependency-graph/SKILL.md` and applies a topological sort within each milestone bin via `skills/pr-dependency-topo-sort/SKILL.md`.
- **Standing-monitor cadence is 30s** (faster than the other repos) because this is where contributor activity is densest and the steward wants short event-to-dispatch latency.

## Identity and credentials

Same shape as endo: `kriscendobot` for routine work on forks, `kriskowal` for upstream landings. Most work in this repo happens on `kriscendobot/endo-but-for-bots` (the bot's fork); landings on `endojs/endo-but-for-bots` use the kriskowal identity per the boatman flow (which here is rare, since the garden owns the upstream `llm` branch and frequently pushes directly with `kriskowal`).

## Upstream

- Repo: <https://github.com/endojs/endo-but-for-bots>
- Active branches: `llm` (active design + implementation), `garden` (the far-developed sibling-garden, integration target), `master` (kept in sync with endojs/endo upstream).
- Standing monitor on this host: `worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307/`; daemon cadence 30s.

## Per-topic detail

(None yet; the scholar grows this set.)

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/194807Z-worktree-liaison-619681.md`](../../entries/2026/05/12/194807Z-worktree-liaison-619681.md): the bare-clone setup, the discovery that the `garden` branch already carries a far-developed sibling garden, and the bare-clone `info/exclude` mechanism.
- Steward and journalist cycle entries for PR backlog churn (heaviest project).
- The `process/` documents mirrored into the journal (`STEWARD-STATE-*`, `major-generalship.md`, etc.) under the `endo-but-for-bots` slug; grep `^project: endo-but-for-bots$` over `entries/`.

The `endo-but-for-bots` project's interaction surface is unusually broad; topic candidates as the scholar grows this directory include `pr-flow.md`, `merge-mechanics.md`, `ci-workflow-failures.md`, `dependency-registry.md`.
