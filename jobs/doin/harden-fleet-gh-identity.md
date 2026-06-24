# Harden the fleet's GitHub identity so it is deterministically the bot

Wear the **mentor** role. The pause earlier today was caused by an identity leak:
the gardener/service systemd units carry **no `GH_TOKEN`**, so `gh` resolves the
active account from `~/.config/gh` — which was **kriskowal** (the maintainer). Every
gardener gh action (reactji, PR comments, merges, forks) defaulted to acting **as
the maintainer**. It was hotfixed by setting the active account to `kriscendobot`,
but that is fragile: any `gh auth switch` anywhere flips it back, and the fleet's
identity must not depend on a mutable global.

Build the durable fix (on `main2`; **use an isolated worktree off `origin/main2`** per
the garden's infra-job discipline — the shared tree is concurrently mutated).

## The fix — make fleet gh actions resolve to the bot, independent of the global active account

1. Make every fleet process run `gh` as **`kriscendobot`** deterministically. Choose
   the cleaner of:
   - a small **`gh` wrapper** on the fleet's PATH that injects the bot token
     (`GH_TOKEN=$(command gh auth token --user kriscendobot)`) unless an explicit
     identity override is set; or
   - a **systemd `EnvironmentFile`** (mode 600, outside the repo) that exports a bot
     `GH_TOKEN`, referenced by the gardener and service units.
   Do **not** hardcode a token in a tracked unit file. Document the chosen mechanism.
2. **Preserve the boatman's kriskowal exception.** The boatman legitimately acts as
   `kriskowal` for authorized upstream ferries (`identity_switch_authorized`). The
   default must be the bot, with an explicit, auditable override path the boatman
   uses — never the reverse. Make the override require an explicit signal, so routine
   work can never silently become kriskowal.
3. **Audit the leak window.** Enumerate gh actions the fleet took **as kriskowal**
   during this session before the active-account hotfix (PR comments, reactji,
   reviews, merges) and list them for repair. (The #96 reactji was already corrected
   by the liaison; check for others on endo-but-for-bots from today.)

## Tests & verification

- A gardener-context `gh api user` resolves to **kriscendobot** even when the global
  active account is set to kriskowal. The boatman path can still reach kriskowal when
  explicitly authorized. `shellcheck`/`bash -n` clean. After landing, redeploy units
  (`install-units.sh install` + `daemon-reload`) and confirm a live gardener acts as
  the bot.

## Definition of done

The fleet's gh identity is deterministically `kriscendobot` regardless of the global
active account, the boatman's authorized-kriskowal path preserved, the leak-window
audit delivered, units redeployed, committed and pushed to `origin/main2` (bot
identity). Report the SHA, the mechanism chosen, and the leak-window findings. If
blocked, report the diagnosis and ready-to-apply change rather than claiming
completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 21
  claimed_at: 2026-06-24T22:08:32Z
