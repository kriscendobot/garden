# Feeding the bid-auction cost model — local inference is very cheap, not free

How to price a `provider: local` arm in the reputation/bid model: the derivation
of an honest amortized cost for this host (~$1–2 per million output tokens, from
box amortization plus power — roughly 1–2 orders of magnitude below the cheapest
paid arm), why it must be priced **very cheap and not literally $0** (or a lucky
local success looks infinitely efficient and starves paid-arm exploration), and
the bidding posture that follows (bid aggressively on low-risk `doc`/`triage`/
small-`fix` work, not on high-stakes `build`/`design`). Read this to seed or
tune the local rate-card row. The worker wiring this prices is
[worker-backend.md](worker-backend.md); the throughput numbers behind the
per-token math are [model-selection.md](model-selection.md).

The reputation/bid model values every arm in **aggregate dollars = agentic $ +
human-review $** (design §4.4). For a paid API, agentic $ = Σ tokens × rate
card. For **local inference the marginal dollar cost is near zero** (no
per-token price — only electricity and amortized hardware). The design's dollar
axis must price a local arm as **very cheap, not literally $0**, or a single
lucky local success would look infinitely efficient and starve exploration of
the paid arms it should still be measured against.

**Honest tokens/$ for this host (amortized hardware + power).** Illustrative,
to seed a `provider: local` rate-card row — replace with the real purchase price
and local kWh rate:

- **Power:** Strix Halo APU under sustained inference draws on the order of
  ~100–140 W (whole-box; UNVERIFIED — measure with `amd-smi`/wall meter). Take
  **120 W**. At generation throughput ~50 tok/s (gpt-oss-120b) that is
  120 W / 50 tok/s = **2.4 W·s per token** = 0.000667 Wh/token. At even
  $0.30/kWh, power ≈ **$0.0000002/token → ~$0.20 per million tokens.**
- **Amortized hardware:** a ~$2,000 box over a 3-year useful life at ~30% duty
  ≈ 2,000 / (3 × 365 × 24 × 0.30 h) ≈ **$0.25/hr**. At ~50 tok/s that is
  0.25 / (50 × 3600) ≈ $0.0000014/token → **~$1.40 per million tokens.** (The
  amortization dominates; power is a rounding error.)
- **Combined ≈ $1–2 per million output tokens**, versus paid API rates of
  **$5–50 per million** (Opus $25/MTok out, per the design's rate card §4.4).

So a local arm's agentic-$ rate is roughly **1–2 orders of magnitude cheaper
per token** than the cheapest paid arm — cheap enough that on the reputation
axis (aggregate-$-to-merge-worthy) it wins decisively **whenever its acceptance
rate is comparable**. Concretely, for the rate card:

- Add a `reputation/rate-card.md` row `provider: local` with
  `price_basis: amortized`, e.g. **`$1.50 / MTok` flat** (input and output —
  local has no in/out asymmetry), dated, with the box price + kWh rate recorded
  as the derivation so it can be re-run.
- **Bidding posture:** a local worker should **bid aggressively on low-risk
  work-classes** — `doc`, `triage`, small `fix:s`, mechanical `ops` — where a
  20B/120B open model's quality is adequate and the near-zero agentic cost makes
  its aggregate-$ unbeatable even after amortizing a lower acceptance rate. It
  should **not** low-ball high-stakes `build`/`design` on `master`, where a
  weaker model's re-work and heavier human review inflate the *aggregate*
  dollar (agentic cheapness is swamped by human-$ at $125/hr) — the auction's
  merge-worthiness-per-dollar objective handles this automatically once the arm
  accrues real acceptance data. Seed it wide (design §4.6) so the auction
  explores it, and let the human-$ term keep it honest on hard targets.
