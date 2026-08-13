Reviewed all three board discovery reports and corroborated them against fresh repository refs.

- Current `origin/llm`: [`a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- Pull-request head: [`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)
- Feature commit: [`84bfd2303877fdde645a6c0e361837e61d49511b`](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303877fdde645a6c0e361837e61d49511b), confirmed present in the PR head.

Disposition: **2. Partially honored.**

The PR implements the named `main-genie` guard and retained formula in [`setup.js`](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/setup.js#L22-L50). Its integration test exercises direct root-inbox delivery and forces post-restart reincarnation through `lookup('main-genie')` in [`self-boot.test.js`](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/test/boot/self-boot.test.js#L321-L400).

Current `origin/llm` does not retain that Genie boot shape. Genie still provisions `setup-genie`, launches an unguarded `controller-for-genie`, and uses form submission in [`packages/genie/setup.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/setup.js#L81-L136).

Fae now honors most durable semantics more safely:

- Named drivers are checked and their `makeUnconfined` formulas copied into `@pins` in [`packages/fae/agent.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/agent.js#L624-L669).
- Daemon startup eagerly re-provides every pinned formula through `revivePins()` in [`packages/daemon/src/manager.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/daemon/src/manager.js#L3960-L3973), superseding the PR's lazy lookup trigger.
- The revived driver looks up the agent guest and restarts its inbox loop in [`packages/fae/driver.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/driver.js#L17-L49); the guest consumes its own inbox directly in [`packages/fae/agent.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/agent.js#L447-L505).

Exact remaining gap: Fae's top-level setup is not idempotent. [`fae-factory-setup.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/fae-factory-setup.js#L56-L87) guards only the factory guest, then always remakes the factory and recreates `fae`; `createAgent` treats an existing driver as an error rather than a successful no-op. Fae also lacks an agent-level restart test proving that a post-restart inbox message reaches the revived loop. The follow-up should add these guards and that integration test in Fae, while retaining guest-scoped powers. The PR's direct host-root embodiment should not be copied because it exposes the full host pet store and monopolizes the daemon root inbox.

Preserve the experiment history in [`TADA/10`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/10_genie_self.md), [`TADA/11`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/11_genie_self_main_refactor.md), [`TADA/12`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/12_genie_self_setup_launcher.md), [`TADA/13`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/13_genie_self_bottle_narrative.md), and [`TADA/14`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/14_genie_self_tests.md). Retain [`TODO/61`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/61_endo_genie_root_provide_guest_option.md) as the security rationale for guest attenuation. No garden-journal migration is warranted.

Relevant Fae files passed `node --check`. The daemon pin-restart test could not reach its assertion because the isolated worktree's Unix socket path failed with `ENOENT`; the Fae suite could not start because the cached `ava` executable lacked execute permission. No tracked files, commits, branches, pushes, or GitHub state changed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-retained-root-lifecycle.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 402s

<!-- garden-usage-end -->
