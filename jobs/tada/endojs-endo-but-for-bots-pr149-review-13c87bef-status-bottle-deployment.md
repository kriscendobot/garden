Disposition: 5 — migrate only the durable prompt/history into the garden journal.

Freshly fetched state:

- `origin/llm`: [`a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- Pull-request head: [`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)
- The histories have no merge base.

I read all three discovery reports from freshly fetched `origin/journal2` and corroborated their relevant findings against both refs. The pull request implements a useful Phase-0 prototype in [`bottle.sh`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bottle.sh): XDG-persistent workspace selection, `invoke`/`evoke`, daemon start and ping polling, transport setup, Genie bootstrap, and host-level owner invitation. [`bootstrap.sh`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bootstrap.sh) installs dependencies, builds, and links the CLI into `~/.local/bin`.

Current `origin/llm` contains neither script, as shown by the current [`packages/genie` tree](https://github.com/endojs/endo-but-for-bots/tree/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie). It retains only underlying primitives such as [`endo start` and `endo run-daemon`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/cli/src/endo.js#L879-L905), the existing [Genie setup flow](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/setup.js), and newer transport launchers for [Iroh](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/daemon/src/networks/setup-iroh.js) and [TCP](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/daemon/src/networks/setup-tcp.js). The prototype's libp2p launcher is already stale relative to those interfaces.

Exact unfinished or inconsistent points:

- The proposed `--owner` flag was superseded by root-as-`@self` plus a literal host-level `endo invite owner`; no configurable owner flag exists.
- Primordial `/model` handling landed inside the pull request, but `bottle.sh` still refuses to start without `GENIE_MODEL`, so model-over-invite is not end-to-end.
- Systemd unit generation, `sd_notify`, socket activation, and reliable yarn-global installation remain plan text only.
- Yarn-global mode warns that it neither reliably links `endo` nor installs `bottle.sh`.
- The script documents `--no-wait` behavior but has no parser case for that option and always polls indefinitely.
- `bash -n` passed for both scripts, but no live daemon, SSH deployment, owner handshake, systemd, or clean-VM installation was exercised.

The durable material worth migrating is the phased requirements and rejected assumptions in [`PLAN/genie_in_bottle.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/PLAN/genie_in_bottle.md), the long-lived-daemon decisions in [`TADA/81_genie_bottle_not_throwaway.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/81_genie_bottle_not_throwaway.md), the Phase-0 record in [`TADA/81_genie_bottle_phase0_shell.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/81_genie_bottle_phase0_shell.md), and the model-over-invite history beginning with [`TADA/92_genie_primordial.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/92_genie_primordial.md). The journal note should preserve the deployment state machine, ownership handoff, XDG persistence, and deferred phase prerequisites, while recording the inconsistencies above. The obsolete shell should not be integrated into Lal, Fae, or Agentry: host deployment and daemon supervision are outside their model-loop, agent-lifecycle, and provider-harness responsibilities.

No project files, commits, branches, or GitHub state were modified.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-bottle-deployment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 268s

<!-- garden-usage-end -->
