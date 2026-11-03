I applied fix round 1 for kriscendobot/minion.town PR #234, pushed it, and CI came back green (`ci-wait-merge` rc 0; 7 checks, 0 failed). I declined one must-fix item and left four should-fix/comment-only items for later. The panel review this round answered was 5757823555. There was no pre-pass block.

**Pushed commit `0b1d8538`** (head moved 42712293 → 0b1d8538 via `safe-push-pr-head.sh`):
- **prover 1 (should-fix):** removed `attachCoupon: false` and its comment from the probe's mint request in `deploy/probe/prod-objectives.mjs`. The server's local mint never reads that field and never attaches a coupon, so the claim had nothing behind it.
- **pruner 1–5 (editorial):** each rationale is now stated once.
  - The changeset no longer mentions the probe.
  - Two restated comments are cut from `src/web/guest-web-router.ts`.
  - The Caddy comment now just points at the route admission manifest instead of listing the routes.
  - The two repeated sentences are cut from `DEPLOYMENT.md`.

**decomplector 2 (must-fix):** I added a paragraph to the PR body on why the PR adds new guest routes instead of using throwaway guests:
- After the coupon flip, `POST /api/guest` refuses anonymous callers.
- A new pair of guests on every run would grow the guest set.
- An operator-side reset would need a daemon admin path the app doesn't have.

**decomplector 1 (must-fix), declined:** the juror said `stillHolds` alone covers replays, so `retire` could go. It doesn't. `stillHolds` only checks that the name exists, so it can't tell when a forgotten name has been reused for a different peer. When I removed just the `invitations.retire` call, the "name is rebound to another peer" test failed (`expected 200 to be 404`). Each mechanism covers a case the other misses, so both stay. The reasoning is in PR comment https://github.com/kriscendobot/minion.town/pull/234#issuecomment-6612825724.

**Not done:** decomplector 3–5 and prover 2–3 (all should-fix or comment-only). Decomplector 4 asks for the daemon's `dismissAll` to be idempotent, and that change belongs in endo, not this repo.

**Local checks:** vitest on `test/web`, `deploy/probe` and the Caddy tests passed (170 passed, 5 skipped), and `tsc --noEmit` is clean.

**Follow-up:** panel-2 should look at the decomplector 1 rebuttal and either accept it or escalate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-42712293-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1434688 cached reads)
- Output: 9117 tokens
- Cost: $1.0581576000000001
- Wall-clock: 473s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
