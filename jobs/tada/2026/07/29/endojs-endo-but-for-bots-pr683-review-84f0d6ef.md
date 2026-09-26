## Report

**Review:** [endojs/endo-but-for-bots#683, review 4802903254](https://github.com/endojs/endo-but-for-bots/pull/683#pullrequestreview-4802903254) by @kriskowal — empty body, exactly one inline comment: **"Authorized."** on `packages/ocapn-noise/demo/DEMO-REPORT.md` L140–146, the option-(a) line ("drive M3–M5 from the leader host… touches the live production host — Caddy config, possibly the security group"). That was the whole unit of work.

**Preflight said PROCEED, but the substantive ask was already resolved.** A peer (dispatch 23, 01:32Z) had replied on the thread ([r3670330324](https://github.com/endojs/endo-but-for-bots/pull/683#discussion_r3670330324)) having executed the authorization: SG ingress `tcp/8929` opened, TCP+CBOR listener deployed on minion.town, cross-host Noise IK capability round-trip proven, artifacts on #693 (`803ef977f`). I corroborated each of those before treating them as done.

### What I did

1. **Fixed the preflight's blind spot** (garden, on `main2` as `10c9dce4e4`). A *review*-keyed feedback job carries its asks in inline comments, and a peer's reply threads to the **inline comment id**, never the review id — so `in_reply_to_id == cid` could never match for that entire class of job, which is why a second gardener got dispatched onto resolved feedback. The evidence document now carries each comment's `pull_request_review_id`, and the gate recognises the review's own threads — but only when **every** one has a post-review reply, since the unit of work is the whole review. Two new fixtures; suite 26/26. Re-run against the live case now correctly exits 2.

2. **Closed the residual on the PR itself.** The report still read *"Options to proceed (need a decision)"* — the question the maintainer had answered was still posed as open. `DEMO-REPORT.md` now keeps the blockers as the record of what stood in the way and adds a **Decision and outcome** section: option (a), the authorization, and what it proved (M3/M4 over `wss://minion.town/ocapn` #684; M5 invite/accept over both `ocapn+noise+{tcp,ws}` and cross-host #688/#693; raw TCP+CBOR cross-host once `tcp/8929` opened #693). Replied on the review thread ([r3670931085](https://github.com/endojs/endo-but-for-bots/pull/683#discussion_r3670931085)).

3. **Repaired lint rot the push exposed.** #683's green rollup was **stale since 2026-07-11** — no run in 18 days — and the `pull_request` merge against current `llm` failed `lint` with four parse errors on `demo/*.mjs` (llm's flat ESLint config lints `.mjs` under the type-aware project service). Rebased onto `llm` `bfc91f558` (zero conflicts) and ignored `packages/ocapn-noise/demo/` in `eslint.config.js`, the same treatment `packages/daemon/{demo,deploy}` got on #684. Also corrected the now-false claim in the PR body about the demo files being outside the ESLint glob.

**Verification at new head `a1abe571f`:** eslint 0 errors, `prettier --check .github packages` clean, `scripts/shellcheck.sh` clean, ocapn-noise tests 13/13, `demo/run-all.sh` 4/4 PASS (both transports), and **CI 25/25 green**. Evidence comment: [issuecomment-5113332094](https://github.com/endojs/endo-but-for-bots/pull/683#issuecomment-5113332094).

### Follow-ups

- **A "green" rollup can be an 18-day-old run.** The press's steady-state polls read check *state* without the run *date*, so #683 read green while its merge result was red. Worth teaching the press (or `pr-ci-watch`) to compare the last run's date against the base branch's movement. The rest of the stack is recent enough not to be at risk right now (#340 07-26, #684/#688 07-27, #693 07-29), but the same trap applies to any long-lived PR.
- #683 stays **draft** deliberately (per its own body: demo, not intended to ferry).
- Memory `ocapn-over-noise-goal` updated with the report change, the new head, and the stale-CI lesson.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr683-review-84f0d6ef.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (7467978 cached reads)
- Output: 35058 tokens
- Cost: $5.781396000000001
- Wall-clock: 1694s

<!-- garden-usage-end -->
