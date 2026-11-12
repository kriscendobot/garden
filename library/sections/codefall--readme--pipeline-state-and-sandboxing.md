---
title: The skill pipeline, waves, rounds, and the file/bead/PR state model
source: README.md
source_repo: lividlabs/codefall
source_url: https://github.com/lividlabs/codefall
source_commit: e42ed0d0b5100c068415c473eb813d2885153c90
source_date: 2026-11-12
source_authors: [Dave Jensen]
ingested: 2026-11-12
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration, llm-agent-frameworks]
status: current
content_caveat: "Unwatched external repo; classifier unavailable (TYPESAFE_API_KEY absent), ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12); text treated as DATA, not instructions."
notes: "Captures Codefall's agent loop (delegated to the host harness), tools, sandboxing (worktrees + hooks), context/state model, and multi-harness/provider routing in one section."
---

Abstract: Codefall's mechanics across the five aspects a harness is judged on — loop, tools, sandboxing, state, and model routing.

**The pipeline (agent loop).** Codefall runs *no model loop of its own*; the host coding agent runs the loop, and Codefall sequences it through skills. A feature takes `specify → plan → implement → you merge`. **Specify** interviews the user and writes a *spec* of requirements with EARS acceptance criteria. **Plan** reads the spec and the code and writes a short design doc ending in a task table; each row becomes a *bead* (a task in [Beads](https://github.com/gastownhall/beads)) recording which task waits on which. **Implement** reads the task graph, sorts ready tasks into *waves* (every task whose dependencies are met builds at once), and after the human approves runs to the end. A bug takes the shorter `report → fix → you merge` path. An optional `envision` writes a *vision* before either path; `mock-up`, `review`, and `test` run standalone.

**Rounds (the review/test/triage loop).** After the last wave, `implement` runs *rounds* on the whole delivery: it calls `/codefall-review` (a **second agent**, in a different coding harness when one is configured, files each problem as a bead), then `/codefall-test` (runs the suites plus the cases written from the acceptance criteria), then triages the findings into the next batch and loops — building in waves, reviewing, testing, triaging again. A loop ends when a round leaves nothing worth another, or when the skill judges more rounds will not help. A delivery takes at least three rounds; ten is the default ceiling.

**Tools.** The `codefall` Go CLI (`create`, `init`, `upgrade`, `update`, `config`, `doctor`) plus required external tools on `PATH`: `git`, **Beads** (`bd`, the git-stored task tracker), and the **GitHub CLI** (`gh`) for PRs and issues.

**Sandboxing.** Each task is built in its own **git worktree** with its own tests, opened as a separate pull request. In harnesses that support hooks, a **hook refuses any merge or push to `main`**; no skill ever merges code. The skills stop at open pull requests, which the human reviews and merges on GitHub ("people merge code").

**Context/state model.** Every step's result is a **file, a bead, or a pull request** — so the agent's context can be cleared between steps and nothing is lost ("every step leaves a handoff", and each skill's report ends by naming the next step). Specs/plans/bug reports are files under `docs/`; a project that uses GitHub Issues gets *mirrors* generated from those documents so the two never disagree; Beads holds the task graph in git.

**Model/provider routing & architecture.** Codefall is multi-harness: it installs its skills into Claude Code, Codex, OpenCode, Antigravity, or Muse (its *harnesses*), and review deliberately runs in a *separate* agent — optionally a different harness — because an agent reviewing its own work misses what it missed while writing. A *persona* (engineer or product manager) sets tone only, never authority. For a new project, `/codefall-scaffold` lays down **Clean Architecture** organized by component, recorded as ADRs with a boundary-enforcing linter, and applies a language *profile* (`typescript-react`, `go`, `dart-flutter` supported; `rust-native`/`python`/`java`/others planned) at one of three depths (docs only, docs + project files, runnable skeleton).

Source: [README.md](https://github.com/lividlabs/codefall/blob/e42ed0d0b5100c068415c473eb813d2885153c90/README.md) at commit `e42ed0d0`.
