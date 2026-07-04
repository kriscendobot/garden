---
created: 2026-07-04
updated: 2026-07-04
author: designer (job design-streamlined-onboarding)
---

# Streamlined onboarding: clone → `./garden` → "help"

Collapse the new-user path to three manual actions — clone the repo on a
Docker-capable host, run `./garden`, and type **help** — by making the launcher
drop the user straight into an interactive Claude Code liaison session in auto
mode, and by moving every step Claude can perform on the user's behalf out of
`README.md` into (a) a liaison-driven interactive tutorial triggered by the
**help** verb and (b) a new on-demand, agent-oriented **`context/`** tree on
`main2`, authored under the [context-library](../skills/context-library/SKILL.md)
discipline. The governing test, from the maintainer's directive:

> The README.md should not cover *any* detail that Claude can readily and
> easily do on behalf of the user.

This design specifies the golden path end to end, the `help`-verb tutorial, the
`context/` tree's shape and boundaries, and the concrete migration map out of
`README.md` and `CLAUDE.md § Job system`. It changes no behavior itself;
implementation is phased into build jobs (§ Implementation phases).

## 1. The golden path

The entire operational README becomes:

1. **Clone** the garden on a system that runs Docker, and `cd` into it.
2. **Run `./garden`.** The launcher builds the image if absent, creates or
   starts the container, and drops you **directly into Claude Code** — the
   liaison — running in auto mode. First-run interstitials (Claude login, the
   one-time auto-mode acknowledgment) happen here, prompted by the tools
   themselves, not by README instructions.
3. **Say `help`.** The liaison runs the interactive first-run tutorial (§ 2):
   it checks identity, authenticates the bot, brings up the fleet, arms the
   monitors, and posts your first job — asking before each step and running
   the commands itself.

What remains on the human side that no agent can do: having Docker, having a
Claude subscription (or API key), owning a bot GitHub account, and clicking
through the browser halves of the OAuth/device flows. Those are the README's
residue (§ 4).

### 1.1 Launcher changes (`./garden`)

`cmd_enter` gains three behaviors, all at the launcher layer (host-side), none
in the image:

- **Auto-build.** If the image is missing, run `cmd_build` instead of erroring
  ("run `garden build` first" disappears from the human's path; `./garden
  build` remains for explicit rebuilds).
- **Seed `.claude/settings.json` at creation, exactly like `.garden`.** The
  container guard section of CLAUDE.md records the gap: `.claude/settings.json`
  is gitignored (the top-level `/.[!.]*` rule) and the image cannot seed it
  because the bind mount masks anything written under `$HOME`. But the
  **launcher** runs host-side with `SCRIPT_DIR` = the garden root = the future
  bind-mounted home, and it already seeds the gitignored `.garden` file there
  at creation. The same move seeds `.claude/settings.json` (only when absent,
  so a hand-edited file is preserved) with:
  - a **SessionStart hook** running `scripts/check-in-container.sh`, making
    the container guard automatic for every session that starts in the garden
    root — including a host-side session, which is precisely where the guard
    must fire. CLAUDE.md § Container guard stops being the sole propagating
    vehicle; the prose preflight remains as belt to this suspenders.
  - nothing else by default; in particular **not** a permission
    `defaultMode` — see § 1.3 for why auto mode rides the launch flag, not
    the settings file.

  A note on an amusing coincidence this exploits: because the container's home
  *is* the repo root, the user-level `~/.claude/settings.json` and the
  project-level `<repo>/.claude/settings.json` are the same file. The seed
  therefore covers both scopes at once.
- **Exec `claude` on enter.** The interactive entry becomes

  ```sh
  exec docker exec -it -u kris "$CONTAINER_NAME" \
      /bin/bash -lc 'exec claude --dangerously-skip-permissions'
  ```

  `bash -l` loads `/etc/profile.d/garden.sh` (PATH), then `exec` replaces the
  shell with `claude` as the foreground process on the allocated tty. A new
  subcommand **`./garden shell`** preserves the debugging escape hatch: it is
  today's behavior verbatim (`/bin/bash -l`, no claude). `./garden claude`
  could alias the default for symmetry but is not required.

### 1.2 `exec claude` placement: the enter wrapper, not the image

The container's `CMD` stays `/lib/systemd/systemd` and the entrypoint stays
untouched. Reasons, resolving the open question:

- **PID 1 must remain systemd** for the `garden-*` user units; an image-level
  `CMD ["claude"]` would fight that outright.
- **`docker exec` is per-entry, not per-container.** Putting the interactive
  process in the enter wrapper means every `./garden` invocation gets a fresh
  foreground `claude`, re-entry after exit is trivially the same command, and
  two terminals get two independent sessions while systemd keeps the fleet
  alive underneath. (Two simultaneous liaison sessions on the leader host must
  still not both arm the maintainer-inbox Monitor — the existing singleton
  norm in `roles/liaison/AGENT.md` already governs this; the tutorial and
  CLAUDE.md preflight should repeat it in one line.)
- **Exiting claude exits the exec**, returning the user to their host shell —
  the container and fleet keep running. `./garden` re-enters.

### 1.3 Auto mode: what it concretely is, and its blast radius

"Auto mode" is realized as the **launch flag** `--dangerously-skip-permissions`
(equivalently `--permission-mode bypassPermissions`) on the exec'd interactive
session — not as a seeded `defaultMode` in settings. The distinction matters:
the settings file is visible on the host too (same bind-mounted path), so a
settings-level default would silently make *host-side* sessions — the exact
sessions the container guard exists to catch — run permissionless as the
maintainer's identity. The flag, by construction, applies only to the session
the enter wrapper launches inside the container.

Blast-radius analysis (open question, surfaced with a recommendation):

- The **ceiling is already set by the fleet.** Every headless handler
  (`gardener-claude.sh` and peers) runs `claude -p
  --dangerously-skip-permissions` in the same container, under the same unix
  user, with the same bot `gh`/ssh credentials, unattended. An interactive
  bypass session with a human watching is strictly *less* exposed than what
  runs a hundred times a day already.
- The boundary that actually contains both is the **container plus the bot
  identity**: the launcher forwards no SSH agent, the `gh` wrapper pins the
  bot login, the maintainer's credentials are absent on a bot host, and the
  ferry's `identity_switch_authorized` gate governs the one path that lands
  work as a human.
- The residual risk is not harness-shaped but behavior-shaped: a brand-new
  user's liaison could push, post, or comment as the bot without a
  confirmation stop. That is governed where it is today — the liaison's role
  norms (ask before outward-facing acts; the tutorial's ask-before-acting
  contract, § 2.3) — rather than by permission prompts that the tutorial
  would otherwise turn into dozens of nags.

**Recommendation:** bypass is the default launch mode (it is what "auto mode"
asks for, and the tutorial is unusable under prompt-per-command); the
conservative alternative — `--permission-mode acceptEdits` plus a seeded
allowlist for `scripts/jobs/*` — is documented in
`context/first-run/auth.md` for a user who wants prompts, reachable via
`./garden shell` + a hand-launched `claude`. Claude Code's own one-time
bypass acknowledgment (a single keystroke on first launch) is the explicit
opt-in moment and stays; the README does not document it because the tool
prompts for it. **Maintainer decision requested** on this default (§ 5, Q2).

### 1.4 First-run auth with fewest commands

Resolving the open question: auth adds **zero numbered steps** because it
lives *inside* step 2, prompted by the tools themselves.

- **Claude auth.** A fresh clone has no credential. The exec'd `claude` runs
  its own first-launch onboarding: pick a login method, open the printed URL
  in a browser (on the host — the container has none), paste the code back.
  The credential lands in the bind-mounted home and persists across `./garden
  reset`. The subscription login remains the beaten path; exporting
  `ANTHROPIC_API_KEY` before the *first* `./garden` (the launcher already
  forwards it at container creation) is the alternate path that skips the
  login entirely. Neither is a README procedure; both are one sentence of
  README residue ("have a Claude subscription or an API key").
- **Bot GitHub auth** moves *after* the human is inside the liaison, as a
  tutorial stage (§ 2.2 stage 3): the liaison generates the bot's ssh key,
  prints the public half for the human to paste into the bot account, runs
  `gh auth login` and hands the device-flow URL/code to the human. The two
  genuinely human moments (owning the bot account; clicking "add key" /
  "authorize" in a browser) are the irreducible residue.

## 2. The `help` verb → interactive onboarding tutorial

### 2.1 Trigger mechanics

`help` becomes first-class vocabulary, recognized in imperative/solo position
like the branch-op verbs — but it is **liaison-session vocabulary only**, never
a job the comment watchers recognize (a tutorial is a conversation, not a
board entry). Wiring, resolving the open question by doing both halves:

- **CLAUDE.md**: one row in the § Orchestrator vocabulary table (*help* /
  *help &lt;topic&gt;* → run the onboarding tutorial / answer from `context/`),
  and one sentence appended to the session preflight: after
  `check-in-container.sh`, if the instance looks **virgin** (no rendered
  `garden-*` units in `~/.config/systemd/user/`), greet with "this garden
  isn't set up yet — say **help** and I'll walk you through it." The probe is
  one `ls`; the preflight stays cheap. Order is fixed: guard first (a
  host-side "help" must be answered with the guard warning and `./garden`,
  not with a tutorial that would arm the wrong fleet), virgin-probe second.
- **`roles/liaison/AGENT.md`**: a new § Help (vocabulary) section defining the
  two forms — bare **help** (run the tutorial track, § 2.2) and **help
  &lt;topic&gt;** (walk `context/` per its routing README and answer; offer to
  *do* whatever the answer prescribes). The seeded SessionStart hook (§ 1.1)
  makes the guard automatic even before CLAUDE.md is read, so the two
  preflight vehicles reconcile rather than compete.

Collision note: `/help` (the CLI built-in) is untouched; bare `help` typed as
a message is the verb. A `help` embedded mid-sentence in other work is not in
imperative position and does not fire, same convention as the branch-op verbs.

### 2.2 The tutorial track

Bare **help** on a not-yet-armed instance runs the first-run track. The track
*is* `context/first-run/` (§ 3): the liaison reads
`context/first-run/README.md` and drives its stages in order, reading each
stage's page just-in-time. There is deliberately **no separate tutorial
script** to drift from the documentation — the ordered tree is the single
source of truth, and the interaction norms live in its README. Stages:

1. **Welcome.** One paragraph on what the garden is and what the tutorial
   will do, ending with "shall we?".
2. **Identity.** Confirm we are in-container (guard already ran); read
   `.garden`; ask the one question only the human can answer — "is this name
   unique among your running garden instances?" — and on collision offer the
   rename/parallel-pool moves (`./garden reset` + `GARDEN_CONTAINER=…`, or
   `GARDEN=<unique>`), running them on approval.
3. **Bot credentials.** Check `gh auth status` and `.ssh/`. Missing pieces:
   generate the key, print the public half and wait while the human adds it
   to the **bot** account, run `gh auth login` and relay the device code.
   Verify by whoami-ing the wrapper.
4. **Fleet bring-up.** `loginctl enable-linger`, `install-units.sh install` +
   `enable-services`, `set-gardeners.sh <N>` (default 100, explaining that
   idle-blocked workers are cheap), `set-main-host.sh <this>` on a first/only
   host. Verify: no failed `garden-*` units.
5. **Arm the liaison's own monitors.** Leader-marker watch (every host),
   maintainer-inbox Monitor + deploy-on-upgrade Monitor (leader only) — the
   liaison arms these in its own session and explains what each will surface.
6. **Optional armings.** Issue inbox (`set-garden-repo.sh` +
   `add-maintainer.sh` — explaining this is the deliberate arming act) and
   the bulletin PAT (human-only clicks; hand over
   `docs/bulletin/SETUP.md` and offer to verify the result).
7. **First job.** Offer to post a small real job, watch it cross
   `todo/ → doin/ → tada/`, and read the report back — teaching the board's
   shape and the core verbs (*design*, *build*, *run the gauntlet*, *defer*,
   *promote*) with the vocabulary table as reference.
8. **Where to go next.** `help <topic>`, the control surfaces, and the
   README's conceptual §§ 2–3 for the architecture tour.

On an **already-armed** instance, bare `help` skips to a status summary
(units, board counts, leadership, drain state) plus the topic menu — the
track's pages double as the topic answers, so nothing is written twice.

### 2.3 Interaction norms

Recorded in `context/first-run/README.md`, binding on the liaison driving it:

- **Ask before acting, act on approval.** Every mutating step is proposed in
  one sentence with the exact command shown, then run by the liaison itself on
  a yes — never printed for the human to copy. Read-only checks run freely.
- **Verify after each stage** (a unit list, a `gh auth status`, a board
  read) and show the one-line result, so trust accumulates stage by stage.
- **Resumable and idempotent.** Every stage begins with its own probe and
  skips cleanly when already done, so `help` after a half-finished first run
  continues where it left off, and `help` on a healthy instance degenerates
  to the status summary.
- **Escalate, don't improvise, on policy.** Stages that touch permissioned
  surfaces (watch-set widening, ferry, identity) are described but never
  performed in the tutorial; they route to the maintainer-authorization
  paths that govern them.

## 3. The `context/` tree

A new top-level tree on `main2`: the garden's **operations manual for
agents**, read on demand by the liaison to drive the tutorial and to answer
`help <topic>` — never auto-loaded. It is authored under the
[context-library](../skills/context-library/SKILL.md) discipline (abstracts
first, directory READMEs as routing contracts, many small files, descend only
when an abstract justifies it, cross-link rather than duplicate). That skill
today declares itself canonical for journal trees; implementation amends its
scope line to cover `context/` as a second canonical tree (same discipline,
different branch), rather than forking the discipline.

### 3.1 Boundary against the neighboring trees

| Tree | Branch | Holds | Does not hold |
| --- | --- | --- | --- |
| **`context/`** (new) | `main2` | How to operate *any* garden instance: bring-up, identity, auth, scaling, leadership, deploy, schedules, health. Ships with the code, so procedure and script version together. | Per-instance state or history; architectural rationale; imported material; procedures already encoded as skills (it routes to them). |
| `designs/` | `main2` | Why the machinery is shaped as it is — decision records. | Operator procedure. A context page links a design for rationale; a design links context for the how-to. |
| `references/` | `main2` | Imported shelves from other gardens, browsed only by the liaison when nothing local fits. | Anything of ours. |
| journal `library/` | `journal2` | Per-instance digested external sources plus the instance's transcript, plan, and board. | Garden-operation procedure — that would strand the how-to on one instance and desync it from the scripts it describes. |
| `roles/`, `skills/` | `main2` | Doer-organized briefs and playbooks, loaded by the worker whose job names them. | Operator narrative. Where a skill encodes a procedure (restore, schedule, job-board), the context page **routes to it** and adds only the operator's framing. |
| `README.md`, `CLAUDE.md` | `main2` | Auto-loaded / human-first orientation: the pitch, the three steps, concepts, the liaison's dispatch contract. | Operational command detail — that is exactly what moves out (§ 4). |

Confirming the open question: **shipped-with-code operational detail lives in
exactly one place, `context/` on `main2`**; the journal library stays
per-instance. Each operational topic gets one home; every other tree
cross-links it. Cross-references within `context/` are relative; across trees
they are repo-root paths, per the skill.

### 3.2 Shape: index and initial fragments

```
context/
  README.md                     routing index: what this tree is, who reads it
                                (the liaison, on demand), and the two children.
  first-run/
    README.md                   the tutorial track: ordered stage list with
                                one-line abstracts, plus the interaction norms
                                (§ 2.3). Bare "help" starts here.
    identity.md                 the GARDEN shard identity: .garden seeding,
                                uniqueness check, rename and parallel-pool
                                moves, why env vars don't reach user units.
    auth.md                     the three credentials (claude login / API key,
                                bot ssh key, bot gh token): probes, the
                                liaison-run halves, the human-only clicks;
                                the conservative non-bypass launch variant.
    fleet.md                    linger, install-units, enable-services,
                                set-gardeners; what a healthy pool looks like.
    leader.md                   set-main-host on a first host; what the leader
                                marker gates (one-paragraph view, routes to
                                operations/leader-follower.md for multi-host).
    monitors.md                 the liaison's three Monitors — leader-marker
                                watch (every host), maintainer inbox and
                                deploy-on-upgrade (leader only) — commands,
                                singleton rules, what each surfaces.
    inboxes.md                  optional armings: issue inbox (repo +
                                maintainer allowlist as the arming act),
                                bulletin PAT (routes to docs/bulletin/SETUP.md).
    first-job.md                posting a first job; the board's states; the
                                core verbs with pointers to the vocabulary.
  operations/
    README.md                   day-2 routing: pick by symptom or intent.
    leader-follower.md          multi-host: marker semantics, follower
                                stand-up, the drain→stand-down→re-point
                                handoff, no automatic failover.
    scaling.md                  sizing the pool, set-gardeners per host,
                                drain on/off and when to prefer which.
    deploy.md                   the deliberate deploy: upgrade-ready signal,
                                deploy-garden.sh, what the root checkout is.
    schedules.md                recurring and one-shot schedules (routes to
                                skills/schedule).
    health.md                   failed units, the restore engagement (routes
                                to skills/restore), reaper/deadmail/poison in
                                one operator paragraph each.
```

Twelve leaf pages, each a screenful, each opening with an abstract that is an
exit criterion. `first-run/` is ordered (it is the tutorial); `operations/`
partitions day-2 concerns by intent. The two children partition cleanly:
"getting to a working fleet once" versus "operating one that exists". Growth
rule: a new operational topic lands as a new leaf with a README row, splitting
a directory only when its README stops routing cleanly — per the skill.

## 4. The migration map

The test applied throughout: **if Claude can readily do it for the user, it
leaves the README.** Conceptual material stays human-facing; operational
command detail moves to `context/` (single home) and surfaces interactively
through the tutorial.

### 4.1 Out of `README.md`

| README today | Disposition |
| --- | --- |
| § What you need | **Stays**, trimmed to the true human residue: Docker; a Claude subscription or API key; a bot GitHub account you control. |
| § Build and enter the container (`build`/enter/`reset`) | **Replaced** by the three-step golden path; `./garden shell` and `./garden reset` stay as two lines of escape-hatch residue. Auto-build makes `build` an internal detail. |
| Pick-a-unique-identity block (`GARDEN_CONTAINER=… GARDEN_HOSTNAME=…`) | → `context/first-run/identity.md` + tutorial stage 2. README keeps one sentence: "running more than one instance? the tutorial covers unique naming." |
| § Give the bot its keys | → `context/first-run/auth.md` + tutorial stage 3. |
| § Authenticate claude | → folded into golden-path step 2 (the tool prompts) + `auth.md`. |
| § Bring up the fleet (the 4-command block, worker-count guidance, leader note, optional armings, maintainer-watch block) | → `context/first-run/{fleet,leader,monitors,inboxes}.md` + tutorial stages 4–6. |
| § Mint the bulletin token | → `context/first-run/inboxes.md`; `docs/bulletin/SETUP.md` remains the click-by-click. |
| § Health, pausing | → `context/operations/{health,scaling}.md`; `help <topic>` answers these live. |
| § Key vocabulary | **Stays** — it is what the *human says*, not something Claude does on their behalf; it doubles as the tutorial's reference table. |
| § 2 Control surfaces, § 3 How it works | **Stay** — conceptual orientation, the README's real job. Command snippets inside them (the plan/schedule verb block in § 3) move to `context/operations/schedules.md` with a link back. |

Net: the README becomes pitch → three steps → residue paragraph → surfaces →
how-it-works, with `1. Getting started` roughly fifteen lines.

### 4.2 Out of `CLAUDE.md § Job system` (and § Host environment)

CLAUDE.md is auto-loaded into every liaison session, so this migration also
buys back standing context-window weight; the on-demand reading posture is the
whole point of `context/`.

| CLAUDE.md today | Disposition |
| --- | --- |
| Bring-up steps 1–8 | → `context/first-run/` (steps 1–4 → `identity/fleet/leader.md`; 5, 6, 8 → `monitors.md`; 7 → `inboxes.md`). CLAUDE.md keeps a three-line pointer: unique identity is sacred; the tutorial (`help`) or `context/first-run/` does the rest. |
| § Leader and follower hosts (mechanics, singleton inventory, handoff) | → `context/operations/leader-follower.md` (procedure) beside [multibot-leader-follower](multibot-leader-follower.md) (rationale, already exists — the context page routes to it, not duplicates it). CLAUDE.md keeps the two standing behaviors the liaison must never drop: watch the marker on every host; singletons are leader-only. |
| § Deliberate deploy | → `context/operations/deploy.md`; CLAUDE.md keeps two lines (root is a deployed version; deploy is signal-triggered and liaison-supervised). |
| Issue-inbox arming (step 7 + the arming sentences in § Monitoring safety) | Procedure → `context/first-run/inboxes.md`. The **safety constraints stay in CLAUDE.md verbatim** — they are standing policy the liaison must hold in context, not operational detail. |
| Gardener scaling / worker counts | → `context/operations/scaling.md`. |
| § Racing a schedule change | → `context/operations/schedules.md` (which routes to `skills/schedule`); CLAUDE.md keeps the one-line verb mapping. |
| § Host environment (identity resolution, container rename) | → `context/first-run/identity.md`; CLAUDE.md keeps the two-sentence definition of the `GARDEN` identity that the rest of the file references. |
| § Container guard, § Orchestrator vocabulary, § How work reaches workers, inventories | **Stay** — dispatch contract and standing policy, the file's actual job. The guard section adds one sentence recording the launcher-seeded SessionStart hook (§ 1.1). |

`roles/liaison/AGENT.md` keeps its stand-up/stand-down and Monitor *contracts*
(they are role norms) but its longer procedural passages likewise shrink to
routes into `context/operations/`.

## 5. Open questions for the maintainer

1. **Auth path priority.** The design keeps subscription-login-inside-step-2
   as the beaten path and `ANTHROPIC_API_KEY` as the silent alternative
   (§ 1.4). Confirm that ordering — the README residue names both in one
   sentence.
2. **Auto-mode default.** Recommendation is `--dangerously-skip-permissions`
   on the exec'd liaison session, matching the fleet's existing posture, with
   the conservative acceptEdits variant documented but not defaulted
   (§ 1.3). This is the design's one genuinely security-flavored default;
   explicit sign-off requested.
3. **`exec claude` placement.** Recommendation: the enter wrapper, per-exec;
   `CMD` stays systemd (§ 1.2). Veto if you want `./garden` to land in a
   shell by default with `claude` opt-in — the design argues the opposite.
4. **`help` mechanics.** Recommendation: vocabulary row + virgin-instance
   greeting in CLAUDE.md, § Help in the liaison brief, guard-then-probe
   preflight order, no watcher-recognized `help` (§ 2.1).
5. **Boundary confirmation.** `context/` (shipped, `main2`) versus journal
   library (per-instance, `journal2`) as drawn in § 3.1 — in particular that
   bring-up procedure ships with the code rather than living journal-side.
6. **README depth.** § 4.1 keeps §§ 2–3 (surfaces, how-it-works) in the
   README as conceptual orientation. Alternative: move them to `context/`
   too and leave a near-empty README. The design recommends keeping them —
   they are for the human deciding *whether* and *how* to engage, which no
   agent does on their behalf.

## 6. Implementation phases

Separate build jobs, ordered so each lands whole; the maintainer's review of
this design gates the first.

1. **Launcher + guard hook.** `./garden`: auto-build, `.claude/settings.json`
   seeding (SessionStart guard hook), `exec claude --dangerously-skip-permissions`
   on enter, `./garden shell`. CLAUDE.md § Container guard sentence. Testable
   host-side without touching a live fleet.
2. **`context/` tree.** Author the index plus twelve fragments (§ 3.2),
   migrating substance from README/CLAUDE.md per § 4 (content moves here
   first, while the sources still carry it). Amend
   `skills/context-library/SKILL.md` scope to cover `context/`.
3. **Vocabulary + tutorial wiring.** CLAUDE.md vocabulary row, virgin-instance
   preflight probe, `roles/liaison/AGENT.md` § Help; `context/first-run/README.md`
   interaction norms are the tutorial's contract (authored in phase 2).
4. **README/CLAUDE.md slimming.** Cut the migrated sections down to the § 4
   residues, now that `context/` holds the single home. Last, so no window
   exists where a procedure has no home.

Phases 2–4 are serial by content dependency; phase 1 is independent and can
run in parallel with 2. Per the standing multi-part pattern, post them as
orchestrated children under one orchestration job (serial 2→3→4, with 1
parallel to 2).
