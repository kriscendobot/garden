All deliverables are complete and verified. Here is my completion report.

---

## Completion report — `pr-completion-receipts-build`

Implemented the PR completion-receipt automation from `designs/pr-completion-receipts.md`. Code landed on **main2** (2 commits: `adfa46f3f6`, `15b83a227a`); 10 example receipts archived on **journal2**.

### What changed (main2, `scripts/`)
1. **Generator — `scripts/jobs/pr-receipt.sh`** (new, deterministic, no `claude -p`). Per-engagement rows (role / harness / model / billable tokens / notional $) from `usage/<base>.jsonl`, calibrated true-cost per base, and the one per-PR maintainer-review-effort (MRE) heuristic (`M = S·a + C·b + L/r`, priced at H $/hr) from three `gh api` human-feedback endpoints with a fixed human-author filter (counts + lengths only — no comment body reaches any model). Size-distills over ~65 KB; three idempotency guards (journal file, comment marker, post-job CAS); fail-open. `--no-post` and `--force` for backfill/regeneration.
2. **Join reuse — `cost-by-pr.sh`**: added `--base-map` (emits the raw base→PR join across **all** states, so the generator reuses the join + true-cost pricing instead of duplicating it, and covers closed-without-merge PRs, not just merged).
3. **Trigger — `receipt-watcher.sh` + `garden-receipt-watcher@.{service,timer}`** (new): leader-only, deterministic per-repo PR-terminal-state producer. Seeds its journal cursor forward on first tick (no historical flood), gates on garden-worked + receipt-exists, posts one `<slug>-pr<N>-receipt` job per completed PR. Injection-safe like ci-watcher; armed on the same `comment-repos/` set via a new `repo-watcher.sh` reconcile line.
4. **`handlers/receipt-pr-source-gh.sh`** (new): bounded newest-first closed-PR source.
5. **`receipt-defaults.sh`** (new): tracked MRE/hourly seeds, journal-config-overridden (rate-card's journal-data-outranks-seed pattern).
6. **PR-comment posting**: via `gh pr comment` (the fleet's identity-pinned wrapper); posts only on the `comment-repos/` set, widening the monitoring surface by nothing.

All scripts pass `shellcheck -S warning` (the CI gate) and `bash -n`.

### Verification (by hand)
Cross-checked `endojs/endo-but-for-bots#719` against raw ledgers: per-engagement tokens (retcon 26+6044+42761 = **48831**; cc0b4130 27+5801+49399 = **55227**) and notional match the usage rows exactly; PR-total calibrated **$1.01** and ceiling **$41.35** match `cost-by-pr.sh --base-map`'s sums; MRE 14·8 + 45·1.5 + 35438/750 = **227 min → $567.50 → 562×** all reproduce. Also spot-checked #259 (calibrated 0.02 == base-map) and merged #705/#1046/#340 (disposition renders correctly).

I found and fixed a real bug during verification: the engagement TSV parse used `IFS=$'\t' read`, and because tab is IFS-whitespace, rows with an empty string field collapsed and shifted every later column. Fixed by emitting a `-` sentinel for empty jq fields (commit `15b83a227a`).

### 10 example receipts (backfilled demonstrations — NOT posted as PR comments)
All archived at `receipts/endojs-endo-but-for-bots/<YYYY>/<MM>/pr<N>.md` on **journal2** (HEAD `62882e18b8`). 5 closed + 5 merged:

| Disposition | PR URL | Receipt archive path |
|---|---|---|
| closed | https://github.com/endojs/endo-but-for-bots/pull/259 | `receipts/endojs-endo-but-for-bots/2026/07/pr259.md` |
| closed | https://github.com/endojs/endo-but-for-bots/pull/503 | `receipts/endojs-endo-but-for-bots/2026/08/pr503.md` |
| closed | https://github.com/endojs/endo-but-for-bots/pull/719 | `receipts/endojs-endo-but-for-bots/2026/08/pr719.md` |
| closed | https://github.com/endojs/endo-but-for-bots/pull/852 | `receipts/endojs-endo-but-for-bots/2026/07/pr852.md` |
| closed | https://github.com/endojs/endo-but-for-bots/pull/1109 | `receipts/endojs-endo-but-for-bots/2026/09/pr1109.md` |
| merged | https://github.com/endojs/endo-but-for-bots/pull/340 | `receipts/endojs-endo-but-for-bots/2026/08/pr340.md` |
| merged | https://github.com/endojs/endo-but-for-bots/pull/705 | `receipts/endojs-endo-but-for-bots/2026/07/pr705.md` |
| merged | https://github.com/endojs/endo-but-for-bots/pull/963 | `receipts/endojs-endo-but-for-bots/2026/08/pr963.md` |
| merged | https://github.com/endojs/endo-but-for-bots/pull/1040 | `receipts/endojs-endo-but-for-bots/2026/08/pr1040.md` |
| merged | https://github.com/endojs/endo-but-for-bots/pull/1046 | `receipts/endojs-endo-but-for-bots/2026/08/pr1046.md` |

These 10 were generated with `--no-post` and are backfilled demonstration examples only — **no live PR comments were posted**.

### Follow-ups / notes
- **Live arming is automatic**: on next deploy, `install-units.sh` renders the new templates and `repo-watcher.sh` arms `garden-receipt-watcher@endojs-endo-but-for-bots` (endo is in `comment-repos/`); its first tick seeds the cursor forward, so only PRs completed *going forward* get live (posted) receipts.
- **Open design questions remain** (maintainer hourly rate, MRE constants, sitting granularity — `designs/pr-completion-receipts.md` § Open questions); all are journal-config-tunable with no deploy.
- The MRE **dominance ratio** can be very large (e.g. #705 = 11719×) when a PR's measured calibrated machine cost is near-zero because its work ran mostly on unmeasured (ceiling) arms — a faithful artifact, not a bug; the ceiling is shown separately as context.
- No automated test was added for the new watcher/generator (siblings have tests); worth a follow-up, though the generator is hand-verified against real data.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr-completion-receipts-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (9453352 cached reads)
- Output: 37191 tokens
- Cost: $7.804500999999999
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
