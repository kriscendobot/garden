---
handed-off: minion-town-guest-peer-fetch-verify
deliverable-complete: false
---
Everything is confirmed in place. The successor `minion-town-guest-peer-fetch-verify` is durably parked on `origin/journal2`, and the garden worktree is clean. Here is my completion report.

---

## Completion report — `minion-town-guest-self-formula-id-land-verify`

**Landed.** Supervised the code-panel gauntlet on draft `kriscendobot/minion.town#61`. Round 1 returned **must-fix** on two findings; I fixed both in follow-up commit `116dacb` and a re-review of eight security-focused seats confirmed them resolved (saboteur/warden/prover/wire-watcher **approve**, stylist/breaker/archivist **comment-only**):
- **Security (must-fix):** the reveal discloses a bearer capability (guest directory+mailbox+eval), so the endpoint now applies the **same `mcp/guest` admission the MCP surface enforces** (`resolveAccountView` → require `mcp/guest`) before provisioning or identifying — a suspended account gets `403` and the guest service is never touched.
- **Style (must-fix):** DOM ids `guestFormulaId`→`guestFormulaIdentifier` (maintainer `Id`→`Identifier` rule).
- Plus: `Cache-Control: no-store`, whitespace-subject rejection, wrong-gate-token/suspended-caller tests, `DEPLOYMENT.md` docs. Typecheck clean; `npm test` 281 passed / 5 skip-gated. Overrode one non-blocking locksmith `request-changes` (asked to gate the reveal behind a click, which contradicts the maintainer's "see it on the home page" spec) — documented as a tracked follow-up. Un-drafted, approved-equivalent, and **merged** under the delegated proxy-reviewer authority → `main 1e5b163489`.

**Deployed.** CD workflow `33136346517` succeeded; `minion-mcp` restarted, Caddy route + landing page redeployed.

**Verified (reveal half — complete).** Via SSM loopback on box `i-0380cd68b90020fad`: the endpoint returns a signed-in guest's own formula id, **self-scoped** (distinct subjects → distinct ids; `?guest=<other>` returns the caller's own id; `Cache-Control: no-store`; `401` on no subject; external `GET` `302`s to oauth2-proxy sign-in). The landing page carries the read-only field + copy button. Evidence on `kriscendobot/garden#58` (comment 5447765615).

**Peer-fetch half — blocked, handed off.** The revealed guests live in `endo-daemon.service` (loopback `127.0.0.1:8920` only); the public OCapN-CBOR-Noise routes front a *separate* `endo-pet-daemon` container (different graph, node `a6cd6e01…`). A revealed id is therefore not resolvable at the public daemon, so `enlivenSturdyRef` from a peer cannot fetch that guest as deployed. Closing it requires exposing the guest-substrate daemon over public OCapN (or unifying onto the pet-daemon) — an infra + **security-posture decision** my delegation excludes.

**Actions taken for the residual:** posed the one clear question to the maintainer on `kriscendobot/garden#58` and via the liaison inbox; coordinated with the standing `ocapn-cbor-noise-press`; and durably parked successor **`minion-town-guest-peer-fetch-verify`** (deferred, carries the issue note) that owns the end-to-end peer fetch once the maintainer answers.

**Follow-ups surfaced:** (1) `ACCOUNT_GATE_SHARED_SECRET` is unset on the box (pre-existing; external traffic still oauth2-proxy-gated) — worth provisioning now that a capability is disclosed; (2) the skip-gated `endo-daemon-integration` test's `/^[0-9a-f]{64}$/` regex is too strict for the real daemon's `<hex>:<hex>` designator.

The land + deploy + reveal-verification are complete; the required peer-fetch verification is unfinished and owned by the posted successor.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-self-formula-id-land-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 268 tokens (21454770 cached reads)
- Output: 118291 tokens
- Cost: $16.110175999999992
- Wall-clock: 2297s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
