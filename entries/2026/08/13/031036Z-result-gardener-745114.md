---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-13T03:10:37Z
---
---
ts: 2026-08-13T00:00:00Z
kind: result
role: locksmith
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `locksmith` on endojs/endo-but-for-bots PR #977 (diff base `origin/llm-0ac48c5`, head `dad2cf084e`, worktree `scratch/project-wt-ebfb-guest-unconfined-from-tree-6af9e48f`). Test-only diff: one new test in `packages/daemon/test/endo.test.js` pinning the EndoGuest / EndoHost capability boundary.

### locksmith (capability flow and attenuation)

**Verdict:** request-changes

**Findings:**

- `packages/daemon/test/endo.test.js:6249` the tripwire is one-directional. `hostMethods.filter(name => !guestMethods.includes(name))` pins only host-minus-guest, so a method added to `GuestInterface` (or to both interfaces) grants a guest new authority with the test still green. The two surfaces are not nested today: `define` (`packages/daemon/src/interfaces.js:230`) is guest-only, so the difference set already cannot express the guest side. Pin `guestMethods` with its own snapshot, or assert `guestMethods.filter(n => !hostMethods.includes(n))` deep-equals `['define']`. [proposed-rule: a capability-surface pin asserts BOTH directions of the difference, since a one-sided difference cannot observe a grant added to the attenuated side.]

- `packages/daemon/test/endo.test.js:6267` the `@host` probe checks one method name against an object whose interface imposes no method allowlist: `HandleInterface` is `M.interface('EndoHandle', {}, { defaultGuards: 'passable' })` (`packages/daemon/src/interfaces.js:145`), so the handle's surface is exactly its behavior record (`receive`, `open`, `receiveEdit`, `openEdit`, `packages/daemon/src/mail.js:1624`) and any method later added there is exposed and callable with passable args, unguarded. Pin `await E(parentHandle).__getMethodNames__()` to that four-name set instead of negatively probing one host method. One line, and it covers the class rather than the instance. [rule: roles/jurors/locksmith/AGENT.md § Operating norms, unhardened / unguarded exported surface]

- `packages/daemon/test/endo.test.js:6161` the 40-name list is a tripwire whose defeat mode is a contributor regenerating it to green CI. State the reading in the test: a name appearing means the host grew an authority (review it), a name disappearing means a guest gained one (stop). The current assertion message does not say this. [proposed-rule: a snapshot-allowlist assertion carries an inline note on what each direction of failure means, so it cannot be silently regenerated.]

- comment-only. `packages/daemon/test/endo.test.js:6229` the error oracle `{ message: new RegExp(methodName) }` matches any error naming the method, including an interface-guard argument rejection that would fire if the method DID exist. The seven `hostOnlyCalls` are covered by the paired `guestMethods.includes` assertion, and for the `@host` probe the leak path fails loudly today (a real host reaches `stageTreeInternal`, which throws an unknown-name error that does not name the method, `packages/daemon/src/host.js:1591`). So the oracle holds, but matching the "no such method" shape would drop the coupling to message text. [rule: skills/adversarial-tests/SKILL.md]

- comment-only. `packages/daemon/test/endo.test.js:6217` the live-call set skews to the code-execution family; the credential and shell minters (`provideShell`, `provideBearerCredential`, `provideBasicCredential`, `provideGitRemote`) are equal-or-higher authority and are covered only by the name set. Adding `provideShell` plus one credential minter would match the probes to the danger ranking the comment claims. [rule: roles/jurors/locksmith/AGENT.md § Operating norms]

**Notes (out of scope but worth flagging):**

- The test pins the *type* boundary (what `GuestInterface` exposes). It does not pin the *delegation* boundary: a host that resolves a guest's `request`, or stores a host-only cap in the guest's pet store, hands that authority over via `lookup` / `adopt` with no interface guard involved. A companion test belongs on that path. [proposed-rule: a guest/host boundary suite covers delegation (resolve / adopt / lookup) as well as interface shape, since attenuation by type says nothing about attenuation by grant.]

- The diff adds no export, parameter, or call path, so it grants no capability. Verification: I did **not** run the test (this worktree has no `packages/daemon/node_modules`). I derived the host-only set statically from `packages/daemon/src/interfaces.js` (`HostInterface` keys minus `GuestInterface` keys, shared spreads cancelling) and it matches the pinned 40 names exactly, ordering included (`getMethodNames` sorts, `packages/eventual-send/src/local.js:74`).

Self-improvement: the locksmith brief's second recurring finding covers unguarded exported surfaces but not `defaultGuards: 'passable'` specifically, which is the shape that made the `@host` handle finding non-obvious. Worth a line in `roles/jurors/locksmith/AGENT.md`: an `M.interface` with `defaultGuards: 'passable'` is not an allowlist, so its attenuation lives in the behavior record and must be pinned there.
