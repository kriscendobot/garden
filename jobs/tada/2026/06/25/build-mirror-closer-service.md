The peer had already completed, so the confirmation was dead-lettered (intent preserved, will be promoted by garden-deadmail). Everything is done. Here is my completion report.

---

## Completion report — `build-mirror-closer-service`

**Pushed to `origin/main2` as `b0b3458e`** (base `08a0e1fa`, bot identity `endolinbot`, isolated worktree off `origin/main2`, explicit pathspecs). 10 files, +661.

### What I built (deterministic, NO `claude` anywhere)
- **`scripts/jobs/mirror-closer.sh`** — single-instance timer service. Self-maintaining watch set = the upstream repos named by the mappings (an unmapped PR is never even fetched, so "never close without a mapping" is true *by construction*). Each tick: read each mapped upstream PR's mechanical `state`/`merged`; if closed and the mirror is still open, post a comment naming the upstream PR + merged-vs-closed and `gh pr close` the mirror; idempotent; **loud-failing**; GitHub I/O pluggable via `GARDEN_MIRROR_PR_STATE`/`GARDEN_MIRROR_CLOSE`.
- **Default handlers** `handlers/mirror-pr-state-gh.sh` (reads state, `require_tools gh jq`, never swallows errors) and `handlers/mirror-close-gh.sh` (comment-then-close, bot identity via the fleet `gh` wrapper).
- **`scripts/jobs/record-mirror.sh`** — producer that writes the mapping; idempotent, conflict-refusing.
- **`garden-mirror-closer.{service,timer}`** + registration in `install-units.sh enable_services`.
- **Monitoring-safety carve-out documented in the header**: the constraint guards a *model* against prompt injection; with no `claude` and no untrusted text read (only typed open/closed/merged state), there is no injection surface, so watching upstreams for this one mechanical state-change is injection-safe. Watches **only** for PRs being closed.

### Mapping schema
`journal2:pr-mirrors/<up-owner>-<up-repo>-<N>.md`, flat `key: value`:
```
upstream: <owner>/<repo>#<N>
mirror: <owner>/<repo>#<M>
created_at / created_by / how
# stamped by the closer on resolution (its durable per-mapping cursor):
closed_at: <iso>
upstream_outcome: merged | closed
```
The **durable cursor is per-mapping** (`closed_at`), not a timestamp stream — exact per PR, survives restarts/hosts, a re-poll is a pure file read. A peer gardener independently created the **first live mapping** (`pr-mirrors/endojs-endo-3254.md`, endojs/endo#3254 → endo-but-for-bots#530) using a `---`-fenced superset; I verified my fence-agnostic parser reads it cleanly and replied confirming the shared canonical contract.

### Mirror-creation point reinforced
The boatman ferry cross-link step — both PRs are known there. Added the `record-mirror.sh` call + a Done bullet to **`roles/boatman/AGENT.md`** and a step 9 to **`skills/pr-handoff/SKILL.md`** (the cross-fork-block→endo-but-for-bots mirror resolves to the same ferry mechanism, and the peer's `method: cross-fork mirror` mapping confirms that path is already feeding the schema).

### Synthetic-repo test result — green
`scripts/jobs/test/mirror-closer-test.sh`: **25/25 PASS**.
- 19 hermetic stub cases (merged vs closed wording, idempotency, upstream-open-leaves-alone, unmapped-closes-nothing, already-closed-mirror-reconcile-only, record-mirror idempotency + conflict refusal, loud-failure on failed state-read and failed close).
- Real end-to-end on a throwaway **`kriscendobot/mirror-closer-selftest`** (private): opened upstream #1 / mirror #2 / unmapped #3, recorded the mapping, closed upstream #1, ran `mirror-closer.sh` with real `gh` → **mirror #2 was actually closed with the expected comment naming the upstream PR URL**; unmapped #3 left open; idempotency held (no duplicate comment, single `closed_at`). Teardown: all PRs closed, branches deleted; repo left (the bot token has no `delete_repo` scope) clearly labelled for inspection.

### Bug fixed during build
`parse_state`'s trailing `&&` returned non-zero on a tab-bearing line, tripping the caller's `set -e`; rewrote as if/else. (Also corrected a stray `set -e` in the test that masked an expected-nonzero assertion.)

### Follow-ups
- The closer is **registered** in `install-units.sh` but I did not enable the live unit on this host (no maintainer authorization to flip a new standing service into the running fleet; `enable-services` will arm it on the next install run). Flagging in case you want it armed now.
- My `record-mirror.sh` writes the leaner unfenced schema; the peer writes a `---`-fenced superset. Both parse identically. If you want one canonical writer shape, that's a small follow-up — not required, since the load-bearing contract is shared.
