---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-13T03:52:09Z
---
---
kind: result
role: integrator
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `integrator` on endojs/endo-but-for-bots PR #977 (head `dad2cf084e`, base `origin/llm-0ac48c5`; one commit, `packages/daemon/test/endo.test.js` +100).

### integrator

**Verdict:** request-changes

**Findings:**

- PR body, Testing Considerations: "A temporary, uncommitted short socket directory was used because the isolated **job worktree** path exceeds the Unix-domain socket length limit" leaks garden-internal machinery into the permanent merge-commit body. Same paragraph's "All deterministic pre-push probes passed" is internal vocabulary a maintainer cannot decode. Restate as the socket-path constraint alone, and name the actual checks (lint, types, package tests). [rule: skills/pre-pr-checklist/SKILL.md § No methodology leak]

- PR body, Description and Upgrade Considerations: two sentences point at an unnamed private remediation ("tracked privately and is deliberately not described here"; "The separately confirmed minion.town gateway exposure requires deployment of its private remediation"). A future `git log` reader gets an unfollowable pointer plus a second project's deployment state inside a daemon test PR. Keep at most one sentence, in Security Considerations, that this test pins the correctly-constructed guest and that any deployment-path concern is out of scope; drop the rest. [rule: skills/pr-formation/SKILL.md § Behavior and intent, not diff]

- PR body: no `Closes:` / `Refs:` line, which the template's leading instruction asks of every PR. If no public issue exists, say so in one clause so the omission reads as deliberate. [rule: skills/pr-formation/SKILL.md § Use the upstream template, section for section]

- `packages/daemon/test/endo.test.js:6178`: the new test is inserted between `provideHostPath is an EndoHost-only capability not reachable through an EndoGuest` (6108) and `provideHostPath rejects a spoof that passes the genie shape gate` (6278), splitting the `provideHostPath` cluster. Move it after that cluster, or beside the existing guest-boundary tests at 2983. [proposed-rule: a new test joins the end of the cluster it generalizes, never between two members of an existing cluster]

- `packages/daemon/test/endo.test.js:6178`: this generalized boundary test subsumes territory already held by three existing tests: `guest cannot access host methods` (2983, the `@host` parent-handle probe), `the diagnostics facet is absent on the guest facet` (2993, `diagnostics` is item 5 of the new 40-name list), and the `provideHostPath` seat test (6108). Nothing states the relationship, so the file now carries four partially-overlapping guest-boundary tests and a future reader cannot tell which is canonical. Add one sentence naming the new test as the exhaustive pin and the older three as by-example illustrations. [rule: roles/jurors/integrator/AGENT.md § Minimum cleavage]

- `packages/daemon/test/endo.test.js:6180`: `hostOnlyMethodNames` is an exhaustive pin, so the next EndoHost method added anywhere in the daemon fails this `deepEqual` 6200 lines into the file with no guidance. Give the future reader the one line they need: if the new method is intentionally host-only, add it here; if it belongs on the guest, this failure is the finding. [rule: roles/jurors/integrator/AGENT.md § Merge-commit readability, future-reader slice]

**Notes (out of scope but worth flagging):**

- Test title `host-only capabilities are not reachable through an EndoGuest` uses `host-only` where the sibling directly above uses the project's own type name (`EndoHost-only`). `EndoHost-only capabilities ...` reads coherently with the surrounding cluster. [rule: skills/rename-discipline/SKILL.md, concept-name coherence slice]

- `6236-6244`: the per-method `t.false(guestMethods.includes(methodName))` inside the loop re-asserts what the `deepEqual` at 6229 already pins for all 40 names. Harmless, but it reads as two mechanisms for one claim (overlaps `decomplector`). [proposed-rule: when an exhaustive set assertion already pins a property, per-item re-assertion of the same property is redundant]

- `hostOnlyCalls` samples 7 of the 40 names under the stated "executes Node.js code / prepares that input / mints a privileged host" rationale, yet `provideShell`, `provideWorker`, and `makeChannel` fit the same description and are not sampled. The next reader extending the sample has no rule to follow (overlaps `prover`). [proposed-rule: a sampled subset of an enumerated surface states the selection rule, so the next adopter extends rather than guesses]

The concept naming (`EndoHost` / `EndoGuest`, the reserved `@host` parent handle), the `__getMethodNames__` probe idiom, and the `/** @type {any} */` overstep cast all integrate with existing repo practice. No dependency-graph or diagram surface touched; no changeset needed for a test-only change, as the body states.

Self-improvement: the description leaked "job worktree" and "pre-push probes" while otherwise following the template well, which suggests the leak enters at the Testing Considerations step where an agent transcribes its own verification log verbatim. Worth a line in `skills/pre-pr-checklist/SKILL.md` § No methodology leak naming Testing Considerations as the section where the leak most often lands, with the two phrasings above as examples.
