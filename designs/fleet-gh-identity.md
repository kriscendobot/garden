# Deterministic fleet gh identity

## The leak

The garden's systemd units (`scripts/systemd/garden-*.service`) carry **no
`GH_TOKEN`**. A bare `gh` therefore resolves its identity from the *global active
account* recorded in `~/.config/gh/hosts.yml`. On a host that has both the bot
(`kriscendobot`) and the maintainer (`kriskowal`) logged in — the maintainer's
host does — that active account can be **kriskowal**. When it is, every fleet
`gh` action runs **as the maintainer**: reactji, PR comments, reviews, merges,
forks. This is an identity leak: the fleet's work is attributed to the human, and
the fleet's identity depends on a mutable global that any `gh auth switch`
anywhere can flip.

It was first hotfixed by setting the active account back to `kriscendobot`, but
that is fragile — the next `gh auth switch` re-breaks it, and the fleet's
identity must not depend on mutable global state.

## The fix — a PATH wrapper that pins the bot token

`scripts/jobs/bin/gh` is a wrapper that sits at the **front of the fleet's
PATH**. `scripts/jobs/common.sh` prepends `scripts/jobs/bin` to `PATH` (guarded
against double-prepend), and every fleet entrypoint sources `common.sh`, so the
modified PATH propagates to all children — including the `claude -p` gardener
subagents and the `gh` calls inside their Bash tool invocations.

The wrapper resolves identity deterministically:

- **Default → the bot.** With no override present, it injects
  `GH_TOKEN=$(gh auth token --user kriscendobot)`, read **live** from gh's own
  store on each call (so it never goes stale and no token is ever written to a
  tracked file). The action is `kriscendobot` regardless of the global active
  account.
- **Override → explicit and one-directional.** Set
  `GARDEN_GH_IDENTITY=<login>` to resolve a different account's token, or pre-set
  `GH_TOKEN` yourself to pass a token through untouched. Either is an explicit,
  auditable signal on the specific command. Routine work that sets nothing can
  **never** silently become kriskowal — the bot is the floor; kriskowal is only
  ever reached deliberately.
- **Degraded fallback.** If the intended identity's token cannot be resolved
  (e.g. that account is not logged in on this host), the wrapper logs a loud
  `WARNING … POSSIBLE IDENTITY LEAK` to stderr and falls back to bare `gh` rather
  than break every fleet call. On fleet hosts `kriscendobot` is reliably logged
  in, so this path is not normally taken; the warning makes it visible if it is.

The wrapper only affects processes whose PATH includes `scripts/jobs/bin` — i.e.
the fleet. A maintainer's interactive shell is untouched and keeps whatever
active account they chose.

### Why a wrapper, not a systemd `EnvironmentFile`

An `EnvironmentFile` exporting a static `GH_TOKEN` would (a) bake a token into an
on-disk file that goes stale when the token rotates, and (b) only cover processes
launched by the units that reference it — not the `claude -p` subagents reached
through PATH inheritance, nor manual/test invocations. The live-read PATH wrapper
covers every fleet `gh` uniformly and never persists a token.

## The boatman exception (preserved)

The boatman legitimately acts as `kriskowal` for authorized upstream ferries
(`identity_switch_authorized: true`). Under this wrapper its **upstream-acting**
gh calls must opt in explicitly:

```sh
GARDEN_GH_IDENTITY=kriskowal gh pr create --base master ...
GARDEN_GH_IDENTITY=kriskowal gh api repos/<upstream>/<repo> --jq .permissions
```

while its **garden-side** post (the `Mirror of …` cross-link) stays on the bot
default. See `roles/boatman/AGENT.md` § Operating norms. The git push to upstream
is unaffected (it authenticates via the git credential helper / SSH, not the gh
wrapper) and remains gated by `identity_switch_authorized`.

## Leak-window audit (session of 2026-06-24, before the active-account hotfix)

The active account was reset to `kriscendobot` at ~20:48Z (hosts.yml mtime).
Fleet gh write actions on `endojs/endo-but-for-bots` *before* that, attributed to
`kriskowal`, were the leak. Distinguishing signal: fleet comments either carry a
bot-generated verdict shape (`## Botanist verdict: …`, `## Dependabotany verdict:
…`) or @-mention `kriskowal` while reading as the PR author addressing a review;
genuine human comments @-mention `kriscendobot` (the human directing the bot).

**Merges executed as kriskowal (4):** dependabot PRs #267, #270, #271, #274 —
`merged_by=kriskowal`, each preceded ~8s by a fleet botanist verdict comment.
(Irreversible: a merge actor cannot be rewritten. Low harm — chore dependency
bumps — but recorded.)

**Comments posted as kriskowal (9 issue + 8 inline):**

| PR | comment id | shape |
|----|-----------|-------|
| #507 | 4787944947 | "Revision 5 — resolving the revision-4 review" (PR-update) |
| #442 | 4788052568 | "@kriskowal Rebased … addressed the review" |
| #96  | 4788093106 | "@kriskowal On it — pushed 9d8b2ad33" |
| #271 | 4788341325 | "## Botanist verdict: REJECT" |
| #274 | 4788348877 | "## Botanist verdict: MERGE-NOW" |
| #197 | 4788361981 | "## Botanist verdict: HOLD" |
| #267 | 4788674101 | "## Botanist verdict: MERGE-NOW" |
| #270 | 4788719946 | "## Botanist verdict: MERGE-NOW" |
| #197 | 4791420725 | "## Dependabotany verdict: EMBARGO" |

Inline review comments (same leak, accompanying the above): #507 →
3466109345, 3466109456, 3466109586, 3466111399; #442 → 3466196871, 3466197028,
3466197155; #96 → 3466229009.

**Already corrected by the liaison:** the #96 reactji (👀).

**Confirmed *not* leaks (genuine human maintainer, @-mention kriscendobot):**
#57 id=4793208270, #96 id=4793406283, #474 id=4793426763.

### Repair note

A GitHub comment's author cannot be changed in place, and a merge actor cannot be
rewritten. Repair of the mis-attributed comments (delete + repost as the bot, vs.
leave them as accurate-but-mis-attributed) is an **irreversible, identity-facing**
decision and is left to the liaison/maintainer rather than executed by the fleet —
the same path by which the #96 reactji was corrected. This document enumerates the
set so that decision can be made deliberately.
