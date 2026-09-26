Completed the review directive on kriscendobot/minion.town PR #42 in full. This was a maintainer (`kriskowal`) `CHANGES_REQUESTED` review on the design doc `designs/weblet-usage-metering.md`, whose 9 inline comments are decisions on the doc's § 10 open questions, plus a top-level directive to respond locally, file upstream endo-but-for-bots issues, and cover the Minion Town AWS-platform dependency.

**Local response (pushed):** `design/weblet-usage-metering` head is now `e400f6e` (one commit, doc-only, +142/−62). Rewrote § 10 from open questions into decided policy and threaded the load-bearing mechanism changes into §§ 1/3/4/8:
- storage = one-time indefinite-retention **principal** (not rent) with a user-invited delete-for-rebate path;
- monthly credit grant + optional rate-limit attenuation;
- consistency-over-availability settlement — HTTP pessimal-case refusal + bytes-and-wall-clock billing, WS per-message-both-directions draw/terminate, per-delivery computron ceiling that panics the vat;
- retain-forever default; unidirectional Stripe→credits with manual (non-credit) refunds and lose-track-over-mint bias;
- adopt the daemon AWS storage platform; no automatic storage rebate.

**Upstream issues on endojs/endo-but-for-bots** (standing "post freely" authorization): filed #982 (guest `@main`/special-worker-name override), #983 (live reference retention root so agent methods accept any formula-backed reference), #984 (durable-ledger worker type + incremental heap + DB-write metering). Opened #985 (storage-backend seam) then **closed it as already covered** after finding the seam + S3/DynamoDB engines already designed/scaffolded in **#637** (`endo-daemon-aws-storage.md`).

**AWS-platform dependent design:** reconciled against existing state rather than duplicating — the "AWS platform for the daemon (S3 CAS + DynamoDB DB)" is already an in-flight upstream workstream (#637 + its phased build/deploy jobs, incl. the parked `deploy-endo-daemon-aws-storage-reference`), so I linked it from §§ 8/10; Minion Town's remaining piece is downstream *adoption* build work, not a new design. No new job posted.

**PR communication:** posted inline replies on all 9 review threads mapping each decision to where it now lives, a top-level summary comment (`#issuecomment-5289871607`), and re-requested `kriskowal`'s review.

**Verification:** design-only doc — no runtime code or tests. Markdown reviewed for internal-reference coherence (no stale § 10 pointers, mermaid unchanged); not execution-verified beyond that (honestly stated in the PR summary).

**Follow-ups (owned by named artifacts, not dropped):** endo-but-for-bots #982/#983/#984 track the upstream Endo work; #637 tracks the AWS storage platform; Minion Town adoption of that platform + the resource-ledger build remain the design's own § 8 build sequence.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr42-review-d0ab99cd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 85 tokens (3632527 cached reads)
- Output: 41925 tokens
- Cost: $3.862503499999999
- Wall-clock: 668s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
