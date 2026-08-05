---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Workers cannot find `aws` — propagate `~/.local/bin` into the agent's PATH

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR.
Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

## The defect, measured

A **live** gardener's runtime PATH (read from `/proc/<MainPID>/environ`):

    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

`~/.local/bin` is absent. The AWS CLI is installed and working — `~/.local/bin/aws`
→ `~/.local/aws-cli/v2/current/bin/aws`, v2.35.16 — and credentials resolve
correctly (`sts get-caller-identity` returns user `garden-fleet`, account
`292378781985`). **Only the binary is unreachable from a worker.**

A `systemd --user` unit carries no declared PATH; the garden already knows this
(`gardener-claude.sh` comments on it) and works around it for the agent CLI.
Nothing does so for anything else in `~/.local/bin`.

## Do NOT mirror `claude_bin()` — it solves a different problem

The obvious move is an `aws_bin()` next to `claude_bin()`/`agent_bin()`. **That
would not fix this.** `claude_bin()` resolves the binary **the spine itself
launches**:

    ( cd "$worktree" && env -u ... "$claude_cli" -p --output-format json ... )

`aws` is not launched by the spine. It is invoked **by the agent**, inside its
own `claude -p` session, as an ordinary shell command — so it inherits whatever
PATH the gardener process has. A resolver function in `common.sh` is reachable
only by garden shell scripts; the agent never calls it.

**So the fix is PATH propagation to the agent subprocess, not a resolver.** Get
this distinction right before writing code; it is the whole reason this job
exists rather than a one-line addition to `common.sh`.

## What to change

Ensure the PATH the handler passes to `claude -p` contains the fleet's local bin
directory. Decide where it belongs and say why:

- the systemd unit template(s) under `scripts/systemd/` (`Environment=PATH=…`),
  which fixes every worker kind at once but is only applied on a units reconcile;
- the worker spine (`gardener.sh`) before it invokes the handler, which covers
  every handler and takes effect on the next claim;
- the handler itself, narrowest but needs repeating per handler.

Prefer the option that serves **all worker kinds** (gardener, cleric, hermit,
mystic, fireworker) without per-handler repetition. Whatever you pick, `aws`
must be reachable from inside a `claude -p` session, which is the only test that
matters.

Constraints:

- **Prepend, never replace.** Preserve the inherited PATH; a worker that loses
  `/usr/bin` is far worse than one that cannot find `aws`.
- **Do not hardcode `/home/kris`.** Use `$HOME` / `%h` — the container relocates
  the bot user's home onto the checkout path, and other hosts differ.
- Idempotent: applying twice must not duplicate the entry.
- Do not change AWS credentials, `~/.aws`, or `scripts/aws/*`. Those are correct.
  Read `skills/aws-administration/SKILL.md` for why the credential is hard-linked
  rather than symlinked, and do not disturb that.

## Verification that actually proves it

A test asserting the PATH string contains the directory is necessary but not
sufficient. **Prove the agent can reach the binary**: e.g. a stub `aws` placed in
a temp dir prepended the same way, invoked through the same launch path the
handler uses, asserting it resolves. Follow the fleet's established fake-binary
test pattern (`gardener-worktree-test.sh` puts a fake `claude` on PATH; note its
exec-allowed-tempdir probe — the sandbox mounts `/tmp` noexec and that test
SKIPs rather than failing when it cannot exec).

Add regression coverage under `scripts/jobs/test/`.

## Why this matters now

`minion.town` deploy work (`deploy-siwe-thunk-minion-town`,
`open-signup-gate-flip-minion-town`, `wire-siwe-onchain-authz-minion-town`) is
about to be promoted after ~4 weeks parked. Those jobs will shell out to `aws`.
Today they would fail with `aws: command not found` — **not** an auth error,
which would send whoever reads the report hunting the wrong problem. No job has
hit this yet (a grep of every minion.town/siwe `tada/` report for
`Unable to locate credentials`, `AccessDenied`, `ExpiredToken`, and
`aws: command not found` found zero hits), because none has run.

## Definition of done

The fix landed on `main2`; a test that proves reachability from the agent's
launch path (or SKIPs honestly where the sandbox forbids exec); existing suites
still green; and a `tada/` report naming where you put the fix, why there rather
than the alternatives, whether it needs a units reconcile or a deploy to take
effect, and any other `~/.local/bin` tool that was silently unreachable for the
same reason.
