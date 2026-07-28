**Completion report — self-heal-fix-garden-comment-watcher-kriscendobot-garden-repo-404-crashloop**

## Part 1 (immediate disarm): NOT performed — the premise has since reversed

Verified before acting, and doing it as written would have been a regression:

- `gh api repos/kriscendobot/garden` returns **200** under both default and `kriscendobot` identities. The repo was **transferred** `kriskowal/garden → kriscendobot/garden` on 2026-07-28 (see `e878e57b5d`'s neighbors, `14fd4feca1`).
- The dead-fork situation the job describes was **real on 2026-07-27 and already fixed**: journal `7334329563` dropped the arming records and landed `watch-optout/kriscendobot-garden`; `9971003d54` then re-keyed the garden's own watch to the new slug.
- `watch-optout/kriscendobot-garden` **still exists** (kept deliberately — its body documents that it now suppresses only *auto-provisioning*, so the provisioner cannot arm a commit triager on the garden's own repo).
- `comment-repos/kriscendobot-garden` is the **hand-written, deliberate** arming of the garden's own repo (`surfaces: pr-only`, `sender-gate: required`, authorization carried forward from `comment-repos/kriskowal-garden`). Deleting it would have disarmed the PR-review surface on the garden's own repo. `repos/kriscendobot-garden` does not exist; there is no `ci-repos/` directory.
- The unit is **healthy, not crash-looping**: `garden-comment-watcher@kriscendobot-garden.service` last ran `07:18:43`, exit `0/SUCCESS`, "cursor unchanged (acted on 0; failed=0)". No stranded `kriskowal-garden` arming records or units remain.

**Flag (as requested):** `worktrees/kriscendobot-garden.git` no longer exists — the watcher logs "no bare clone". What *does* exist is `worktrees/kriskowal-garden.git`, origin `ssh://git@github.com/kriskowal/garden.git`, last commit 2026-07-15. It does **not** 404 (the old path redirects) and its owner `kriskowal` is not in `config/fork-owners`, so it can never trigger auto-provisioning. It is stale post-transfer. **Maintainer decision:** remove it, or re-point its origin to `kriscendobot/garden`. I did not touch it — deleting a bare clone under the garden root is outside what this job's premise justifies now that the premise is false.

## Part 2a (durable guard in the comment source): DONE — pushed as `75998eb4fe`

`scripts/jobs/handlers/comment-source-gh.sh`: on the **already-failed path only** (zero cost to a healthy tick), the source now probes `repos/<repo>` once. On a **definitive** repo-level error it logs `REPO GONE`, calls `alert_maintainer` under the per-slug key `comment-watch-repo-gone-<slug>` (the `triager.sh:133` shape) with the exact remediation, and **exits 0** — emitting no rows, so the watcher goes quiet and the unit stays clean instead of failing every tick forever.

Deliberately narrow: a transient signature is "we could not ask", not "it is gone", and a repo that still answers keeps the unchanged `FETCH INCOMPLETE` → exit 1 freeze, so a real lost fetch is never silently swallowed.

**One spec deviation, stated:** I did **not** take the "auto-write the `watch-optout/<slug>` tombstone" option the job offered as an alternative. A tombstone only suppresses `fork-watch-provisioner` auto-arming — it would not stop a hand-armed watcher, so it does not actually close the loop — and a journal CAS push from a per-minute systemd timer is far heavier than a throttled alert. Rationale is in the code comment.

## Part 2b (provisioner preflight): already implemented — no change needed

`fork-watch-provisioner.sh` **already has** the exact preflight the job asks for: `upstream_exists()` (lines 180–193) runs `gh api repos/<owner>/<name>` before arming, 404 → auto-tombstone + disarm, inconclusive → defer, plus a 4-hour liveness recheck of already-armed forks. Landed by `7814c70655` / `bb971c9a39`. The job's grep-based claim ("no `exist`/`404` guard before arming") is stale. `fork-watch-provisioner-test.sh`: **31 passed, 0 failed**.

## Tests

New `GONE` case in `scripts/jobs/test/comment-watcher-test.sh`, 8 assertions: exit 0 + zero rows on a gone repo, the `REPO GONE` log, the maintainer alert under the dedup key, alert fires **once** across two ticks (throttled), and — the anti-regression half — a live repo with a broken surface still exits nonzero and still logs `FETCH INCOMPLETE`.

`comment-watcher-test.sh`: **244 passed, 0 failed**. `bash -n` and `shellcheck -S warning` clean (only the pre-existing `GARDEN_TAG` SC2034).

## Follow-ups

1. Maintainer call on `worktrees/kriskowal-garden.git` (remove or re-point origin).
2. `ci-watcher.sh` and `triager.sh` were not audited for the same repo-gone class; the triager already exits 0 + alerts on a fetch failure, so the exposure is likely limited to the comment source, but a deliberate pass would confirm it.
