The work is complete: implemented, tested, documented, and the PR is open and recorded against the job.

---

## Completion report

**Job:** Build the merged capability-addressed git-remote design (`designs/git-remote-capability.md`, PR #41) for `kriscendobot/minion.town` — the smallest coherent end-to-end increment exposing one authenticated guest's content-addressed partition as a real HTTPS smart-Git remote usable by a stock `git` client.

**Outcome:** Opened **draft PR [kriscendobot/minion.town#86](https://github.com/kriscendobot/minion.town/pull/86)** (branch `git-remote-capability-increment-1`, base `main`), recorded against this job by its durable marker.

**The bounded choice.** The parent design is explicit (§ 4/§ 5.2/§ 5.5/OQ 6) that no mature system serves the *smart* git wire from a foreign representation and every server-half git library is foreign to Node. I took the parent's own load-bearing fact — the git wire doesn't constrain storage (§ 5.1) — to its pragmatic Strategy-A conclusion: **reuse `git http-backend`** (the smart-HTTP server that ships with git) fronting **one bare repo per partition**. `upload-pack`/`receive-pack` are byte-exact for a stock client with no FFI/sidecar/pack-port; the CAS-native served view is derived by a pure, idempotent push→manifest projection, so mandate item (2) holds unchanged.

**What landed** — new isolated component `src/endo/git-remote/` (own process, never inside the read-only gateway):
- Capability tokens (≥120-bit, show-once, **hash-only** storage, attenuation as a structured field), partition registry keyed by guest `iss+sub` (isolation boundary), the http-backend CGI runner, the tree→CAS projection, and the authenticated router (authenticate → **confine** → **attenuate** → serve → project on push).
- **31 tests, all green:** capability unit; protocol/auth/error-path over `fetch` (401/403/404 paths, advertisement framing); and a **stock-`git` e2e** — push a directory → assert CAS projection → clone back → incremental fetch → **second guest denied read of the first's partition**.
- `npm run typecheck` and full `npm test` (330 passing) stay green.
- Docs: `designs/git-remote-capability-increment-1.md` (bounded choice + operator/client runbook + every deferred piece); `DEPLOYMENT.md` cross-references it.

**Reconciliation:** #39's projection reused with the trigger changed to an inbound authenticated push; #60/#68 named as the follow-on guest-plumbing path for the MCP mint/adopt surface (this increment does not depend on them).

**Deferred (recorded in the design doc):** in-CAS object DB + SQLite refs, MCP mint/adopt + live pet-store binding, `receive-pack` metering/resource caps, per-partition reclamation/GC, deployment-coherent two-tier caching, and Strategy B / remote-helper / sha256 / multi-instance.

**Follow-ups:** PR #86 is draft pending CI + review (gauntlet/panel). `package-lock.json` was left uncommitted (warm-cache install churn, not part of the change).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr41-git-remote-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 100 tokens (5932690 cached reads)
- Output: 56077 tokens
- Cost: $5.9454
- Wall-clock: 809s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
