# PR-review sequence — `endojs/endo-but-for-bots` (unblock worklist)

_Snapshot: 2026-07-13. Read-only planning report (no PR comments were posted). All
refs are fully-qualified `owner/repo#N`. Target branch is `llm` (the roadmap
branch) unless noted; a few land on `master` (the upstream-mirror lane)._

## The bottleneck, in one paragraph

The fleet is still **merge-bottlenecked on maintainer review**, not on engineering —
but this window the review queue actually *moved*: since the 2026-07-11/12 snapshots
a batch of green M3 PRs **landed**, most consequentially the entire
[`endojs/endo-but-for-bots#127`](https://github.com/endojs/endo-but-for-bots/issues/127)
mount search-tools stack ([`#678`](https://github.com/endojs/endo-but-for-bots/pull/678),
[`#680`](https://github.com/endojs/endo-but-for-bots/pull/680),
[`#681`](https://github.com/endojs/endo-but-for-bots/pull/681) all **merged**), the
module-loading design ([`#659`](https://github.com/endojs/endo-but-for-bots/pull/659)
**merged**), the LLM edit tool ([`#668`](https://github.com/endojs/endo-but-for-bots/pull/668)
**merged**), and the pi-* 0.80.3 migration ([`#649`](https://github.com/endojs/endo-but-for-bots/pull/649)
**merged**). What remains waiting is a **smaller, sharper core**: the
module-loading *implementation* (Phase 1 registry capability), the
scheduled-execution exit criterion now **redrafted** as the `@endo/reminder` plugin
(the old endoclaw-timer stack was **closed** and superseded, per the maintainer's
redirect), confined outbound HTTP, subscription OAuth, the agent-embedding surfaces,
the daemon-mount primitives, and two Docker self-host images. **Start with
[`endojs/endo-but-for-bots#671`](https://github.com/endojs/endo-but-for-bots/pull/671)** —
it is the green, mergeable Phase-1 `EndoRegistry` capability whose design
([`#659`](https://github.com/endojs/endo-but-for-bots/pull/659)) already merged, so
reviewing it unblocks the entire import-from-mount build program (every downstream
builder dispatch keys off it). That is the highest-leverage first move now that the
[`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) cascade has already
shipped.

## Review now, in this order (top clears the most downstream work)

Work top to bottom. Every PR in this section was re-checked live on 2026-07-13:
non-draft, `mergeable = MERGEABLE`, all CI checks green (except where a specific
`UNSTABLE`/pending caveat is called out — those are held in the blocked section, not
here). Merge-state `BLOCKED` below means *mergeable and green, blocked only by the
branch-protection review gate* — i.e. exactly "waiting on a human review", not a
conflict.

### 1. Module-loading substrate — the Phase-1 implementation (design already merged)

Highest **strategic** leverage: [`#659`](https://github.com/endojs/endo-but-for-bots/pull/659)
(the four-layer accept-and-sequence design) **merged this window**, so the build
program is accepted and its first implementation is now review-ready.

- [`endojs/endo-but-for-bots#671`](https://github.com/endojs/endo-but-for-bots/pull/671) —
  **`EndoRegistry` capability** + required `@registry` host name + the JS MVS
  resolver (Phase 1 of [`#659`](https://github.com/endojs/endo-but-for-bots/pull/659)'s
  plan). Green (24/24), mergeable, base `llm`. **Unblocks:** Phase 2+
  (snapshot-mapper, worker `makeFromPackage`) — the rest of the import-from-mount
  chain. _Supersession check: [`endojs/endo-but-for-bots#403`](https://github.com/endojs/endo-but-for-bots/pull/403)
  (`feat/registry-capability`, older frozen `llm-c85d618` base) is the earlier cut of
  the same capability, still open and green — confirm [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671)
  is the line to take and close [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403)
  to avoid a double review._

### 2. Scheduled execution — the `@endo/reminder` redraft (design + implementation pair)

The scheduled-execution M3 exit criterion. The original endoclaw-timer stack
([`#609`](https://github.com/endojs/endo-but-for-bots/pull/609)/[`#617`](https://github.com/endojs/endo-but-for-bots/pull/617)/[`#619`](https://github.com/endojs/endo-but-for-bots/pull/619))
was **closed** and superseded per the maintainer's redirect to an unconfined
`@endo/reminder` plugin with vfs persistence. Both halves are now green — review the
design first, then the implementation.

| Order | PR | Delivers | State | Base |
| --- | --- | --- | --- | --- |
| 1 | [`endojs/endo-but-for-bots#682`](https://github.com/endojs/endo-but-for-bots/pull/682) | design: `@endo/reminder` message-scheduler plugin | green (5/5), mergeable | `llm` |
| 2 | [`endojs/endo-but-for-bots#721`](https://github.com/endojs/endo-but-for-bots/pull/721) | `@endo/reminder` message-scheduler **plugin implementation** | green (23/23), mergeable | frozen `llm-7d0d56c` |

**Base note:** [`#721`](https://github.com/endojs/endo-but-for-bots/pull/721) is cut
from a frozen `llm-7d0d56c` snapshot; if [`#682`](https://github.com/endojs/endo-but-for-bots/pull/682)
or other `llm` work merges first it will want a rebase onto live `llm` before it
merges.

### 3. Independent green M3 capabilities (review in any order; each stands alone)

All non-draft, mergeable, and CI-green. None stacks on another, so there is no
ordering constraint among them — but see the frozen-base rebase note below.

| PR | Delivers (M3 exit criterion) | Base |
| --- | --- | --- |
| [`endojs/endo-but-for-bots#661`](https://github.com/endojs/endo-but-for-bots/pull/661) | `provideHttpClient` + `makeHttpTool` — **confined outbound HTTP** for Lal/Fae (Phase 3.6) | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#667`](https://github.com/endojs/endo-but-for-bots/pull/667) | **stdio JSONL RPC bridge** — language-agnostic agent-embedding surface | `llm` |
| [`endojs/endo-but-for-bots#669`](https://github.com/endojs/endo-but-for-bots/pull/669) | **Pi-compatible JSONL transcript** on-disk projection (`@endo/jsonl-transcript`) | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#656`](https://github.com/endojs/endo-but-for-bots/pull/656) | `provideSubMount` sub-mount primitive (daemon-mount Phase 4) | `llm` |
| [`endojs/endo-but-for-bots#658`](https://github.com/endojs/endo-but-for-bots/pull/658) | mount-path `ls`/`cat`/`write` CLI verbs (daemon-mount Phase 6) | frozen `llm-7870da1` |
| [`endojs/endo-but-for-bots#714`](https://github.com/endojs/endo-but-for-bots/pull/714) | `@endo/platform` `listTree` / `rangeRead` / `rangeReadText` primitives | `llm` |

**Frozen-base rebase note (`llm-08f5acc` cluster):** [`#661`](https://github.com/endojs/endo-but-for-bots/pull/661)
and [`#669`](https://github.com/endojs/endo-but-for-bots/pull/669) are independent
siblings cut from the same frozen snapshot `llm-08f5acc`; each merge to live `llm`
strands the other's frozen base one snapshot behind, so expect a rebase job between
merges (or batch them and let one rebase pass re-freeze the remainder).
[`#658`](https://github.com/endojs/endo-but-for-bots/pull/658) (`llm-7870da1`) and
[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656)/[`#667`](https://github.com/endojs/endo-but-for-bots/pull/667)/[`#714`](https://github.com/endojs/endo-but-for-bots/pull/714)
(live `llm`) are unaffected.

### 4. Docker self-host — two green images (one on `master`, one on `llm`)

- [`endojs/endo-but-for-bots#608`](https://github.com/endojs/endo-but-for-bots/pull/608) —
  **Docker self-hosting image** for the daemon (headless, always-on, state on a
  mounted volume). Green (15/15), mergeable, base frozen `master-eecc683`. **On the
  `master`/upstream-mirror lane** — review/merge it against `master`, not `llm`.
- [`endojs/endo-but-for-bots#694`](https://github.com/endojs/endo-but-for-bots/pull/694) —
  **Docker self-hosting image with authenticated remote gateway** (the `llm`-lane
  successor to [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608); was a
  DRAFT last snapshot, now **ready**). Green (23/23), mergeable, base frozen
  `llm-f7932ed`.

### 5. Git-capability line — newer capability, mostly green (sequence after the M3 core)

The agent-git-access line that opened last window is now largely review-ready
(non-draft, green), though it is a **newer** capability line than the maintainer-named
M3 core — sequence it after the M3 set unless the git line is a priority. Note the
**design PR that accepts the line is now conflicting** (see the blocked section), so
these implementations are running ahead of a merged acceptance.

| PR | Delivers | State | Base |
| --- | --- | --- | --- |
| [`endojs/endo-but-for-bots#705`](https://github.com/endojs/endo-but-for-bots/pull/705) | `makeGitRemoteTool` **git remote push tier** (agent-tools) | green (22/22), mergeable | `llm` |
| [`endojs/endo-but-for-bots#708`](https://github.com/endojs/endo-but-for-bots/pull/708) | `@endo/exo-git` restore content-address QID/hash | green, mergeable | frozen `llm-f7932ed` |
| [`endojs/endo-but-for-bots#706`](https://github.com/endojs/endo-but-for-bots/pull/706) | daemon **formula-owned commit-identity boundary** | green, mergeable | frozen `llm-f7932ed` |
| [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707) | capability-based workspace provisioning (Phase 3) | green, mergeable | `feat/git-commit-identity-boundary` (= [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706) head) |

**Stack note:** [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) is
stacked on [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706)'s head
branch — merge [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706) first,
then rebase [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) onto live
`llm`. [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) and
[`#708`](https://github.com/endojs/endo-but-for-bots/pull/708) are independent.

## Blocked until a predecessor moves — do NOT review in isolation yet

- [`endojs/endo-but-for-bots#670`](https://github.com/endojs/endo-but-for-bots/pull/670) —
  **subscription OAuth** (PKCE) + encrypted auth store, Lal side. `MERGEABLE` but
  merge-state **`UNSTABLE`** — CI is **still running / not yet green** (checks
  pending as of this snapshot, base `llm-05ed3ac`). Do not call it green; re-poke
  when CI settles, then it joins the independent-green set. (Its former Genie-side
  pair [`#672`](https://github.com/endojs/endo-but-for-bots/pull/672) was **closed**
  this window.)
- [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707) —
  green, but stacked on [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706);
  merge [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706) first (§ Git
  line, stack note).
- [`endojs/endo-but-for-bots#713`](https://github.com/endojs/endo-but-for-bots/pull/713) —
  `EndoMount.glorp` fused glob+grep search. Green and mergeable, but its base is a
  **feature branch** (`feat/mount-glob-delegated`) from the now-merged
  [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) delegated line, not
  live `llm` — it needs a **rebase onto `llm`** before it can advance.
- [`endojs/endo-but-for-bots#691`](https://github.com/endojs/endo-but-for-bots/pull/691) —
  design: accept-and-sequence the git-capability stack. Was mergeable last snapshot,
  now ⚠ **CONFLICTING** (DIRTY) — needs a rebase/weave before it can merge. Because
  its implementations ([`#705`](https://github.com/endojs/endo-but-for-bots/pull/705)–[`#708`](https://github.com/endojs/endo-but-for-bots/pull/708))
  are ahead of it, prioritize un-conflicting this so the line has a merged acceptance.

## Blockers of parked garden work — review to resume fleet chains

Each PR below gates a **parked garden job** (`jobs/plan/`, `gate: blocked`): the
fleet job auto-promotes to `todo/` the moment its blocker merges (for a draft:
un-draft → merge). Re-derived from **current** board state on 2026-07-13 — four
blocked plan jobs name a PR as their `blocked_on` edge (the set drifted since the
last snapshot: [`#598`](https://github.com/endojs/endo-but-for-bots/pull/598) is no
longer a draft, and [`#715`](https://github.com/endojs/endo-but-for-bots/pull/715) is
new).

| PR | Title | State | Base | Unblocks (garden job) |
| --- | --- | --- | --- | --- |
| [`endojs/endo-but-for-bots#598`](https://github.com/endojs/endo-but-for-bots/pull/598) | refactor(daemon): rename daemon.js → manager.js (phase 1: file renames) | green (22/22), mergeable, **non-draft** | `llm` | `build-daemon-rename-to-manager-phase2` → `-phase3` (2-step chain) |
| [`endojs/endo-but-for-bots#594`](https://github.com/endojs/endo-but-for-bots/pull/594) | chore(lint): lint per package to avoid the typescript-eslint project-service ceiling | green (16/16), mergeable, non-draft | `master` | `resume-lint-ceiling-shepherds` |
| [`endojs/endo-but-for-bots#676`](https://github.com/endojs/endo-but-for-bots/pull/676) | design: @endo/regexp — conservative regexp subset for JS↔Rust search parity | mergeable, **DRAFT** | `llm` | `build-endo-regexp-conservative-subset` |
| [`endojs/endo-but-for-bots#715`](https://github.com/endojs/endo-but-for-bots/pull/715) | design(inspect): @endo/inspect package + shim for portable inspection | ⚠ **CONFLICTING**, **DRAFT** | `llm` | `build-endo-inspect` |

[`#598`](https://github.com/endojs/endo-but-for-bots/pull/598) went **non-draft** this
window and is now green and mergeable — reviewing/merging its phase-1 rename unblocks a
two-step build chain (phase2 → phase3). [`#594`](https://github.com/endojs/endo-but-for-bots/pull/594)
is on the **`master`/upstream-mirror lane** (like [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608)).
[`#676`](https://github.com/endojs/endo-but-for-bots/pull/676) and
[`#715`](https://github.com/endojs/endo-but-for-bots/pull/715) are **DRAFT** designs —
each needs an un-draft (and [`#715`](https://github.com/endojs/endo-but-for-bots/pull/715)
a rebase, it is conflicting) before it can merge; each acceptance then unblocks its
build (which must confirm the design was **merged**, not merely closed, before
building). The other two blocked plan jobs (`build-daemon-rename-to-manager-phase3`,
`port-xs-to-rust-memory-safe-engine-s19`) are gated on **other jobs**, not PRs, so
they are not on this review worklist.

## Context — not for review this pass

- **Landed since the last snapshot (no longer review work):** the
  [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount search-tools
  stack ([`#678`](https://github.com/endojs/endo-but-for-bots/pull/678),
  [`#680`](https://github.com/endojs/endo-but-for-bots/pull/680),
  [`#681`](https://github.com/endojs/endo-but-for-bots/pull/681) **merged**;
  [`#679`](https://github.com/endojs/endo-but-for-bots/pull/679) **closed** with its
  content folded in), the module-loading accept-and-sequence design
  ([`#659`](https://github.com/endojs/endo-but-for-bots/pull/659) **merged**), the LLM
  edit-by-replacement tool ([`#668`](https://github.com/endojs/endo-but-for-bots/pull/668)
  **merged**), and the pi-* 0.79.9 → 0.80.3 migration
  ([`#649`](https://github.com/endojs/endo-but-for-bots/pull/649) **merged**).
- **Superseded / closed:** the endoclaw-timer scheduled-execution stack
  ([`endojs/endo-but-for-bots#609`](https://github.com/endojs/endo-but-for-bots/pull/609),
  [`#617`](https://github.com/endojs/endo-but-for-bots/pull/617),
  [`#619`](https://github.com/endojs/endo-but-for-bots/pull/619)) is now **all closed**,
  replaced by the `@endo/reminder` redraft ([`#682`](https://github.com/endojs/endo-but-for-bots/pull/682)/[`#721`](https://github.com/endojs/endo-but-for-bots/pull/721),
  § 2 above). The Genie-side OAuth pair
  [`#672`](https://github.com/endojs/endo-but-for-bots/pull/672) is **closed**.
- **Older [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount line —
  now obsolete:** [`endojs/endo-but-for-bots#655`](https://github.com/endojs/endo-but-for-bots/pull/655)
  (mount grep, "PR C") and [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657)
  (mount JSON, "PR D", stacked on [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655))
  are both still open and green, but they **predate the delegated rewrite that already
  merged** ([`#678`](https://github.com/endojs/endo-but-for-bots/pull/678)–[`#681`](https://github.com/endojs/endo-but-for-bots/pull/681)).
  Confirm the delegated line is canonical and **close [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655)/[`#657`](https://github.com/endojs/endo-but-for-bots/pull/657)**
  rather than reviewing a superseded pair.
- **Older registry cut:** [`endojs/endo-but-for-bots#403`](https://github.com/endojs/endo-but-for-bots/pull/403)
  is the earlier `EndoRegistry` capability, superseded by
  [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) (§ 1).
- **Conflicting / draft engineering (rebase/weave/build, not review):** e.g.
  [`endojs/endo-but-for-bots#607`](https://github.com/endojs/endo-but-for-bots/pull/607)
  (dependency bump, DIRTY), [`#621`](https://github.com/endojs/endo-but-for-bots/pull/621)
  (endoclaw-oauth design refine, CONFLICTING), [`#691`](https://github.com/endojs/endo-but-for-bots/pull/691)
  (git design, CONFLICTING — see blocked section), and the long tail of older
  design/feature PRs GitHub has recomputed to CONFLICTING. These are engineering work,
  not review work this pass.

## Scope note

251 PRs are open (down from 257 on 2026-07-12 — the review queue advanced this window:
the [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount stack, the
module-loading design, the edit tool, and the pi migration all merged, and the
endoclaw-timer stack was closed in favor of `@endo/reminder`). This report curates the
**M3 review bottleneck** the maintainer named — the green, mergeable, exit-criterion
capabilities plus their immediate dependency context and the garden-chain blockers.
The majority of the remainder are stale design PRs, conflicting branches, or in-flight
draft stacks (git-capability tail, sturdyref bridge, x402) that are engineering work
(rebase/weave/build), not review work, and are deliberately left out of the review
sequence above.
