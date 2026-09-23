Pushed successfully.

Edited `roles/scholar/AGENT.md`: the "Push to upstream forks or touch any external system" prohibition (in § Posture and authority bounds) now carries a one-line clarification that this bound means no external *writes/side-effects* (upstream pushes, comments, API mutations), and explicitly does **not** forbid the read-only paper/web source retrieval ingestion needs — naming the sanctioned `fetch-source.sh` / `check-source-children.sh` fetches from step 4 so the apparent tension with the scholar's own ingestion procedure is resolved.

Committed as `e2577cecc3` and pushed to `main2` via the rebase CAS loop (clean first try). No follow-ups.
