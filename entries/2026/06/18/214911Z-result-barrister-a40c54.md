---
ts: 2026-06-18T21:49:11Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/214911Z-result-barrister-a40c54.md
---

# Barrister result: PR #290 first-round panel

**PR**: endojs/endo-but-for-bots#290 `refactor(lal): adopt pi-based harness + memory internals`
**Originating request**: kumavis @-mention 2026-06-18T21:34:15Z requesting "refresh this PR (rebase, review)". Weaver ad3ac8 landed the rebase; this dispatch covers the review.
**Panel kind**: code-panel
**Panel execution**: in-band-fallback (no Agent tool surfaced; each seat's block written sequentially against the per-seat role file)
**Round**: 1 (first panel pass on this PR; prior review history is maintainer-direct and justice re-run on older commits)

## Panel composition

25 of 26 code-panel seats + 2 cross-panel (copyeditor, pedant), per panel-hints on `--base origin/llm-881f550`. Locksmith suppressed (no attenuate/Far/passStyleOf/E()/makeCapTP in diff); benchmarker suppressed (no BENCH.md or benchmark files); spec-keeper suppressed (no Reflect.apply/polyfill patterns). No barrister-side overrides.

## Verdict

**Must-fix-loop: 5 items**

1. **[assessor]** `packages/lal/agent.js:14` — `runAgentRound` is still imported from `@endo/genie`; the genie dependency is in `package.json:43`. The PR inline thread records "Obviated in 8055a33c3" but that SHA is absent from the post-weave branch (only 6 commits since base: `02b4e490a`, `6c6be4ec1`, `6d517a862`, `112388cae`, `8891e8d09`, `2b693dbfd`). Rebase regression or unmerged commit. [rule: skills/rebase-hygiene-audit/SKILL.md]
2. **[assessor]** `packages/lal/agent.js:851-856` — comments describe building PiAgent "in-line rather than via @endo/genie's makePiAgent" but `runAgentRound` is still the genie import. Prose-vs-code drift. [rule: skills/panel-review/SKILL.md § Pitfalls]
3. **[typist]** `packages/lal/agent.js:964,974` — `toAgentTool` declares `executeTool` as `(name: string, args: any) => Promise<any>`. Bare `any` on a dispatch-to-daemon extension point. Narrowing to `Record<string, unknown> => Promise<unknown>` is achievable. [rule: roles/jurors/typist/AGENT.md § Bare Function type on privileged extension points]
4. **[integrator]** PR description describes transcript persistence (`pi-turn-<N>` entries), `agent-round.js`, and `scripted-pi-agent.js` test helper, none of which are in the diff. Description does not match the branch. [rule: skills/pr-formation/SKILL.md]
5. **[changeset-auditor/packager]** Changeset body omits the primary harness migration; `@endo/lal` bump is `patch` but should be `minor` (new external deps, removed `workerEnv.provider` injection, removed `simulator` script). [rule: skills/changeset-discipline/SKILL.md]

**Summary-fix: 5 items**

- typist: `messageNumber` typed `number | bigint` without a runtime narrowing guard before `E(powers).dismiss(messageNumber)`.
- archivist: README:16 describes `listTools / execTool pair handed to makePiAgent` but code builds PiAgent directly.
- integrator: `providers/openai-compatible-messages.js` local `ChatMessage` mirror typedef could import from upstream.
- packager: changeset body (overlaps changeset-auditor must-fix above; the body gap is the summary-fix dimension; the bump level is the must-fix dimension).
- pedant: `README.md:42` "via @endo/genie's adaptor" parenthetical will be stale after genie obviation.

**Follow-up: 1 item**

- saboteur: `resolveModelString` uses `host.includes(...)` not a parsed URL hostname match; crafted `LAL_HOST` like `https://evil.com/openai.com/path` would match the `openai` branch.

**Acknowledge: 25 items** (stylist naming clean; packager commit structure clean; archivist JSDoc thorough; prover smallcaps-footgun.test.js strong; saboteur patterns-validation defense correct; breaker daemon M.interface semantics unchanged; changeset-auditor daemon.package.json correct; curator exports map unchanged for declared exports; migrator workspace deps correct; fast-checker test structure reasonable; pruner README concise; surfacer surface files consistent; gateway tsconfig references correct; warden globalThis access guarded; purist harden discipline clean; wire-watcher JSON.parse guarded; engine-realist no vat durable patterns; copyeditor prose clean; pedant primer/smallcaps.md accurate; corner-prober boundary cases handled; scribe PR thread knowledge captured; releaser changeset under-describes for release notes; integrator Ollama model-build pattern documented)

**Proposed-rule messages to gardener**: 6 proposals queued (see per-juror blocks in review body). Not writing a separate gardener message this round given the must-fix count; will route after the fixer addresses the blockers.

## Submission

`gh pr review 290 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel.md` — submitted 2026-06-18T21:48:44Z. Self-authored PR (kriscendobot is PR author); `--comment` used per self-review fallback; verdict "Must fix before merge" named explicitly in the review body.

`@copilot` reviewer add: fired.

## Next stage

**next: fixer** — 5 must-fix-loop items. The orchestrator should dispatch fixer with the 5 items from this result inlined as the brief. After the fixer's push, the orchestrator dispatches **justice** (not barrister) for the re-run.

Self-improvement: the `resolveModelString` URL-matching gap (uses `host.includes(...)` not parsed hostname) is a recurring class of finding on config-string parsing; the saboteur seat's lens should be updated to specifically check for URL-like strings being matched with includes-on-raw rather than parsed URL hostname. Routing as a proposed-rule to the gardener in the review body.
