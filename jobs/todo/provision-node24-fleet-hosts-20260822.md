---
role: sysop
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Provision the pinned Node (LTS/24) onto fleet hosts so local-verify adopts rather than refuses

Follow-up to `fix-local-verify-node24-eslint-parity` (main2 57d851dfaf,
endojs/endo-but-for-bots#1048). local-verify now enforces Node runtime parity:
a project pinning a Node major different from the host's `node` FAILS LOUD
(`NODE RUNTIME PARITY`, exit 3) instead of emitting a misleading green.

Current fleet hosts ship only Node 22 (`/usr/local/bin/node` v22.23.2) with no
version manager, while endo-but-for-bots pins `.node-version=lts/*` → Node 24.
So the guard will now REFUSE every Node-24 project's verification on these hosts
until a matching runtime exists. The guard already ADOPTS a runtime it can
discover under nvm/fnm/n/volta roots or an explicit `GARDEN_NODE`.

Task: make the current LTS (Node 24) discoverable on each fleet host so the guard
adopts it. Options to weigh: (a) bake Node 24 into the container image alongside
Node 22; (b) install via `n`/`nvm` into a version-manager root the guard already
searches (`~/.nvm/versions/node`, `/usr/local/n/versions/node`, ...); (c) set a
per-host `GARDEN_NODE` pointing at an installed Node 24. Prefer whatever keeps
the image reproducible. When the current newest LTS advances past 24, bump
`GARDEN_NODE_LTS_LATEST` (default 24 in common.sh) and provision the new major —
tie this to skills/node-lts-window-watch.

Verify by running `scripts/jobs/gardening/local-verify.sh` in an endo-but-for-bots
worktree and confirming it does NOT emit `NODE RUNTIME PARITY` (it adopts Node 24).
