Inbox empty. The work is complete and verified.

## Completion report

**Job:** Provision the pinned LTS (Node 24) onto fleet hosts so `local-verify`'s Node-runtime-parity guard adopts it rather than refusing every Node-24 project (follow-up to `fix-local-verify-node24-eslint-parity`, endojs/endo-but-for-bots#1048).

**What I did** — chose option (a), the reproducible image bake, and provided the live-host path with the same code (one source of truth). Landed on `main2` (`c1583f733f`):

- **`scripts/jobs/provision-node-lts.sh`** (new): reusable, idempotent installer. Downloads the official nodejs.org tarball for the pinned LTS major (default `$GARDEN_NODE_LTS_LATEST`, else 24) and unpacks it into `/usr/local/n/versions/node/<version>/` — the `n`-shaped root the guard's `find_node_bin_for_major` already searches — **without** displacing the primary `/usr/local/bin/node` (v22). Uses sudo on a live host, direct write at Docker build (root). Shellcheck-clean.
- **`Dockerfile`**: added `ARG NODE_LTS_MAJOR=24` and a layer that `COPY`s + runs the provisioner, so a rebuilt-and-deployed host carries Node 24 reproducibly, image and live-host paths running identical code.
- **`garden`**: registered the provisioner in `build_contract_inputs` so a future edit to it correctly flips the image to STALE (the launcher's staleness contract).
- **`skills/node-lts-window-watch/SKILL.md`**: documented the fleet-host runtime surface and the **three-place lockstep bump** (common.sh `GARDEN_NODE_LTS_LATEST`, Dockerfile `NODE_LTS_MAJOR`, provisioner default) for when the newest LTS advances past 24 — tying the runtime advance to the pin advance this skill already plans.

**Verified** (this host, endolin-garden2-5bcdff64): provisioned Node v24.19.0 live; in a real endo-but-for-bots (`.node-version=lts/*` → 24) worktree, `local-verify.sh`'s parity gate now **adopts Node 24 and exits 0 — no `NODE RUNTIME PARITY`**. Control: a genuinely-absent major (30) still **refuses**, exit 3. Provisioner re-run is a clean no-op (idempotent).

**Follow-ups (surfaced to maintainer via message-user):** this is a Dockerfile change — the bake reaches all hosts reproducibly, but only on the next `deploy-garden.sh` rebuild+deploy. The other running containers (`endolin-garden-ece02cb4`, `ps23`, `ps23-garden-f65473ae`) keep refusing Node-24 projects until redeployed; for immediate relief, run `scripts/jobs/provision-node-lts.sh` inside each. I could only reach this host from a per-job worker (no generic cross-host run-command sysop op exists).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/provision-node24-fleet-hosts-20260822.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3061732 cached reads)
- Output: 27174 tokens
- Cost: $3.036927999999999
- Wall-clock: 461s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
