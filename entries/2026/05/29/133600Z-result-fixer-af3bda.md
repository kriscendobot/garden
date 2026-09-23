---
ts: 2026-05-29T13:36:00Z
kind: result
role: fixer
host: endolinbot
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--af3bda/project
refs:
  - entries/2026/05/29/132130Z-dispatch-steward-f2a3b4.md
---

# fixer result: PR #377 maintainer-feedback response (cache + backoff)

Maintainer kriskowal posted feedback at 2026-05-29T13:20:27Z on PR #377:
> This appears to have been insufficient. How do we know that the flakes
> are intermittent? Do we have an expectation that a fast retry loop will
> not make the situation worse? Should we use a back-off strategy? Can we
> lean harder into caching?

## Investigation findings

1. **The flakes are NOT intermittent.** Pulled `check-runs` for the last ~30 master commits on `endojs/endo`; test-xs is the only failing job on every recent run (c49fb04, 691ac07, da632a2, 44b8054, plus this PR and upstream #3291). The retry mechanism is firing visibly in every log; all three attempts fail on the same run. phoddie's note on issue #3289 ("we have noticed that the GitHub website has been less reliable recently") corroborates a persistent-issue-not-network-drop shape.
2. **Fast retry can make it worse.** Under a soft rate-limit or partial outage, three attempts at constant 5s spacing in lock-step across concurrent CI starts prolongs the throttle. The constant-delay design is wrong for this failure mode.
3. **Backoff is the right shape.** Exponential with jitter prevents the lock-step retry pattern.
4. **Caching is the load-bearing fix.** The workflow had no cache for `~/.esvu` (only a later cache for `bin/xst` that the install-engines.sh script could not consume because the cache restore ran *after* `Install engines`). Adding an `actions/cache` for `~/.esvu` BEFORE the install step lets the script's `are_engines_installed` short-circuit fire on a hit and skip esvu entirely.

## Dispositions and commits

| Maintainer question                                | Disposition | Addressed by                                                                  |
| -------------------------------------------------- | ----------- | ----------------------------------------------------------------------------- |
| How do we know flakes are intermittent?            | Answered    | Top-level reply with check-runs evidence (comment 4575777172).                |
| Will fast retry not make it worse?                 | Answered    | Top-level reply with rate-limit / lock-step analysis.                         |
| Should we use back-off?                            | Code change | Commit 6c15b04: exponential backoff (5s, 10s) with 0-4s awk-based jitter.     |
| Can we lean harder into caching?                   | Code change | Commit 7309e26: `actions/cache@27d5ce7f` for `~/.esvu` before Install engines, keyed on `runner.os` + install-engines.sh hash with `restore-keys` fallback. |

## Pushed commits

- `7309e26b` fix(ci): cache esvu engines across test-xs runs (#377)
- `6c15b047` refactor(benchmark): exponential backoff with jitter in esvu retry (#377)

New head: `6c15b04` pushed to `fix-benchmark-install-engines-retry`. Comment 4575777172 (https://github.com/endojs/endo-but-for-bots/pull/377#issuecomment-4575777172) posts the four-question disposition and cites both SHAs.

## CI confirmation on the new head

Run 26640264497 confirmed:
- `Restore esvu engines cache` step ran cleanly; key resolved to `esvu-Linux-0cc04e2cd5...`; cache not found (expected on first run with new key).
- Backoff visible: `retrying in 6s...` then `retrying in 14s...` for xs; `retrying in 6s...` then `retrying in 11s...` for v8. Jitter spread confirmed.
- The underlying esvu install still extract-fails for both `xs@8.1.1` and `v8@15.0.238` (v8 canary moved from 233). So the cache cannot self-bootstrap; it needs at least one successful install to populate.

Posted CI follow-up comment 4575808861 surfacing the structural question for the maintainer: should V8 be downloaded directly via `wget` (mirroring the existing explicit XS download step) to bypass esvu's V8 install entirely, or wait for upstream esvu/Moddable-release reliability to recover?

## Out of scope (noted for follow-up, not actioned)

- The existing `Restore XS binary cache` step (workflow lines 415-420) runs *after* `install-engines.sh`, so the `if [ -f "$GITHUB_WORKSPACE/bin/xst" ]; then ln -s "$GITHUB_WORKSPACE/bin/xst" "$HOME/.esvu/bin"; fi` shortcut at the top of the script never fires. Reordering or unifying the two caches is a follow-up worth doing but touches workflow shape more than the present review item; deliberately left for a separate PR (noted in the maintainer reply).
- The V8-direct-download structural question above is design-shaped and deferred to maintainer authorization. The PR mirror's lane is the bot-side; the upstream design call lives on endojs/endo#3291.

## Note on the mirror PR shape

This is the bot-side mirror of endojs/endo#3291. The same maintainer pushback would apply upstream (and the same two commits would carry over). The maintainer's comment landed on the bot mirror only; the upstream PR has not received parallel feedback. If the maintainer accepts these commits here, they're a candidate for cherry-pick into #3291 by the boatman on the next ferry pass.

## Comment IDs

- Maintainer's question: 4575582541
- Fixer's four-question reply: 4575777172
- Fixer's CI follow-up: 4575808861

## Self-improvement

Self-improvement: nothing this time. The two skills used (`review-feedback-followup-commits`, `pr-review-thread-replies`) were sufficient for the top-level-comment-reply shape and the two-commits-one-concern-each discipline. The `pre-push-gates` skill ran but had environmental failures from a freshly-cloned worktree without `yarn install`; the probes all passed and the workflow / shell changes were the only changed surfaces, neither of which yarn format / lint touches. Probe-only gate would be a useful flag for fixer dispatches that don't touch JS source, but this is a minor optimization, not a structural lesson.
