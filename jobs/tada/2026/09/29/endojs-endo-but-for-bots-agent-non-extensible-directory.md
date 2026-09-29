I added a `nonExtensibleDirectory` option to `provideGuest` and `provideHost`, and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1378. The branch is `agent-non-extensible-directory` on endojs, based on the frozen `llm-1706e63` (the current `llm` tip). The new tests and all local checks pass; CI has not run yet.

**What the agent can and can't do.** An agent created with the option can still look up, rebind and remove the names it already has. Adding a name fails with `TypeError: Cannot add pet name "x": this agent's directory is non-extensible`, and so does renaming onto a new name. Only the agent's own directory is locked; directories it holds, such as `@pins`, stay writable. This is the same rule as JavaScript's `Object.preventExtensions`.

**How it's built:**
- **Option:** `MakeAgentOptions` has a new `nonExtensibleDirectory?: boolean`. A value that isn't a boolean is rejected before anything is written.
- **Persistence:** the guest and host formulas record `nonExtensibleDirectory: true` only when the option is set, so existing formulas are unchanged. The flag survives a daemon restart, and `getFormula` reports it.
- **Enforcement:** a new wrapper, `makeNonExtensibleStore` in `pet-sitter.js`, sits around the agent's pet store when the agent starts up (`guest.js`/`host.js`). All of the agent's own write paths go through that store.
- **Host-provided names:** names the host gives the agent at creation (`introducedNames`) are written directly into the underlying store. Without that, creating a locked agent that starts with some names would fail. Agents without the option keep the old path.
- **Changeset:** `@endo/daemon` minor.

**Testing:**
- 8 new daemon tests (4 each for guest and host) in `test/endo.test.js`. They cover refusing new names, refusing a rename onto a new name, rebind and remove, re-adding a removed name, `@pins` staying writable, the default staying open, rejecting a non-boolean value, and persistence across restart.
- The full `endo.test.js` plus `formula-record.test.js` run: 282 passed, 0 failed.
- eslint reports 0 errors, prettier is clean, and both the daemon `tsc` and the repo-root `tsc` (checkJs) are clean. The root `tsc` ran out of memory at the default heap size; it passed with `--max-old-space-size=8192`.

**Decisions for you.** The job asked me to confirm the name and scope with you if they were ambiguous. Since this session can't wait for a reply, I made these calls, listed them in the PR body and sent you a non-blocking note:
1. **Name:** I used `nonExtensibleDirectory`. `sealDirectory` would suggest `Object.seal`, which also blocks removals.
2. **Scope:** the option is on both hosts and guests, like `pins` and `networks`. It could be made guest-only.
3. **Host adding names later:** if a host calls `provideGuest` again on an existing locked agent with new `introducedNames`, the names are still added. The lock only stops the agent itself.
4. **Removals:** these are allowed. If you'd rather the agent be unable to remove names either, that's a small change.

**Not included:** a CLI flag (`endo mkguest --non-extensible`). It would be a small follow-up if you want it. The review chain (clean → panel review → fix loop → un-draft) should be staged automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-agent-non-extensible-directory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4726839 cached reads)
- Output: 29272 tokens
- Cost: $2.4802638000000004
- Wall-clock: 1141s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
