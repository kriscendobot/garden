---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (branch `main`, commit 476b535).

`package.json` now runs `dev:as`, `dev:mcp`, `start`, `client`, and `billing:demo` with `--env-file=.env`. Node's `--env-file` is a hard error when the file is missing, and `.env` is gitignored — so on a fresh clone every one of those scripts now dies with ENOENT before the README's `cp .env.example .env` step, where previously they started with defaults. (Production is unaffected: `minion-mcp.service` execs `node dist/index.js` directly with `Environment=` lines, not `npm start`.)

Task (fixer):
- Switch these scripts to `--env-file-if-exists=.env` (Node ≥ 20.12 / 21.7; `engines` says `>=20`, so confirm the floor is acceptable or raise it deliberately) and verify `tsx` forwards the flag to node for `dev:as`, `dev:mcp`, `client`, and `billing:demo`.
- Verify the README quickstart end to end from a clean clone in a scratch worktree — both with and without a `.env` present — since making that quickstart work with zero external deps is the point of the surrounding commits: `npm ci`, `npm run dev`, `npm run client`, and confirm the client reaches the guest tools via the in-memory host and that the printed tool count matches the README's refreshed expected output.
- Report any residual gap between the README's promised output and the actual client output rather than silently editing one to match the other.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-30T05:51:09Z
