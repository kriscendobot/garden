# Design: auto-provision per-repo watchers when the garden creates a fork

When the garden starts working a fork it owns, the fork's watchers (commit
triager + comment watcher + CI watcher) are provisioned **automatically and
deterministically** — no human adds slugs to the journal watch sets, and **no
LLM runs anywhere in the gating path**. Comment surveillance on an own fork is
**sender-gated**, because an own fork may be public and repo-gating cannot clear
it.

Code: [`scripts/jobs/fork-watch-provisioner.sh`](../scripts/jobs/fork-watch-provisioner.sh)
(invoked at the top of every [`repo-watcher.sh`](../scripts/jobs/repo-watcher.sh)
tick), the sender gate in
[`scripts/jobs/comment-watcher.sh`](../scripts/jobs/comment-watcher.sh)
(`load_sender_gate` / `gate_trusted`), tests
[`fork-watch-provisioner-test.sh`](../scripts/jobs/test/fork-watch-provisioner-test.sh)
and the `SG`/`SG2` cases in
[`comment-watcher-test.sh`](../scripts/jobs/test/comment-watcher-test.sh).
Authorization: journal broadcast `msgs/broadcast/20260709T225552Z-e61229.md`
(kriskowal, 2026-07-09, "watch the garden's own forks") — the § Monitoring
safety constraint's required maintainer-authorization record for this widening.

---

## 1. The gap this closes

The two journal-backed watch sets — `repos/` → `garden-triager@<slug>` (commit
watch, laxer bar) and `comment-repos/` → `garden-comment-watcher@<slug>` +
`garden-ci-watcher@<slug>` (comment + CI, strict bar) — were provisioned
**manually**. Watch membership therefore never followed fork creation: the
garden held a bare clone of `kriscendobot/minion.town` and worked its PRs, yet
three kriskowal APPROVED reviews on `minion.town#3` (2026-07-09, 20:43 / 21:16 /
22:49Z) went unnoticed because the repo was in **neither** set. Approval-noticing,
finalization, CI shepherding — the whole reactive machinery — silently did not
exist for that repo.

## 2. The seam: reconcile bare clones → watch membership

Three candidate seams were evaluated:

- **`clone-keeper.sh`** — wrong shape: it iterates a *static* tracked list
  (`GARDEN_TRACKED_CLONES`), so it sees exactly the clones someone already
  registered; a new fork would need the same manual step this design removes.
- **`ensure-project-worktree.sh`** — wrong lifecycle: it runs mid-job on any
  host, in a gardener's hot path, and *requires* the bare clone to already
  exist; putting a journal CAS push inside it adds latency and failure modes to
  every project job for an event (first sight of a repo) that is rare.
- **A reconcile step over the standing bare clones** — chosen. The shelf
  `worktrees/<owner>-<name>.git` *is* the deterministic record of which forks
  the garden works (every project checkout is cut from it, whatever created it:
  a gardener's by-hand clone, clone-keeper's repair, an import script). Mapping
  that record into the watch sets catches **every** creation path, including
  forks that already existed before this design landed — which is exactly how
  minion.town was missed.

The provisioner runs at the top of every `garden-repo-watcher` tick (1-minute
cadence, **every host** — the per-repo units it arms are themselves leader-gated,
but discovery must run wherever the clone lives), so a new fork is armed and its
units reconciled **in the same tick**. It is best-effort there: a provisioning
failure never blocks reconciling the already-armed set.

Per tick:

1. **Discover** (every host): scan `$GARDEN_WORKTREES/*.git` for slugs whose
   owner is listed in the journal's `config/fork-owners`; for each not
   tombstoned (§4), confirm its upstream is live before arming a missing record.
   Fully armed forks are rechecked too: a successful check writes a local,
   per-host staleness stamp, so they are probed at most once every four hours
   (`GARDEN_FORKWATCH_LIVENESS_INTERVAL`, default `14400`) rather than once per
   one-minute tick. A 404 joins the existing durable tombstone path, removing
   both arming records; an inconclusive check writes no stamp and never
   tombstones, so it is retried on the next tick. The stamps are intentionally
   untracked local state: they prevent API and journal-CAS churn across the
   clone shelf while bounding dead-upstream recovery to four hours plus one
   tick. A live missing membership CAS-lands the arming record(s) in one commit
   through the standard `sync_clone`/`commit_and_push` retry loop. Idempotent:
   a peer host landing first makes this host's attempt a staged-empty no-op.

   **Retiring an armed fork is harder than declining to arm an unarmed one.**
   Declining costs a tick and reverses itself; retiring tears down four live
   per-repo unit families and writes a tombstone only a human removes. So the
   armed path — and only the armed path — carries two extra guards: a **confirm
   re-check** (a first definitive 404 is re-probed once; anything but a second
   definitive 404 defers to the next tick, so a rename mid-flight or an
   eventual-consistency blip cannot retire a live fork), and a **mass-404
   breaker** (if every armed fork probed in a tick 404s and there are at least
   two of them, that is a read-side failure — a token that lost `repo` scope
   reads a *private* fork as 404, not as 401 — so nothing armed is retired and
   the maintainer is alerted). A mixed tick, where some armed forks still
   resolve, is the ordinary one-fork-was-deleted case and retires normally.
2. **Materialize** (leader only): `triager.sh` hard-requires a bare clone at
   `$GARDEN_REPOS/<slug>.git` and the per-repo units carry the `is-main-host`
   ExecCondition, so the leader clones any armed own-fork whose triager clone is
   missing (bounded `timeout`, staged into a sibling temp, atomically `mv -T`'d
   — the clone-keeper discipline). A persistent clone failure throttle-escalates
   to the maintainer inbox instead of letting `garden-triager@<slug>` die "no
   bare clone" every minute unseen.

The script is **inert until `config/fork-owners` exists** on `origin/journal2` —
writing that file is the deliberate per-instance arming act (the issue-inbox
shape), so deploying the code is harmless on its own.

## 3. Own forks vs upstream/third-party (the monitoring-safety line)

Auto-provisioning is scoped hard to owners listed in **`config/fork-owners`**
(journal data: one GitHub login per line, `#` comments, case-insensitive;
seeded: `kriscendobot`, per the authorization broadcast). A bare clone of any
other owner — `endojs/*`, `agoric/*`, a contributor's fork — is **never**
auto-added; widening surveillance onto a repo we don't own keeps the existing
explicit per-repo maintainer-authorization bar. Adding another garden bot login
to `config/fork-owners` is append-and-push under the same standing
authorization ("the garden's own forks"); adding a **non-bot** owner is a new
widening and needs its own recorded authorization.

Slug convention: `<owner>-<name>` splits on the **first** dash (the established
convention across the watchers), so listed owners must carry no dash; the
provisioner skips a dashed entry with a warning rather than misparse it.

Reconciling the per-set bars:

- **`repos/` (commit triager)**: safe to auto-add — an own fork's commits are
  written by the fleet and the maintainer.
- **`comment-repos/` (comment watcher)**: comment text enters `claude -p` when
  a minted job is claimed, and **an own fork may be public**, so repo-gating —
  the bar that clears `endojs/endo-but-for-bots` — cannot apply. The substitute
  defense is the **sender gate** (§5). Auto-provisioned comment surveillance on
  an own fork is permitted **only** behind that gate; the provisioner writes
  every own-fork `comment-repos/` record with `sender-gate: required`.
- **`ci-watcher`**: reads only CI status and PR metadata, feeds no external
  text to an LLM (injection-safe by construction), and rides the same cleared
  `comment-repos/` set — no extra surface, no extra gate.

## 4. Unwatch stays meaningful: the `watch-optout/` tombstone

Deleting a watch-set file is the established unwatch signal — but a reconciler
would re-add it on its next tick. To unwatch an auto-provisioned own fork
durably: delete the arming file(s) **and** add `watch-optout/<slug>` (any
content) to the journal. The provisioner never re-adds a tombstoned slug;
removing the tombstone re-enables auto-provisioning. Hand-armed repos
(`endojs-endo-but-for-bots`, `kriskowal-garden`) are outside `config/fork-owners`
and never touched either way.

## 5. The sender gate (the load-bearing part)

Mirrors `mention-watcher.sh` and the issue-inbox: a **deterministic sender-trust
gate in plain code, before any comment text reaches a job, a reactji, a reply,
or `claude -p`**. When the arming file `comment-repos/<slug>` declares
`sender-gate: required`, the comment-watcher drops (logged, cursor slides) every
comment whose author is not:

- on the journal `trusted-senders/allowlist`, or
- on the journal `maintainers/allowlist` (the issue-inbox's driver list — a
  strict superset of trust for merely commenting), or
- a current **endojs**/**Agoric** org member (the same read-only
  `mention-trust-gh.sh` probe the mention-watcher uses).

Placement matters: on the gated path the check fronts the **whole** per-comment
pipeline — including the mechanical verb table (`rebase`/`shepherd`/…), which is
deliberately trust-independent on repo-gated repos. On a public own fork a
drive-by "please rebase" from an unknown account must mint nothing, ack nothing,
and excerpt nothing into a job body. The `SG` test case pins exactly this
(contrast: case `A` proves the same comment *does* mint on an ungated repo).

The gate composes with — does not replace — every existing gate (self-comment,
mention-only PR-authors, PR-only mode, the untrusted-review drop).

### Deploy-ordering: the gate cannot be bypassed by a stale tree

The provisioner is the **only writer** of own-fork `comment-repos/` entries, and
it ships in the same deployed tree as the comment-watcher's gate. An own fork
can therefore never be comment-armed by a tree that lacks the gate: a deployed
garden either has both (arms, gated) or neither (arms nothing). The one
hand-armed bootstrap instance (§6) was verified **private** before arming, so
collaborator-gating covered the pre-deploy interval.

## 6. First concrete instance: `kriscendobot/minion.town`

Armed by hand on 2026-07-09 (this design's landing day), ahead of the code
deploy, to close the live missed-review gap inside the comment source's 1-hour
cold-start window:

- `repos/kriscendobot-minion.town` + `comment-repos/kriscendobot-minion.town`
  (the latter carrying `sender-gate: required`) landed on `journal2` at
  2026-07-09T23:06Z, each citing the authorization broadcast;
- the triager's bare clone was materialized at
  `repos/kriscendobot-minion.town.git` on the leader so the just-armed
  `garden-triager@` never dies "no bare clone";
- `config/fork-owners` seeded with `kriscendobot`.

Safety of the pre-deploy interval: the repo is **private** (verified
2026-07-09), so only collaborators can comment — the same effective bar as
repo-gating — until the deployed watcher picks up the `sender-gate: required`
line. The gate holds thereafter, including if the repo ever goes public.

Once this design deploys, the provisioner will also arm the **other** existing
`kriscendobot/*` bare clones on the leader (agoric-3-proposals, agoric-sdk,
cosgov, endo, finbot, ocapn, vattr97 as of 2026-07-09) — the broadcast's
standing intent, with the sender gate in force from the first tick since the
gate deploys in the same tree. Any of them the maintainer prefers unwatched is
one `watch-optout/<slug>` away.

## 7. Alternatives considered

- **Hooking fork creation itself** (a `create-fork.sh` entry point): rejected —
  there is no single creation path today (hand clones, clone-keeper repair,
  import scripts), and a hook covers only futures, not the already-existing
  clones that produced the minion.town miss. Considered and rejected.
- **Making the triager self-provision its clone**: rejected — the provisioner
  is the one place that knows a slug is an auto-provisioned own fork; keeping
  `triager.sh` untouched keeps its "die loud on a missing clone" contract for
  hand-armed repos. Considered and rejected.
- **Gating own-fork comments on `maintainers/allowlist` only** (the issue-inbox
  bar): rejected — commenting on a fork's PRs is the collaboration surface, not
  the drive-the-garden surface; the mention-watcher's wider allowlist+org bar is
  the established trust level for exactly this kind of text. Considered and
  rejected.
