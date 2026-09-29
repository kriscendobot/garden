## Completion report — endojs-endo-but-for-bots-pr1356-refresh-mentat-20260929

**Resolution: closed #1356 as superseded by upstream endojs/endo#3332.** No gauntlet was warranted for a closed PR, and no refresh was justified — reasoning below.

**Investigation.** The parallel sync job (`endojs-endo-but-for-bots-sync-llm-master-20260929`) is still unclaimed in `todo/`, so I compared against branch state directly. Upstream endojs/endo#3332 (merged 2026-08-21, squash commit `30147f5aa17`) shipped the same design on upstream `master`: the `%InitialURL%`/`%SharedURL%` split, `%URLSearchParamsIteratorPrototype%` sampling in `get-anonymous-intrinsics.js`, the permits, `tame-url-constructor.js`, docs, types, and the missing-`URL` (XS) degradation path. That commit is **already an ancestor of `llm`** (the file arrived at `d745d3fb4b`), so the deliverable exists on both lineages that matter. The fork's `master` (tip `6ee3fda`, 2026-07-22) is a month older than #3332, so #1356's frozen base predates the upstream landing entirely.

**Why close rather than refresh.** Upstream settled every point #1356's description flagged as a judgment call, and settled each one *differently*: the option is `urlBlobTaming: 'retain'|'remove'` (not `urlBlobMethods: 'keepOnInitialGlobal'`), the Node `inspect.custom` symbol is not permitted, and `%InitialURL%` keeps the host blob methods rather than forwarding wrappers. Upstream's test suite (`url.test.js`, 247 lines, plus `url-missing` and `url-blob-remove`) subsumes #1356's coverage except three trivia: a subclassing test, a test that actually invokes `createObjectURL`, and an XS smoke block in `test/_xs.js`. All three are written against the pre-rename API on a stale base, so a "residual diff" would really be a rewrite against upstream's implementation — which isn't even on the fork's `master` yet. If wanted, they're a small fresh upstream PR, not this one. The PR also carried a 2-line `dorny/paths-filter` re-pin any future master-lineage PR will need again; noted in the close comment.

**Actions taken.**
1. Closed https://github.com/endojs/endo-but-for-bots/pull/1356 with a comment naming the subsuming PR/commit, the settled departures, and the residuals (link for the record: the close comment is on the PR thread, 2026-09-29).
2. Flipped the M2 roadmap record `plan/designs/endo-but-for-bots/hardened-url-shim.md` on `journal2` to `status: Complete` with a dated reconciliation note (landed via `land-journal-edit.sh`, CAS-verified). The generated `plan/README.md` M2 row updates on the next bulletin render; `reconcile.sh` leaves terminal statuses untouched.

**Follow-ups (optional, not posted as jobs).** If the maintainer wants the three residual tests upstreamed, that's a small fresh PR against current upstream `master` using the `urlBlobTaming` API. The sibling `hardened-text-codecs-shim` (#1349, same M2 table, same shape) may deserve the same superseded-check against upstream — I did not touch it, as it was out of this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1356-refresh-mentat-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2167997 cached reads)
- Output: 22375 tokens
- Cost: $4.913807
- Wall-clock: 307s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
