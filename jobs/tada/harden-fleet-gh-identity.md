Inbox empty. Work complete.

---

# Completion report — `harden-fleet-gh-identity`

**Status: done.** Fix committed and pushed to `origin/main2` (SHA **`11240ac270fc0cd556b20c930f6c87f3e4f82722`**, bot identity `endolinbot`), deployed live, and verified. Full test suite **88/88**.

## Mechanism chosen — a PATH-injected `gh` wrapper (not a systemd EnvironmentFile)

`scripts/jobs/bin/gh` sits at the front of the fleet's PATH (prepended in `scripts/jobs/common.sh`, which every fleet entrypoint sources, so it propagates to all children — including the `claude -p` gardener subagents and the `gh` calls inside their Bash tool invocations). It:
- **Defaults to the bot**: injects `GH_TOKEN=$(gh auth token --user kriscendobot)`, read **live** each call (never stale, no token ever written to a tracked file), so the identity is `kriscendobot` regardless of the mutable global active account.
- **Preserves the boatman exception, one-directionally**: an explicit `GARDEN_GH_IDENTITY=<login>` (or a pre-set `GH_TOKEN`) is the only way to reach `kriskowal`. Routine work that signals nothing can never silently become the maintainer.
- Degrades loudly (stderr `POSSIBLE IDENTITY LEAK` warning) rather than breaking gh if a token can't be resolved.

I chose the wrapper over an `EnvironmentFile` because a static token file goes stale on rotation and only covers unit-launched processes, not the PATH-inherited subagents. **`roles/boatman/AGENT.md`** updated with the explicit override norm (`GARDEN_GH_IDENTITY=kriskowal` for upstream-acting `gh pr create`/permission checks; bot default for the garden-side cross-link). Mechanism + audit documented in **`designs/fleet-gh-identity.md`**. New hermetic **SUBTEST 17** (`scripts/jobs/test/fake-gh.sh`) reproduces the leak and proves the pin, the override, and one-directionality; `bash -n`/shellcheck clean.

**Verified live** against the real gh store (no risky active-account flip): wrapped default → `kriscendobot`, explicit `GARDEN_GH_IDENTITY=kriskowal` → `kriskowal`. Since the active account is currently `kriscendobot`, the override returning `kriskowal` proves the wrapper is *injecting* tokens, not passively reading the active account — so the default is injection-driven and account-independent. Units re-rendered + `daemon-reload`. Per-job handlers re-source `common.sh`, so in-flight gardeners' future jobs use the wrapper without a restart.

## Leak-window audit (2026-06-24, before the ~20:48Z active-account hotfix)

Fleet gh actions that ran **as `kriskowal`** on `endojs/endo-but-for-bots`. Distinguishing signal: fleet comments carry bot verdict shapes (`## Botanist verdict:`, `## Dependabotany verdict:`) or @-mention `kriskowal`; genuine human comments @-mention `kriscendobot`.

- **4 merges executed as kriskowal** (irreversible): dependabot #267, #270, #271, #274 — each preceded ~8s by a fleet botanist verdict.
- **9 issue comments + 8 inline review comments as kriskowal**: #507 (rev-5 + 4 inline), #442 (rebase + 3 inline), #96 ("On it" + 1 inline), #271/#274/#197/#267/#270 botanist verdicts, #197 dependabotany. Full table with IDs in the design doc.
- **Already corrected** by the liaison: the #96 reactji. **Confirmed NOT leaks** (genuine maintainer, @-mention kriscendobot): #57·4793208270, #96·4793406283, #474·4793426763.

Repair note: a comment's author and a merge actor can't be rewritten in place. Deciding whether to delete+repost the mis-attributed comments vs. leave them (content is accurate) is an **irreversible, identity-facing** call left to the liaison/maintainer — enumerated, not executed.

## Findings surfaced (not silently worked around)

1. **Watchman is wedged, garden-wide** — messaged the maintainer. The live `/home/kris/scripts/jobs/common.sh` holds **substantial uncommitted work** (a flock-based "shared-clone race fix") that is *not* in `origin/main2`. It blocks the watchman's fast-forward, so the live tree was stuck at `51030653` while origin advanced — **no origin change auto-deploys for any job** until it's resolved. I did not touch it (committing another agent's untested WIP isn't mine to decide); I deployed my own fix to a different region non-destructively, so the flock WIP is intact and my fix is live.
2. **Posted job `improve-mentor-journalctl-timeout`** — `mentor.sh`'s `journalctl --user` probe has `|| true` (catches a non-zero exit) but **no timeout**, so it can hang the self-healing loop indefinitely (observed live, ~2min, until killed by hand). Proposed a `timeout 30` guard.

## Follow-ups
- Maintainer/owner: decide the fate of the uncommitted flock WIP to unwedge the watchman (live `bin/gh` is untracked-but-identical to origin and my `common.sh` hunk is additive — both reconcile cleanly on the next fast-forward).
- Maintainer/liaison: decide repair posture for the 17 mis-attributed comments + 4 merges.
