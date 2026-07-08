---
title: Symphony Service Specification — workspace management and safety invariants
source_kind: web
source_url: https://openai.com/index/open-source-codex-orchestration-symphony/
source_snapshot: http://web.archive.org/web/2id_/https://openai.com/index/open-source-codex-orchestration-symphony/
source_content_sha256: b7c17d55f4faf42eb09282c0670a14dce360f83a5fe205834b5bbe09a7695c09
source_authors: [Alex Kotliarskyi, Victor Zhu, Zach Brock]
source_date: 2026-04-27
retrieved: 2026-07-08
ingested: 2026-07-08
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

Abstract: Workspace management and safety (§9) — the per-issue filesystem isolation that the spec calls "the most important portability constraint." Each issue gets one workspace at `<workspace.root>/<sanitized_issue_identifier>`; workspaces are **reused across runs** and are not auto-deleted on success. Population beyond directory creation (checkout, dependency bootstrap, code generation) is implementation-defined and typically done via lifecycle hooks (`after_create`, `before_run`, `after_run`, `before_remove`) executed in a local shell with the workspace as cwd. Three **safety invariants** are the load-bearing constraint: (1) run the coding agent only in the per-issue workspace path (validate `cwd == workspace_path` before launch); (2) the workspace path must stay inside the workspace root (normalize to absolute, require the root as a prefix, reject anything outside); (3) the workspace key is sanitized to `[A-Za-z0-9._-]`, all other characters replaced with `_`.

## Workspace layout, creation, and reuse (§9.1–§9.2)

The workspace root is `workspace.root` (a normalized path; the config layer expands path-like values and preserves bare relative names). The per-issue path is `<workspace.root>/<sanitized_issue_identifier>`. Workspaces are **reused across runs** for the same issue, and successful runs do **not** auto-delete them.

Creation algorithm (input `issue.identifier`): (1) sanitize the identifier to `workspace_key`; (2) compute the workspace path under the root; (3) ensure the path exists as a directory; (4) set `created_now=true` only if the directory was created during this call, else `false`; (5) if `created_now=true`, run the `after_create` hook if configured. The section makes no assumption about a specific repository/VCS workflow — preparation beyond directory creation (dependency bootstrap, checkout/sync, code generation) is implementation-defined and typically handled via hooks.

## Optional workspace population (§9.3)

The spec requires no built-in VCS or repository bootstrap. Implementations may populate/synchronize the workspace via implementation-defined logic and/or hooks (e.g. `after_create` / `before_run`). Failure handling: population/sync failures return an error for the current attempt; a failure while creating a brand-new workspace may remove the partially-prepared directory; reused workspaces should **not** be destructively reset on population failure unless that policy is explicitly chosen and documented.

## Workspace hooks (§9.4)

Supported hooks: `after_create`, `before_run`, `after_run`, `before_remove`. Execution contract: run in a local shell appropriate to the host OS with the workspace directory as cwd (on POSIX, `sh -lc <script>` or a stricter `bash -lc` equivalent is conforming); the timeout is `hooks.timeout_ms` (default 60000); log hook start, failures, and timeouts. Failure semantics: `after_create` failure/timeout is fatal to workspace creation; `before_run` failure/timeout is fatal to the current attempt; `after_run` and `before_remove` failures/timeouts are logged and ignored.

## Safety invariants (§9.5)

This is the most important portability constraint.

- **Invariant 1 — run the agent only in the per-issue workspace path.** Before launching the coding-agent subprocess, validate `cwd == workspace_path`.
- **Invariant 2 — the workspace path must stay inside the workspace root.** Normalize both paths to absolute, require `workspace_path` to have `workspace_root` as a prefix directory, and reject any path outside the root.
- **Invariant 3 — the workspace key is sanitized.** Only `[A-Za-z0-9._-]` is allowed in workspace directory names; replace all other characters with `_`.

> Symphony's per-issue workspace isolation is the direct analogue of the garden's per-job worktree (`ensure-project-worktree.sh`), which keys each checkout by the job base so two gardeners on the same PR never share a working tree — the same "one isolated filesystem per unit of work, never run outside it" invariant that Symphony's §9.5 makes explicit. Symphony's cwd-inside-root check corresponds to the garden's refusal to let a job mutate the deployed garden root.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
