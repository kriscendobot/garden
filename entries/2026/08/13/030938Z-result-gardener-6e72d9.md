---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-13T03:09:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Panel seat `prover` on PR #977 (`test(daemon): pin guest host-authority boundary`), diff base `origin/llm-0ac48c5`, head `dad2cf084e`, worktree `scratch/project-wt-ebfb-guest-unconfined-from-tree-6af9e48f`. Test-only diff: one new test, 100 lines, in `packages/daemon/test/endo.test.js`.

### prover (regression evidence)

**Verdict:** request-changes

**Findings:**

- `packages/daemon/test/endo.test.js:6260` (`t.throwsAsync(call, { message: new RegExp(methodName) })`): the matcher is satisfied by errors other than the boundary refusal it claims to prove. The eventual-send refusal text is ``target has no method "X", has [...]`` (`packages/eventual-send/src/local.js:114`), but an exo interface-guard rejection reads ``In "makeUnconfined" method of (EndoGuest): ...`` (`packages/exo/src/exo-tools.js:444`), and a guest-side stub that rejects with its own method name would also match. So if `makeUnconfined` became reachable on the guest with a tighter guard, or as a method that throws naming itself, this probe still passes. The seven probes are what the PR body advertises as proving "refusal does not depend on callers obeying the static `EndoGuest` type", so they should pin the refusal: use ``new RegExp(`target has no method "${methodName}"`)``. Only the `t.deepEqual` at :6249 currently carries that weight. Must-fix scope is small. [rule: skills/regression-evidence/SKILL.md]

- `packages/daemon/test/endo.test.js:6231` (`hostOnlyCalls`): a typo'd or renamed key silently degrades both of its assertions to no-ops. `t.false(guestMethods.includes('mispelled'))` and `t.throwsAsync(...)` both pass trivially for a name no surface has. Add `t.true(hostOnlyMethodNames.includes(methodName), ...)` inside the loop at :6256 so the probe set cannot drift off the surface it is probing. [rule: skills/regression-evidence/SKILL.md]

- PR body regression note: the break (adding `makeUnconfinedFromTree` to `GuestInterface` and the guest exo) exercises only the `:6249` deepEqual. The `@host` handle assertion at :6267 to :6276 was not exercised by any break. Run a second break, resolving `@host` to the parent `EndoHost` facet rather than a mail handle, and cite that the last assertion reddens; otherwise that block is unproven. [rule: skills/regression-evidence/SKILL.md § Procedure]

- `packages/daemon/test/endo.test.js:6267`: the handle probe checks one name out of the forty. `t.deepEqual(hostOnlyMethodNames.filter(n => handleMethods.includes(n)), [])` would pin the whole surface for the same cost. [rule: skills/regression-evidence/SKILL.md]

Verified independently: the forty-name `hostOnlyMethodNames` list matches the static `HostInterface` minus `GuestInterface` guard-key difference in `packages/daemon/src/interfaces.js` exactly, and `getMethodNames` sorts (`packages/eventual-send/src/local.js:73`), so the ordered `t.deepEqual` is stable. The probe arguments all satisfy their host-side guards, so a reachable method would run rather than bounce off a shape check. That craft is right.

**Notes (out of scope but worth flagging):**

- The PR body states the motivating escape is an integration path outside this facet, so nothing here would catch it. Worth a follow-up ledger item so the escape gets its own load-bearing test when the private remediation lands. [rule: skills/regression-evidence/SKILL.md § Pitfalls]

Self-improvement: nothing this time.
