Review preflight proceeded. Fetched review body and found 0 inline comments.

Created a serial orchestration:
- Fixer: resolve PR #4’s conflict and provision the approved AWS OIDC prerequisite.
- Conductor: verify readiness and merge only after the fixer succeeds.

The fixer has been promoted; the conductor remains correctly gated. PR #4 is currently open, non-draft, and conflicting. No local code changes.
