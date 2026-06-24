---
ts: 2026-05-18T09:25:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/18/091917Z-message-shepherd-c1e5c7.md
---

# Dispatch: gardener lands pr-ci-watch Notes-from-field row on zero-runs-from-conflict diagnostic

Dispatch root: `dispatches/gardener--386b31/`. Garden-only.

Shepherd `c1e5c7` surfaced a single-engagement diagnostic gap at `entries/2026/05/18/091917Z-message-shepherd-c1e5c7.md`. Precipitating case: PR #286 had ~25 min of zero CI runs after push; cleaner read it as a queue delay or approval gate; actual cause was a `designs/README.md` conflict against `llm` → `CONFLICTING`/`DIRTY` `mergeable_state` → GitHub does not create the synthetic merge ref → `pull_request` workflows don't dispatch. The shepherd role file documents the operating norm; the gap is in the upstream `pr-ci-watch` skill where the symptom appears first to a non-shepherd reader (cleaner, contractor, liaison).

## Task

Read `garden/roles/COMMON.md`, then the shepherd's message verbatim, then `garden/skills/pr-ci-watch/SKILL.md`.

1. **Edit `garden/skills/pr-ci-watch/SKILL.md`** — add a Notes-from-the-field row covering:

   > **2026-05-18:** When a PR's `statusCheckRollup` is `[]` indefinitely after a push (zero workflow runs visible in `gh api repos/<o>/<r>/actions/runs?head_sha=…`), query `mergeable_state` before speculating about a GitHub Actions queue delay, workflow-approval gate, or first-time-contributor gate. A `CONFLICTING` / `DIRTY` PR cannot dispatch `pull_request` workflows because GitHub does not create the synthetic merge ref while the conflict exists.
   > **One-liner:** `gh pr view <N> -R <repo> --json mergeable,mergeStateStatus`.
   > This is the same case `roles/shepherd/AGENT.md` § *Conflicting PRs block CI dispatch* documents, surfaced here as the diagnostic recipe a non-shepherd reader reaches first.
   > Precipitating engagement: shepherd on PR #286 (`cli-http-client` Phase 1) — root cause was a `designs/README.md` conflict; remediation was a weaver hand-off.

   Cite `entries/2026/05/18/091917Z-message-shepherd-c1e5c7.md` as one-line provenance.

2. **Bump frontmatter** `updated`; add `liaison, gardener` to `author` if not already there.

3. **Do NOT touch `roles/shepherd/AGENT.md`** — the operating norm already exists there per the shepherd's own framing.

4. **Write the result entry** at `journal/entries/2026/05/18/<ts>-result-gardener-386b31.md`: file edited, one-line `Self-improvement: ...`.

5. **Commit + push both branches.**

## Per-action authorization

Standing on garden's main + journal per CLAUDE.md § Conventions.

## Out of scope

- No code on any project repo.
- No promotion to a standing rule.
- No edits to the shepherd role file.

## Report

≤ 150 words: file path edited, one-line `Self-improvement: ...`.
