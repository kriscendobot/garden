The inbox drain infrastructure is timing out on its journal clone (twice, rc=124 — a slow clone, best-effort drain skipped); the deliverable itself is complete and pushed. Final report:

---

## Completion report: `mentat-minion-town-cloudflare-backend-plan`

**Design file:** `designs/cloudflare-backend.md` on branch `design/cloudflare-backend` in `kriscendobot/minion.town` (commit `5db9927`).

**PR:** [kriscendobot/minion.town#127](https://github.com/kriscendobot/minion.town/pull/127), **draft**, opened via `ensure-pr.sh` against the frozen base `main-f69bf87` (the same snapshot the four sibling design PRs #123–#126 use, so the diff is the design file alone). Left draft per the manual-gauntlet regime; the maintainer promotes with **run the gauntlet #127**.

**What the design says (one paragraph):** Cloudflare splits into three grades of fit. Adopt: R2 as the CAS via the existing portable S3-compatible adapter (strongly consistent, zero egress — the best clip-serving economics of any sibling platform); a per-principal **Durable Object** as the formula store and shard actor — the platform's single-threaded actor *is* the single-writer lease the AWS sibling builds by hand out of DynamoDB condition checks, with 30-day PITR built in; D1 for the request-shaped app stores; KV disqualified (eventual consistency). Promising but not load-bearing: **Cloudflare Artifacts** (Git-compatible storage for agents, beta 2026-04-16) — an architectural vindication of `git-remote-capability` (repo-per-agent on DO SQLite), but beta, token semantics unpublished, and a second content plane that bypasses our CAS invariants at 33× R2 storage price; verdict is build the git remote on primitives (port PR #86 to Worker + DO + R2), re-evaluate Artifacts at GA. Constrained: the runtime — Workers ban `eval`/`new Function` outright, so guest evaluation can never run V8-native; the plannable compute path is Cloudflare Containers with DO/R2 persistence (shipping), Iron Horse-on-wasm32-in-a-DO is the strategic probe (shared with PR #123), and R2-only composes with the AWS plan today from off-platform compute. Guest-held **indelible enqueue/schedule capabilities** are designed over Queues and a DO-alarm-multiplexed agenda: attenuated by binding + facet, revocable even for in-flight messages via `capId` liveness checks, cancelled via the `cancelled`-promise pattern, metered reserve→perform→settle on the shard's account. All vendor facts were fetched from first-party Cloudflare docs on 2026-09-28 with inline citations; the mermaid diagram parse-validates; the ownership map and a clearly marked cross-repo Endo section (§ 9) are included.

**Open questions for the maintainer (design § 11):** engine placement (Containers + DO-as-remote-store now vs waiting on the wasm32 probe); Artifacts posture; actor grain (per-principal recommended); whether scheduling capabilities standardize upstream as `@endo/reminder` first; queue topology (shared queues recommended over per-shard, dodging the 10k-queue cap); Cloudflare as candidate primary vs serving/backup complement to AWS; account/plan/authorization (nothing was created — no account, no resources, no spending).

**Proposed build sequence (suggested basenames, not posted):** `probe-minion-town-r2-cas-fidelity` → `build-minion-town-cloudflare-gateway-worker` → `build-minion-town-d1-app-stores` → `build-minion-town-shard-actor-do` → `build-minion-town-git-remote-worker` → `probe-ironhorse-wasm32-do` → `build-minion-town-cloudflare-containers-daemon`.

**Follow-ups:** none owed by this job. One note for the liaison: the job-inbox drain (`inbox-read.sh`) hit repeated 45s journal-clone timeouts (rc=124/75) at completion time — if a maintainer message was in flight, it will dead-letter and re-promote per the bus contract.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-minion-town-cloudflare-backend-plan.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 48 tokens (2368829 cached reads)
- Output: 39978 tokens
- Cost: $7.121888 (2 engagement(s) unpriced)
- Wall-clock: 766s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
