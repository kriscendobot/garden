# PR-review sequence — `endojs/endo-but-for-bots` (unblock worklist)

_Snapshot: 2026-07-11. Read-only planning report (no PR comments were posted). All
refs are fully-qualified `owner/repo#N`. Target branch is `llm` (the roadmap
branch) unless noted; a few land on `master` (the upstream-mirror lane)._

## The bottleneck, in one paragraph

The fleet is **merge-bottlenecked on maintainer review**, not on engineering. M3's
exit-criterion capabilities — scheduled execution, confined outbound HTTP,
subscription OAuth, the endopi agent-embedding surface, the registry/module-loading
substrate, and the `#127` mount search tools — have already landed as **green,
CI-passing, mergeable PRs** that only a human review/merge can advance. Of the
**19 core M3 PRs** below, **18 are green and mergeable right now** (all checks
SUCCESS); the lone exception is one conflicting middle-of-stack PR that needs a
rebase. **Start with `endojs/endo-but-for-bots#678`** — it is fully green and is the
bottom of a fully-green four-PR stack (`#679`→`#680`→`#681`, all waiting only on
it), so a single review decision cascades to clear four PRs and ships the entire
`#127` mount search-tools capability. That is the highest-leverage first move on the
board.

## Review now, in this order (top clears the most downstream work)

Work top to bottom. Stacks are listed bottom-up so a predecessor merges before its
dependents; independent green PRs follow.

### 1. The `#127` mount search-tools stack — review bottom-up, all green

A clean four-PR chain, every PR non-draft and 23/23 checks green. Reviewing/merging
the bottom unblocks the three above it.

| Order | PR | Delivers | State | Base |
| --- | --- | --- | --- | --- |
| 1 | `endojs/endo-but-for-bots#678` | `@endo/platform/fs/search` glob/grep engine (layer **P**) — pushes the search engine down out of the daemon into `@endo/platform` | green, mergeable | frozen `llm-8772558` |
| 2 | `endojs/endo-but-for-bots#679` | `EndoMount.glob` delegates to the new engine (**B′**) | green, mergeable | on `#678` |
| 3 | `endojs/endo-but-for-bots#680` | `EndoMount.grep` decoupled from glob, delegating to the engine (**C′**) | green, mergeable | on `#679` |
| 4 | `endojs/endo-but-for-bots#681` | `mountGlob`/`mountGrep` agent-tools + primer (**T**) | green, mergeable | on `#680` |

**Rebase note:** each PR's base is the head of the PR below it (or a frozen `llm`
snapshot at the bottom). Merge strictly bottom-up. After `#678` merges to `llm`, a
rebase job must re-point `#679` onto live `llm` before it merges, and so on up the
stack — merge one, rebase the next, merge, repeat. Merging out of order re-freezes
the survivors.

### 2. Registry + module-loading substrate — one design + one implementation

Highest **strategic** leverage: together these accept and begin the
import-from-mount build program (Phases 1–4).

- `endojs/endo-but-for-bots#659` — **accepts and sequences** the four-layer
  module-loading stack (registry-capability, mvs-resolver, snapshot-mapper,
  daemon-worker-import-from-mount) into one dependency-ordered build plan. Green,
  mergeable, base `llm`. **Unblocks:** the entire import-from-mount build program —
  every downstream builder dispatch keys off this acceptance.
- `endojs/endo-but-for-bots#671` — **`EndoRegistry` capability** + required
  `@registry` host name + the JS MVS resolver (Phase 1 of `#659`'s plan). Green,
  mergeable, base `llm`. **Unblocks:** Phase 2+ (snapshot-mapper, worker
  `makeFromPackage`). _Supersession check: `endojs/endo-but-for-bots#403`
  (`feat/registry-capability`, older frozen `llm-c85d618` base) appears to be the
  earlier cut of the same capability — confirm `#671` is the line to take and close
  `#403` to avoid a double review._

### 3. Independent green M3 capabilities (review in any order; each stands alone)

All non-draft and CI-green. None stacks on another, so there is no ordering
constraint among them — but see the frozen-base rebase note below.

| PR | Delivers (M3 exit criterion) | Base |
| --- | --- | --- |
| `endojs/endo-but-for-bots#661` | `provideHttpClient` + `makeHttpTool` — **confined outbound HTTP** for Lal/Fae (Phase 3.6) | frozen `llm-08f5acc` |
| `endojs/endo-but-for-bots#670` | **subscription OAuth** (PKCE) + encrypted auth store — Lal side | frozen `llm-08f5acc` |
| `endojs/endo-but-for-bots#672` | **subscription OAuth** wired through Genie — the pi-ai side | frozen `llm-08f5acc` |
| `endojs/endo-but-for-bots#667` | **stdio JSONL RPC bridge** — language-agnostic agent-embedding surface | `llm` |
| `endojs/endo-but-for-bots#668` | LLM **edit-by-replacement tool** for Lal and Fae (`@endo/agentry/edit-text`) | frozen `llm-08f5acc` |
| `endojs/endo-but-for-bots#669` | **Pi-compatible JSONL transcript** on-disk projection (`@endo/jsonl-transcript`) | frozen `llm-08f5acc` |
| `endojs/endo-but-for-bots#656` | `provideSubMount` sub-mount primitive (daemon-mount Phase 4) | `llm` |
| `endojs/endo-but-for-bots#658` | mount-path `ls`/`cat`/`write` CLI verbs (daemon-mount Phase 6) | frozen `llm-7870da1` |
| `endojs/endo-but-for-bots#649` | pi-* **0.80.3 migration** (code + lockfile) — unbreaks agent-tools/agentry/genie/lal | `llm` |

**`#670` + `#672` are a pair** — the same OAuth milestone on two sides (Lal store +
Genie wiring); review them together.

**Frozen-base rebase note (`llm-08f5acc` cluster):** `#661`, `#668`, `#669`,
`#670`, `#672` are five independent siblings all cut from the same frozen snapshot
`llm-08f5acc`. They do not depend on each other, but each merge to live `llm`
strands the others' frozen base one snapshot behind. Expect a rebase job between
merges, or batch them and let one rebase pass re-freeze the remainder. `#658`
(`llm-7870da1`) and `#649`/`#656`/`#667` (live `llm`) are unaffected.

### 4. Docker self-host — green, but lands on `master`, not `llm`

- `endojs/endo-but-for-bots#608` — **Docker self-hosting image** for the daemon
  (headless, always-on, state on a mounted volume). Green (15/15), mergeable, base
  is frozen `master-eecc683`. **Note:** this is on the **`master`/upstream-mirror
  lane**, not `llm` — review/merge it against `master`, not the roadmap branch.

## Blocked until a predecessor moves — do NOT review in isolation yet

### endoclaw-timer stack (scheduled-execution exit criterion) — broken in the middle

A true three-PR stack whose Phase-2 middle currently **conflicts**, so the green top
cannot advance until it is rebased.

| Order | PR | State | Note |
| --- | --- | --- | --- |
| 1 | `endojs/endo-but-for-bots#609` | mergeable, green (24/24) | Phase 1 — interval-scheduler formula. **Bottom of stack; review this first.** |
| 2 | `endojs/endo-but-for-bots#617` | ⚠ **CONFLICTING** (DIRTY) | Phase 2 — deliver interval ticks. **Needs a rebase/weave before it can advance**; it is the gate for Phase 3. |
| 3 | `endojs/endo-but-for-bots#619` | green (23/23), but stacked on `#617` | Phase 3 — startup recovery. Cannot merge until `#617` is un-conflicted and merged. |

**Action:** review `#609` now; post a `rebase #617` (weave) so the middle
un-conflicts, then `#617`→`#619` become a normal bottom-up merge.

## Context — not for review this pass

- **Conflicting (need a rebase/weave before review):** e.g.
  `endojs/endo-but-for-bots#604`, `#603`, `#585`, `#572`, `#399`, `#398`, `#357`,
  and the gateway-package phase stack (`#392`–`#420`, deep draft chain). These are
  DIRTY/CONFLICTING and are engineering work, not review work.
- **Mergeability not yet computed (UNKNOWN — stale, need a poke):** a long tail of
  older design/feature PRs (`#101`–`#249` range, plus `#129`/`#132`/`#135`/`#138`
  /`#151`/`#152`/`#160`/`#165`/`#166`/`#179`/`#216`/`#224`/`#231`/`#234`/`#237`
  /`#238`/`#241`/`#242`). GitHub has not recomputed their merge state; they are not
  part of the M3 green-and-waiting set.
- **Older `#127` mount line:** `endojs/endo-but-for-bots#655` (mount grep, "PR C"),
  `#657` (mount JSON, "PR D", stacked on `#655`), and `#135` (mount Phase 4) predate
  the delegated `#678`–`#681` rewrite. **Confirm which `#127` line is canonical**
  before reviewing both — the delegated stack (`#678`–`#681`) reads as the current
  one.

## Scope note

240 PRs are open. This report curates the **M3 review bottleneck** the maintainer
named — the green, mergeable, exit-criterion capabilities plus their immediate
dependency context. There are ~75 non-conflicting PRs rooting to `llm` in total;
the majority of the remainder are stale design PRs or conflicting branches that are
engineering work (rebase/weave), not review work, and are deliberately left out of
the review sequence above.
