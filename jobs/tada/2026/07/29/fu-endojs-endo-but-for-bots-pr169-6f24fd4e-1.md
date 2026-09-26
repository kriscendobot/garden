Inbox is empty. Work is complete.

## Completion report

**Job:** recount `designs/README.md` in `endojs/endo-but-for-bots` (`llm`).

**What I found.** The stated total had already moved from the job's `149` to `150` (PR #169's `pass-style-promise` rebase bumped it), but the Summary table has **160** status rows — so the prose was short by 10, not 8.

**The tally.** Bucketing each row on the leading word of its Status cell:

| Bucket | Was | Now |
|---|---|---|
| Complete/Implemented | 42 | 44 |
| In Progress | 23 | 26 |
| Not Started | 39 | 40 |
| Proposed | 32 | 35 |
| Active / Reference / Deprecated | 2 / 7 / 2 | unchanged |
| Superseded | 3 | 4 |
| **Total** | **150** | **160** |

One judgement call: `cbor-codec` ("Phase 1 implemented (PR #755); phases 2-3 proposed") is the only row not leading with a bucket name; counted **In Progress**. Verified alongside: `^| [` matches exactly the 160 Summary rows and nothing else in the file, every row resolves to an existing design file, and no design appears twice.

**What changed** (`designs/README.md` only, 1 file):
- Rewrote the "Current totals" paragraph with the recounted numbers and the per-bucket deltas.
- Inlined the awk one-liner that reproduces the tally, so the next pass can re-derive rather than apply a `+1` delta to prose — which is how this drifted.
- Relabelled the older `**Totals:**` paragraph as historical. It sat directly above a second, differently-numbered "current" paragraph; two current-looking totals in sequence is what invited the delta habit.

**Drift provenance** (in the PR body, as asked). Reconstructed from git history: **2026-05-15 was the last revision where stated matched the table** (118/118). Every pass since has understated it by a growing margin — 153/148 on 07-18, 155/148 on 07-22, 157/149 on 07-24, 159/149 on 07-28. The 2026-06-19 and 2026-07-10 passes noticed and partly corrected it, which is why the gap dips and reopens. It is not attributable to any branch now in flight.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/887 — open, non-draft, base `llm`, one file. Rebased onto current `origin/llm` (`bfc91f558`) and the tally re-verified after the rebase; the 19 intervening commits did not touch the table.

**Follow-ups I deliberately left out of scope, both flagged in the PR body:**
1. The table is **not exhaustive of `designs/`** — 178 `*.md` files exist there (excluding `README.md`), and 15 genuine-looking designs have no Summary row (`captp-error-identification`, `http-confine`, `notifier-pubsub-migration`, `platform-neutral-hash`, `worker-rust-xs`, and 10 more). Deciding which belong is editorial work, not a recount. The doc now states this gap explicitly.
2. `#### Summary by Milestone` carries its own item counts and a "Total remaining" row. Those are a remaining-effort projection, not a status tally, and reconciling them is separate work.

No garden-library (`main2`) changes were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr169-6f24fd4e-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 25 tokens (1216971 cached reads)
- Output: 6790 tokens
- Cost: $1.6905804999999998
- Wall-clock: 113s

<!-- garden-usage-end -->
