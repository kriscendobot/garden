# Proxy-review verdict — minion.town weblet-publish critical path (kriscendobot/minion.town#31 + kriscendobot/minion.town#27)

**Verdict: PASS with one deployment gap flagged for the landing children. No unresolved blocking code defect; `orchestration-failed` is NOT warranted.** This is a proxy technical review, not a GitHub maintainer approval and not authority to merge.

## What I verified (isolated project worktree, local runs)

**Heads and dependency relationship.** kriscendobot/minion.town#31 (B4 guest facet tools, head `c952d01`) sits on the current `main` tip (`6368346`); kriscendobot/minion.town#27 (weblet publish, head `8b514e5`) is a single commit off a pre-B3-merge `main` (`0bdfc2c`). They are **siblings, not a stack** — each merges cleanly with `main` alone, but they conflict with each other in `src/endo/guest-tools.ts`, `src/http.ts`, `src/server.ts` (verified with `git merge-tree`). Both PRs' CI is green.

**PR 31.** Its net diff is **hunk-identical to the approved PR-19 head `6450457`** (I fetched that commit and diffed patch-against-patch; the only delta is DEPLOYMENT.md's base-blob context drift from the B3 merge, which applies cleanly). Locally: typecheck clean, 196 passed / 3 skipped — exactly as the PR claims. No blocker; the re-review ask is purely GitHub's inability to reopen the force-pushed PR 19.

**PR 27 code review.** The capability-security shape is right: the publish facet is owner-bound at the single grant site (`guest-control.ts`), tools never accept an owner argument; charge is drawn **before** interning so an unfunded caller interns nothing; reserved-prefix rejection happens on the normalized path; the fs store guards ids against path escape and fails closed on malformed records. **OAuth-scope**: the weblet tools ride the existing `mcp/guest` admission (`authorizeGuest`) — no new scope, consistent with the design and B4's capability-not-scope stance. Locally: typecheck clean, 209 passed / 3 skipped, including the end-to-end gateway-serves-published-content test.

**Rebase + cross-merge evidence** (kriskowal requested "rebase and run a gauntlet" on PR 27 at 17:49Z today):
- PR 27 rebased onto current `main`: clean merge, typecheck clean, 209 pass.
- PR 27 + PR 31 combined: three conflicts, all compositional unions; **one real reconciliation** — B4 makes `GuestToolDeps.grants` required, so PR 27's `test/endo-weblet-tools.test.ts` must pass `grants: { evaluator: false }`. With that one-liner the combined tree typechecks clean and passes **214 / 3 skipped** (I performed the merge and ran it).

## The one gap (deployment, not code)

PR 27 **documents but does not implement** production write access: `deploy/aws/systemd/minion-mcp.service` sets no `GATEWAY_STORE_DIR`/`MINION_TOWN_DOMAIN`, and has `ProtectSystem=strict` with no `ReadWritePaths`/group grant for `/var/lib/endo-gateway/store`, which `deploy-endo-gateway.sh` chowns `endo-gateway:endo-gateway` mode 0755. In production the `weblet_*` tools therefore never mount, and would fail on write even if the env were set. Fail-safe (nothing breaks on merge), but Increment-4's own edge-verification DoD cannot pass until fixed. Fix shape (unit: two `Environment=` lines + `SupplementaryGroups=endo-gateway` + `ReadWritePaths=`; script: setgid group-writable store) is small and should land **after** the rebase (an edit now would manufacture conflicts with B4's unit changes).

## Reconciliation with in-flight work

Peer job `kriscendobot-minion.town-pr27-review-615e16eb` (claimed, same host) owns the maintainer's rebase+gauntlet directive on PR 27, so I pushed **no** commits to avoid clobbering its force-push window (branch still at `8b514e5` when I finished). I sent it the full evidence pack by inbox (delivered `20260809T182916Z-4d7251`): the clean-rebase proof, the land-31-first sequencing, the exact conflict resolutions + the `grants` one-liner, the deployment-gap fix spec, and a grounded answer to kriskowal's inline question at `publish.ts:117` — the reserved prefixes are **same-origin** protection, not cross-weblet: the gateway terminates `/.well-known/*` (powers plane) and `/gateway/*` (control) on every weblet origin, so publisher content there would shadow or spoof the gateway's own endpoints; publish-time rejection makes that a clean caller error.

## Recommended landing order

1. Land kriscendobot/minion.town#31 (approved-lineage diff, on current main, zero conflicts).
2. Rebase kriscendobot/minion.town#27 onto main-with-B4 using the resolutions above (+ the `grants` test one-liner), run the gauntlet per the maintainer's review.
3. Add the minion-mcp unit + store-permission commit on PR 27 (or an immediate follow-up) so Increment-4 edge verification can actually run.

Minor non-blockers recorded for posterity: first-publish ownership race is last-writer-wins under concurrency (read-then-register TOCTOU); vhost JSON writes are non-atomic (torn reads fail closed → transient miss); tool-layer base64 decode silently tolerates invalid input.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-publish-fable-review-20260809.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3253539 cached reads)
- Output: 35026 tokens
- Cost: $7.132545999999999
- Wall-clock: 562s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
