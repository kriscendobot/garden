---
ts: 2026-05-13T21:19:36Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener — journalist omits PRs from archived projects

Dispatch root: `dispatches/gardener--journalist-omit-archived--20260513-211935--25a962/`.

Task: small edit to `roles/journalist/AGENT.md` adding a rule: the bulletin omits any PR whose repository's GitHub state is archived. Check via `gh repo view <owner>/<repo> --json isArchived`. For efficiency, the review-queue daemon may cache the result by `(owner, repo)` with a long TTL (archived state changes rarely). The journalist consumes the field from `current.json` if extended, or queries directly per render.

Decide whether the daemon needs extending. If extending, mirror the `baseRefName` precedent from earlier this turn (per-row REST fetch with caching).

Out of scope: do not re-render the bulletin; next journalist dispatch picks up the rule. Do not modify other roles.

Report: commit SHA on `main`, whether the daemon needed extending, one-line confirmation that PRs in archived projects (e.g., `uber-archive/idl`) will drop from the next bulletin run.
