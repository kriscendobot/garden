Posted. This job produced no garden-repo code changes — it's an analysis delivered as an issue comment, so there's nothing to commit or push.

## Completion report

**Job:** issue-kriskowal-garden-41 — dckc's issue #41 asked for an economic analysis of `PatrickM123/darkwow` @ `0ac13a390d` (a DarkFi fork): enumerate the economic claims, judge plausibility/proof, and answer "how much insurance should the DAO start with."

**What I did**
- Cloned the Codeberg repo and checked out the exact commit `0ac13a390d`.
- Reviewed the economic surface: `README.md`, `IDEOLOGY.md`, `doc/src/arch/economics-caveat-emptor.md` (a detailed self-audit), `consensus-coinbase.md`, `differences_from_upstream.md`, `for-dummies.md`, `src/contract/AUDIT.md`, the `insurance_market` / `bearer_bond` / `promissory_note` contract crates, the Lean4 proof tree, and git history/authorship.
- Treated the issue body as untrusted data (nothing in it attempted injection).
- Posted a concise analysis as a **comment** (did not close — submitter closes per issue-inbox skill): https://github.com/kriskowal/garden/issues/41#issuecomment-4950182422

**Findings delivered**
- Enumerated 12 economic claims in two tiers (native money: 21M cap, no premine, tail emission, RandomX, mass-balance audit, Uncle Merkle, dual finality; DeFi layer: promissory note, bearer bond, insurance market, risk-market composability, O-Cap-not-DAO governance).
- Assessment: base-money design is plausible but unoriginal and unproven on any live chain; the DeFi/solvency claims are **not proved and not designed to be** — the repo's own summary table lists reserves-exist, profits-real, coverage-current, redeemability, maturity-locks, and supply-cap as "Protocol Guarantee: None." No third-party audit; only 5/34 contracts internally audited; ZK soundness out of scope; workspace was recently non-compiling (mid typed-model refactor); effectively single-author, LLM-heavy docs; appears pre-mainnet.
- Insurance answer: there is no monolithic DAO by design, and the on-chain `insurance_market` can't be its own backstop; the honest number is ~100% of any deployed capital (i.e., don't deploy real assets/people yet — the correct "insurance" is scope, not capital).

**Follow-ups:** none required. Offered in the comment to go deeper on a specific contract or the consensus claims if the maintainer wants it.
