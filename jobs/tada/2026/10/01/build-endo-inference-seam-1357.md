I built `@endo/inference`, phase 1 of the inference-backends design, and opened it as draft PR **endojs/endo-but-for-bots#1403**. Lint passes in CI; the test legs were still queued or running when I stopped watching, though the package's 41 tests pass locally.

**The PR**
- Head is `build/endo-inference-seam-1357`. The base is pinned to `llm-80054c3`, a snapshot branch I pushed of the current `llm` tip (80054c3453).
- `ensure-pr.sh` found no earlier PR for this job before opening this one.
- The body has a phase-accounting table, a "Differences from the prototype" section, and a related-design marker for #1102 and #1369.
- Three commits: the package itself, `chore: Update yarn.lock`, and a fix that replaced `SECURITY.md` with the standard copy from `packages/skel`. The first CI lint run failed only on that file.

**What the package contains** (`packages/inference/`; it depends on no provider package)
- **Guards (`guards.js`):** the backend, credential-source and usage-sink interfaces, plus all the request, result and record shapes, typed in `src/types.ts`.
  - Every record is closed, so a request can't carry a credential.
  - `promptOrigin` accepts any optional string, so a missing or unknown origin reaches the gate instead of being rejected by the guard.
  - `infer`'s results are checked against the full list of result types.
- **Limit enforcer (`limits.js`):** stops a turn on wall clock, output bytes, turn count or cancellation, and terminates the process exactly once, for whichever cause comes first. A plugin can also end a turn early with `abort(result)`, for example on the first pinned auth-failure event. Also includes a helper that kills a whole process group.
- **Classifier (`classify.js`):** maps a raw provider response to a result type through a table pinned to exact provider versions. An unknown version or unmatched response doesn't classify, so a provider upgrade can't produce a false `needs-auth`. The table is checked on construction and may not produce `ok` or `needs-containment`.
- **The two wrappers:** the prompt-origin gate returns `needs-containment` for anything not labeled `root-authored`, before the wrapped backend runs. The usage recorder writes one record per turn to the deployment's sink, keyed by the credential's `secretId`; the sink adds the run id and cost.
- **Also added:** a README, a changeset, and the generated `tsconfig.composite.json` entries.

**Checks**
- The 41 tests cover the guards, limit enforcer, classifier and both wrappers. I also broke the source on purpose in nine small ways, and each one made at least one test fail.
- Locally, the package type-check and eslint, prettier, the root TypeScript check, the composite declaration build, the SECURITY.md and package-uniformity checks, and the garden pre-push gates all pass.

**Choices a reviewer may question**
- **Follows the merged design, not the #1369 prototype.** The design was revised after the probe, so field names, result types and record fields differ from #1369. I dropped its admission wrapper and its result-guard wrapper. #1369 itself is untouched.
- **`buildMcpServer` must be a remotable function.** That is the only form that passes the request guard, and only `Far` can make one. So two test files carry a `prefer-endo-primitives-exempt` marker. How the CLI backend gets a launchable server out of the projection (#1369's Gap 1) is left to phase 2.
- **No machine-readable phase ledger in the PR body.** The garden's phase-evidence check reports no ordered-design signal for this design. Its strict format would also mark phases 2–6 as open, so the body has a plain accounting table instead.

**Follow-ups**
- Phase 2 (the Claude core and its two backends) is the next child of this orchestration and stacks on #1403.
- The persisted admission ledger belongs to the broker or the interim slot lease, not this package.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-inference-seam-1357.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 212 tokens (18923888 cached reads)
- Output: 79655 tokens
- Cost: $7.3384216
- Wall-clock: 2980s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
