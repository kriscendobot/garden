All fixes are on the PR head (`5e2538462c`); only the 2 multichain-e2e legs remain red — the surfaced resource impasse. This is a clean shepherd stopping point per the definition of done. Writing the completion report.

---

**Shepherd report — kriscendobot/agoric-sdk PR #17** (`ci: retarget the integration chain off Depot for the fork`)

CI was red on the auto-dispatched PR. I drove it substantially to green with three atomic fixes pushed to the PR head (`xst/fork-ci-depot-workaround`), then hit one genuine resource impasse and handed it off.

**Fixes pushed (root-cause, each its own commit):**
1. `78922bff44` — `deployment-test` aborted at ansible `prepare-machine.yml` with *"Vars in a Play must be specified as a dictionary."* The retarget to `ubuntu-latest` brought ansible-core ≥2.19, which removed support for list-form play `vars:`. Converted all 21 `packages/deployment/ansible/*.yml` play-`vars:` blocks from list to dict form (semantically identical, accepted by every ansible-core).
2. `01dc5c073c` — that conversion left the one nested list value (`to_remove` in `prometheus-node-disable.yml`) at 8-space indent, which the repo's `dprint fmt` (`lint-rest`) rejected. Re-indented to 6.
3. `5e2538462c` — `deployment-test` then failed with `GLIBCXX_3.4.32 not found` loading `agcosmosdaemon.node`. That job builds the native addon on the host and bind-mounts it into `node:22-bookworm` validator containers (libstdc++ ≤ 3.4.30); `ubuntu-latest` is now 24.04 and links against 3.4.32. Pinned `deployment-test` to `ubuntu-22.04` (matching the original `depot-ubuntu-22.04` runner) for libstdc++ parity. Other jobs build the addon inside the bookworm image and were left on `ubuntu-latest`.

**Result on the fresh run (`5e2538462c`):** `deployment-test`, `build-sdk-ci-image`, `test-ymax-planner-build`, `getting-started-flag` all **green**; `test-docker-build` (a3p) was on its final `run proposals tests` step, tracking green. Protobuf / Test Golang / golangci-lint / Pre-merge / scripts also green (earlier Protobuf "CANCELLED" were just concurrency supersessions).

**Impasse handed off — `next: liaison` (maintainer decision):** both `multichain-e2e` Hermes legs (`test:main`, `test:fast-usdc`) fail at **Setup Starship Infrastructure**, timing out after the full 20 min — the 3-chain + 3-relayer Starship k8s cluster never reaches readiness on the GitHub-hosted `ubuntu-latest` runner, where the original `depot-ubuntu-24.04-16` had the capacity. This is exactly the "heavy legs may need resource/timeout tuning" the PR author flagged; the PR's stated bar (Depot no longer blocks dispatch; legs run on the fork) is met. Greening these needs either bigger fork runners (unavailable — the whole premise of the PR) or substantial, uncertain infra tuning (image pre-pull, disk/memory cleanup, higher timeouts) — beyond a shepherd's surgical scope. Not a flake, not an in-diff code fix.

**Hand-off:** messaged the maintainer via the message bus (delivered to `inbox/maintainer`) with the three options: provision larger fork runners, mark `multichain-e2e` non-required on the fork, or post a `fixer` to attempt the tuning. Did **not** comment on the PR (no per-action authorization).

Follow-up: only the two `multichain-e2e` legs remain red on the head SHA, pending the maintainer's runner/requirement decision.
