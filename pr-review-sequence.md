# PR-review sequence — `endojs/endo-but-for-bots` (unblock worklist)

_Snapshot: 2026-07-12. Read-only planning report (no PR comments were posted). All
refs are fully-qualified `owner/repo#N`. Target branch is `llm` (the roadmap
branch) unless noted; a few land on `master` (the upstream-mirror lane)._

## The bottleneck, in one paragraph

The fleet is **merge-bottlenecked on maintainer review**, not on engineering. M3's
exit-criterion capabilities — scheduled execution, confined outbound HTTP,
subscription OAuth, the endopi agent-embedding surface, the registry/module-loading
substrate, and the [`endojs/endo-but-for-bots#127`](https://github.com/endojs/endo-but-for-bots/issues/127)
mount search tools — have already landed as **green, CI-passing, mergeable PRs**
that only a human review/merge can advance. Nothing from the 2026-07-11 snapshot
merged in the intervening day: the same **~19 core M3 PRs** are still open and
waiting, **18 of them green and mergeable right now** (all checks SUCCESS); the lone
exception is one conflicting middle-of-stack PR that still needs a rebase.
**Start with [`endojs/endo-but-for-bots#678`](https://github.com/endojs/endo-but-for-bots/pull/678)** —
it is fully green and is the bottom of a fully-green four-PR stack
([`#679`](https://github.com/endojs/endo-but-for-bots/pull/679)→[`#680`](https://github.com/endojs/endo-but-for-bots/pull/680)→[`#681`](https://github.com/endojs/endo-but-for-bots/pull/681),
all waiting only on it), so a single review decision cascades to clear four PRs and
ships the entire [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount
search-tools capability. That is the highest-leverage first move on the board.

## Review now, in this order (top clears the most downstream work)

Work top to bottom. Stacks are listed bottom-up so a predecessor merges before its
dependents; independent green PRs follow. Every PR below was re-checked live on
2026-07-12: non-draft, `mergeable = MERGEABLE`, all CI checks SUCCESS.

### 1. The [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount search-tools stack — review bottom-up, all green

A clean four-PR chain, every PR non-draft and 23/23 checks green. Reviewing/merging
the bottom unblocks the three above it.

| Order | PR | Delivers | State | Base |
| --- | --- | --- | --- | --- |
| 1 | [`endojs/endo-but-for-bots#678`](https://github.com/endojs/endo-but-for-bots/pull/678) | `@endo/platform/fs/search` glob/grep engine (layer **P**) — pushes the search engine down out of the daemon into `@endo/platform` | green, mergeable | frozen `llm-8772558` |
| 2 | [`endojs/endo-but-for-bots#679`](https://github.com/endojs/endo-but-for-bots/pull/679) | `EndoMount.glob` delegates to the new engine (**B′**) | green, mergeable | `feat/platform-search` (= [`#678`](https://github.com/endojs/endo-but-for-bots/pull/678) head) |
| 3 | [`endojs/endo-but-for-bots#680`](https://github.com/endojs/endo-but-for-bots/pull/680) | `EndoMount.grep` decoupled from glob, delegating to the engine (**C′**) | green, mergeable | `feat/mount-glob-delegated` (= [`#679`](https://github.com/endojs/endo-but-for-bots/pull/679) head) |
| 4 | [`endojs/endo-but-for-bots#681`](https://github.com/endojs/endo-but-for-bots/pull/681) | `mountGlob`/`mountGrep` agent-tools + primer (**T**) | green, mergeable | `feat/mount-grep-delegated` (= [`#680`](https://github.com/endojs/endo-but-for-bots/pull/680) head) |

**Rebase note:** each PR's base is the head of the PR below it (or a frozen `llm`
snapshot at the bottom). Merge strictly bottom-up. After [`#678`](https://github.com/endojs/endo-but-for-bots/pull/678)
merges to `llm`, a rebase job must re-point [`#679`](https://github.com/endojs/endo-but-for-bots/pull/679)
onto live `llm` before it merges, and so on up the stack — merge one, rebase the
next, merge, repeat. Merging out of order re-freezes the survivors.

### 2. Registry + module-loading substrate — one design + one implementation

Highest **strategic** leverage: together these accept and begin the
import-from-mount build program (Phases 1–4).

- [`endojs/endo-but-for-bots#659`](https://github.com/endojs/endo-but-for-bots/pull/659) — **accepts and sequences** the four-layer
  module-loading stack (registry-capability, mvs-resolver, snapshot-mapper,
  daemon-worker-import-from-mount) into one dependency-ordered build plan. Green
  (5/5), mergeable, base `llm`. **Unblocks:** the entire import-from-mount build
  program — every downstream builder dispatch keys off this acceptance.
- [`endojs/endo-but-for-bots#671`](https://github.com/endojs/endo-but-for-bots/pull/671) — **`EndoRegistry` capability** + required
  `@registry` host name + the JS MVS resolver (Phase 1 of [`#659`](https://github.com/endojs/endo-but-for-bots/pull/659)'s plan). Green
  (24/24), mergeable, base `llm`. **Unblocks:** Phase 2+ (snapshot-mapper, worker
  `makeFromPackage`). _Supersession check: [`endojs/endo-but-for-bots#403`](https://github.com/endojs/endo-but-for-bots/pull/403)
  (`feat/registry-capability`, older frozen `llm-c85d618` base) is the earlier cut
  of the same capability and is still open/green — confirm [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) is the line to
  take and close [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) to avoid a double review._

### 3. Independent green M3 capabilities (review in any order; each stands alone)

All non-draft and CI-green. None stacks on another, so there is no ordering
constraint among them — but see the frozen-base rebase note below.

| PR | Delivers (M3 exit criterion) | Base |
| --- | --- | --- |
| [`endojs/endo-but-for-bots#661`](https://github.com/endojs/endo-but-for-bots/pull/661) | `provideHttpClient` + `makeHttpTool` — **confined outbound HTTP** for Lal/Fae (Phase 3.6) | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#670`](https://github.com/endojs/endo-but-for-bots/pull/670) | **subscription OAuth** (PKCE) + encrypted auth store — Lal side | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#672`](https://github.com/endojs/endo-but-for-bots/pull/672) | **subscription OAuth** wired through Genie — the pi-ai side | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#667`](https://github.com/endojs/endo-but-for-bots/pull/667) | **stdio JSONL RPC bridge** — language-agnostic agent-embedding surface | `llm` |
| [`endojs/endo-but-for-bots#668`](https://github.com/endojs/endo-but-for-bots/pull/668) | LLM **edit-by-replacement tool** for Lal and Fae (`@endo/agentry/edit-text`) | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#669`](https://github.com/endojs/endo-but-for-bots/pull/669) | **Pi-compatible JSONL transcript** on-disk projection (`@endo/jsonl-transcript`) | frozen `llm-08f5acc` |
| [`endojs/endo-but-for-bots#656`](https://github.com/endojs/endo-but-for-bots/pull/656) | `provideSubMount` sub-mount primitive (daemon-mount Phase 4) | `llm` |
| [`endojs/endo-but-for-bots#658`](https://github.com/endojs/endo-but-for-bots/pull/658) | mount-path `ls`/`cat`/`write` CLI verbs (daemon-mount Phase 6) | frozen `llm-7870da1` |
| [`endojs/endo-but-for-bots#649`](https://github.com/endojs/endo-but-for-bots/pull/649) | pi-* 0.79.9 → **0.80.3 migration** (code + lockfile) — unbreaks agent-tools/agentry/genie/lal | `llm` |

**[`#670`](https://github.com/endojs/endo-but-for-bots/pull/670) + [`#672`](https://github.com/endojs/endo-but-for-bots/pull/672) are a pair** — the same OAuth milestone on two sides (Lal store +
Genie wiring); review them together.

**Frozen-base rebase note (`llm-08f5acc` cluster):** [`#661`](https://github.com/endojs/endo-but-for-bots/pull/661), [`#668`](https://github.com/endojs/endo-but-for-bots/pull/668), [`#669`](https://github.com/endojs/endo-but-for-bots/pull/669),
[`#670`](https://github.com/endojs/endo-but-for-bots/pull/670), [`#672`](https://github.com/endojs/endo-but-for-bots/pull/672) are five independent siblings all cut from the same frozen snapshot
`llm-08f5acc`. They do not depend on each other, but each merge to live `llm`
strands the others' frozen base one snapshot behind. Expect a rebase job between
merges, or batch them and let one rebase pass re-freeze the remainder. [`#658`](https://github.com/endojs/endo-but-for-bots/pull/658)
(`llm-7870da1`) and [`#649`](https://github.com/endojs/endo-but-for-bots/pull/649)/[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656)/[`#667`](https://github.com/endojs/endo-but-for-bots/pull/667) (live `llm`) are unaffected.

### 4. Docker self-host — green, but lands on `master`, not `llm`

- [`endojs/endo-but-for-bots#608`](https://github.com/endojs/endo-but-for-bots/pull/608) — **Docker self-hosting image** for the daemon
  (headless, always-on, state on a mounted volume). Green (15/15), mergeable, base
  is frozen `master-eecc683`. **Note:** this is on the **`master`/upstream-mirror
  lane**, not `llm` — review/merge it against `master`, not the roadmap branch. (An
  authenticated-remote successor, [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694),
  is still a DRAFT on `llm-f7932ed` — see the context section.)

### 5. Newly-arrived ready PRs since the last snapshot (git-capability line)

Two non-M3 PRs opened/readied on `llm` since 2026-07-11 that are already
non-draft, green, and mergeable — genuinely review-ready, though they open a
**newer** capability line (agent git access) rather than the maintainer-named M3
core. Sequence them after the M3 set unless the git line is a priority.

| PR | Delivers | State | Base |
| --- | --- | --- | --- |
| [`endojs/endo-but-for-bots#691`](https://github.com/endojs/endo-but-for-bots/pull/691) | design: **accept and sequence the git-capability stack** | green (5/5), mergeable, non-draft | `llm` |
| [`endojs/endo-but-for-bots#705`](https://github.com/endojs/endo-but-for-bots/pull/705) | `makeGitRemote` **git remote push tier** (agent-tools) | green (22/22), mergeable, non-draft | `llm` |

The rest of the git / sturdyref / x402 work opened this window (
[`#697`](https://github.com/endojs/endo-but-for-bots/pull/697)–[`#709`](https://github.com/endojs/endo-but-for-bots/pull/709))
is still a **DRAFT** stack in flight — engineering, not review work this pass.

## Blocked until a predecessor moves — do NOT review in isolation yet

### endoclaw-timer stack (scheduled-execution exit criterion) — still broken in the middle

A true three-PR stack whose Phase-2 middle currently **conflicts**, so the green top
cannot advance until it is rebased. Unchanged from the 2026-07-11 snapshot.

| Order | PR | State | Note |
| --- | --- | --- | --- |
| 1 | [`endojs/endo-but-for-bots#609`](https://github.com/endojs/endo-but-for-bots/pull/609) | mergeable, green (24/24) | Phase 1 — interval-scheduler formula. **Bottom of stack; review this first.** |
| 2 | [`endojs/endo-but-for-bots#617`](https://github.com/endojs/endo-but-for-bots/pull/617) | ⚠ **CONFLICTING** (DIRTY); last CI run green (23/23) | Phase 2 — deliver interval ticks. **Needs a rebase/weave before it can advance**; it is the gate for Phase 3. |
| 3 | [`endojs/endo-but-for-bots#619`](https://github.com/endojs/endo-but-for-bots/pull/619) | green (23/23), but stacked on [`#617`](https://github.com/endojs/endo-but-for-bots/pull/617) | Phase 3 — startup recovery. Cannot merge until [`#617`](https://github.com/endojs/endo-but-for-bots/pull/617) is un-conflicted and merged. |

**Action:** review [`#609`](https://github.com/endojs/endo-but-for-bots/pull/609) now; post a `rebase #617` (weave) so the middle
un-conflicts, then [`#617`](https://github.com/endojs/endo-but-for-bots/pull/617)→[`#619`](https://github.com/endojs/endo-but-for-bots/pull/619) become a normal bottom-up merge.

## Blockers of parked garden work — review to resume fleet chains

Each PR below gates a **parked garden job** (`jobs/plan/`, `gate: blocked`): the
fleet job auto-promotes to `todo/` the moment its blocker merges (for a draft:
un-draft → merge). Re-derived from current board state on 2026-07-12 — three
blocked plan jobs name a PR as their `blocked_on` edge.

| PR | Title | State | Base | Unblocks (garden job) |
| --- | --- | --- | --- | --- |
| [`endojs/endo-but-for-bots#594`](https://github.com/endojs/endo-but-for-bots/pull/594) | chore(lint): lint per package to avoid the typescript-eslint project-service ceiling | green (16/16), mergeable, non-draft | `master` | `resume-lint-ceiling-shepherds` |
| [`endojs/endo-but-for-bots#598`](https://github.com/endojs/endo-but-for-bots/pull/598) | refactor(daemon): rename daemon.js → manager.js (phase 1: file renames) | mergeable, **DRAFT** | `llm` | `build-daemon-rename-to-manager-phase2` → `-phase3` (2-step chain) |
| [`endojs/endo-but-for-bots#676`](https://github.com/endojs/endo-but-for-bots/pull/676) | design: @endo/regexp — conservative regexp subset for JS↔Rust search parity | mergeable, **DRAFT** | `llm` | `build-endo-regexp-conservative-subset` |

[`#594`](https://github.com/endojs/endo-but-for-bots/pull/594) is on the **`master`/upstream-mirror lane** (like [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608)), not `llm`. [`#598`](https://github.com/endojs/endo-but-for-bots/pull/598)
and [`#676`](https://github.com/endojs/endo-but-for-bots/pull/676) are **DRAFT** — each needs an un-draft before it can merge; [`#598`](https://github.com/endojs/endo-but-for-bots/pull/598)'s
phase-1 rename then unblocks a two-step build chain (phase2 → phase3), and
[`#676`](https://github.com/endojs/endo-but-for-bots/pull/676)'s acceptance unblocks the `@endo/regexp` build (which must confirm the design
was **merged**, not merely closed, before building). The two remaining blocked plan
jobs (`build-daemon-rename-to-manager-phase3`, `port-xs-to-rust-memory-safe-engine-s19`)
are gated on **other jobs**, not PRs, so they are not on this review worklist.

## Context — not for review this pass

- **Conflicting (need a rebase/weave before review):** e.g.
  [`endojs/endo-but-for-bots#604`](https://github.com/endojs/endo-but-for-bots/pull/604), [`#603`](https://github.com/endojs/endo-but-for-bots/pull/603), [`#585`](https://github.com/endojs/endo-but-for-bots/pull/585), [`#572`](https://github.com/endojs/endo-but-for-bots/pull/572), [`#399`](https://github.com/endojs/endo-but-for-bots/pull/399), [`#398`](https://github.com/endojs/endo-but-for-bots/pull/398), [`#357`](https://github.com/endojs/endo-but-for-bots/pull/357),
  and the gateway-package phase stack ([`#392`](https://github.com/endojs/endo-but-for-bots/pull/392)–[`#420`](https://github.com/endojs/endo-but-for-bots/pull/420), deep draft chain). These are
  DIRTY/CONFLICTING and are engineering work, not review work.
- **The old stale-UNKNOWN tail has now recomputed — mostly to CONFLICTING.** The
  long tail of older design/feature PRs that GitHub had not computed a merge state
  for on 2026-07-11 has since been recomputed: spot checks show
  [`#129`](https://github.com/endojs/endo-but-for-bots/pull/129), [`#132`](https://github.com/endojs/endo-but-for-bots/pull/132), [`#135`](https://github.com/endojs/endo-but-for-bots/pull/135), [`#249`](https://github.com/endojs/endo-but-for-bots/pull/249)
  are now **CONFLICTING** (rebase/weave work, not review), and a few (e.g.
  [`#216`](https://github.com/endojs/endo-but-for-bots/pull/216)) are MERGEABLE but are not M3 exit-criterion capabilities — not part of the
  green-and-waiting M3 set curated above.
- **Older [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) mount line:** [`endojs/endo-but-for-bots#655`](https://github.com/endojs/endo-but-for-bots/pull/655) (mount grep, "PR C"),
  [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) (mount JSON, "PR D", stacked on [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655)) predate the delegated
  [`#678`](https://github.com/endojs/endo-but-for-bots/pull/678)–[`#681`](https://github.com/endojs/endo-but-for-bots/pull/681) rewrite. Both are now green and mergeable, but **confirm which
  [`#127`](https://github.com/endojs/endo-but-for-bots/issues/127) line is canonical** before reviewing both — the delegated stack
  ([`#678`](https://github.com/endojs/endo-but-for-bots/pull/678)–[`#681`](https://github.com/endojs/endo-but-for-bots/pull/681)) reads as the current one, and reviewing the older pair would be
  duplicated effort.

## Scope note

257 PRs are open (up from 240 on 2026-07-11 — a day of new draft build/design
stacks: git-capability, sturdyref bridge, x402, none of it review-ready yet). This
report curates the **M3 review bottleneck** the maintainer named — the green,
mergeable, exit-criterion capabilities plus their immediate dependency context and
the garden-chain blockers. The majority of the remainder are stale design PRs,
conflicting branches, or in-flight draft stacks that are engineering work
(rebase/weave/build), not review work, and are deliberately left out of the review
sequence above.
