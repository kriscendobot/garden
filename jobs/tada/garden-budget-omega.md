Inbox empty. The design is landed on `main2`, the README index is updated, and the grounding question is with the maintainer for jcorbin.

## Completion report — `garden-budget-omega` (Budget 5/5, omega)

**What I did.** Designed the omega task-rank scheme and a staged foreman retirement, grounded in the child-4 finding, and landed it directly on `main2` (as the other four budget children did). Changed **no dispatch behavior**.

**Diligence on the omega gap (the job's first instruction).** Read all 15 `library/sections/unum--*` sections, grepped the whole `journal2` library, fetched the live unum repo overview, and ran a web search. **Confirmed: no omega notation / task-rank / "tree of plans" scheme exists anywhere reachable** — the ingested unum material predates it and the only `omega` hits are econometrics. Per the job's own warning ("a plausible-but-wrong rank is worse than an honest gap"), I did **not** invent a scheme: I posted a grounding question to the maintainer inbox for `jcorbin` (`message-user.sh`) and wrote the interpretation as explicitly provisional, with Stages 4–5 gated behind his answer.

**The design's spine (from child 4).** Human review dominates machine cost ~50–190×, so a rank that optimizes tokens optimizes the wrong quantity. The rank's dominant term is **human-review-blocked work** (worked/surfaced first) — making the maintainer's "including those that require a human review" clause literally true in the sort key. Machine cost appears nowhere in the key.

**The crux for retirement.** `claim-job.sh` selects `todo/` from an id-derived offset and races — gardeners honor **no rank at all**; rank governs dispatch **only** at plan→todo promotion, which is the foreman's job. So the foreman splits: an **undirected, unmetered `claude -p` generative pump** (the half the maintainer objected to, and — per child 2 — the one dispatch input the cost ledger can't see) vs. a **deterministic, no-LLM rank-ordered promoter** (still needed; the only rank-honoring step). Retirement = neuter the pump, extract a standalone `garden-promoter`, add an `omega:` field, order by it, formalize self-promotion on window overrun. The 95 deferred jobs stay as the promoter's pool; `gate: deferred` survives. Noted that stopping the unit needs a sysop `unit` op with maintainer attestation.

**Files changed:** `designs/omega-task-rank-and-foreman-retirement.md` (new, Status: Proposed) and `designs/README.md` (index row). Commit `4bc13ba73d` on `origin/main2`.

**Open follow-ups (also in the design §5):** (1) the omega definition itself — awaiting jcorbin; (2) no live per-job "PR awaiting-review vs merged" signal a promoter could read; (3) whether review-blocked work means *admit more fleet work* or *surface the review frontier to the human*; (4) milestone-awareness after the pump dies; (5) who runs the one-time 95-deep deferred triage; (6) the `hasExtraUsageEnabled` account asymmetry in any capacity policy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-omega.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 296 tokens (1437512 cached reads)
- Output: 21071 tokens
- Cost: $2.1587
- Wall-clock: 354s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
