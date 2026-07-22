scripts/jobs/ensure-project-worktree.sh
Recurring failure: `better-sqlite3` (and other native modules) fail to build in a freshly-created per-job project worktree, repeatedly across jobs and hosts (see journal entries 054129Z-xs2rust press-driver and 054640Z-result-gardener), leaving daemon test files unrunnable so PR verification is silently incomplete. Today this script only creates the git worktree and does no dependency provisioning at all, so each gardener improvises `yarn install` by hand in an empty tree — the native compile is re-run and re-fails N times, ad-hoc, with success/failure visible only in agent prose.

Move dependency provisioning off the agent into this script: after (re)creating the worktree, populate its `node_modules` from a warm, per-repo shared cache (hardlink/CoW copy, the same pnpm-linker hardlink pattern the local-run recipe uses), so native modules are built **once** in a single controlled place and reused across every fresh per-job worktree rather than rebuilt each time. Key the cache by `<owner>/<repo>@<branch>` (or lockfile hash) alongside the existing bare clone; refresh it when the lockfile changes; skip repopulation on a resume-reuse of an existing worktree (preserving the current resume-stability guarantee). Emit a deterministic log line for install/build success or failure so a broken toolchain surfaces as a script signal instead of a buried agent note.

If the native build in fact **never** succeeds in this environment (missing compiler/python), the warm cache cannot manufacture a build that never existed — in that case the implicated fix moves to the container image/entrypoint (build-essential + python toolchain), which the builder should flag rather than silently cache an empty result. Name that as the fallback, but attempt the warm-cache path first since one host does complete `yarn install` (5s) with the native build as the only failing component, implying the toolchain is present and the cost is redundant per-worktree rebuilds.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-22T05:52:23Z
