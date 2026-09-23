## Completion Report — endojs-endo-but-for-bots-pr778-erights-review-response

**What I did:**

- Fetched the erights review on PR #778 (`pullrequestreview-4815423848`). Body identified five Agoric SDK PRs; zero inline comments confirmed.
- Read-only inspected all five Agoric SDK PRs (#8982, #11235, #10504, #6769, #10952) — no interaction with agoric/agoric-sdk upstream.
- Determined each PR's technical relationship to the `@endo/ertp` design:
  - **#11235/#10952** (want-patterns ERTP+Zoe): directly deferred to Phase 4 in the design
  - **#6769** (AmountMath ↔ Key alignment): confirms Design Decision #1 (delegation to `@endo/patterns`)
  - **#8982** (revoke used-up payments): useful hardening, now noted as a Phase-1 requirement
  - **#10504** (mock orch ERTP): no direct relationship

**What changed:**

- **Comment posted:** `https://github.com/endojs/endo-but-for-bots/pull/778#issuecomment-5136841043`
- **Commit pushed:** `1e0dca467b` to `design/endo-ertp-migration` — adds two notes to `designs/endo-ertp-migration.md`:
  - Phase 1: carry forward revocable-payment-on-use hardening
  - Phase 4: acknowledge existing want-patterns implementation as baseline code

**Follow-ups:** None required. The response answers the review and the code change is the stated local action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr778-erights-review-response.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 340s

<!-- garden-usage-end -->
