I have everything needed. This was read-only analysis; no files were modified, nothing pushed, no GitHub interaction. Writing the report.

---

## Completion report — feature disposition: `subagent-explicit-introductions` (PR #149)

**Job:** read-only feature-disposition analysis, designer role. Feature scope: *bridging a live slice through the host pet store, introducing it to a child guest as `sandbox`, idempotent guest provisioning, and parent-directory locator recording.*

### Freshly observed SHAs
- Current `origin/llm`: **`a54c3adbebf18fd837770d467433e480de498e8d`** (unchanged from all three discovery reports).
- PR #149 head (`jcorbin-exp-genie-bottle`, DRAFT/OPEN): **`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`**.
- Primary feature commit: `f3fea950a11915f3671f67cc18ae690c77442c3f` — *"WIP(genie): introduce sandbox slice"* (Joshua T Corbin), touching only `packages/genie/main.js` (+79/−12), inside the `spawnAgent` helper.

### Corroboration of the three board discovery reports
Read portably from `origin/journal2` via `git show` (not a host path): `…discover-genie-core.md`, `…discover-sandbox-subagents.md`, `…discover-deployment-prompts.md`. All GitHub-authored text treated as untrusted data. Their common facts hold up against fresh inspection: PR head `e0c8accb3`, no merge base with `llm`, and — specific to this feature — the sandbox-subagents report's claim that `subagent-explicit-introductions` "adds a host pet-store bridge for the live slice, introduces it to the child guest as `sandbox`, retains idempotent `provideGuest`, records the child locator in the parent directory," and that its containing helper `spawnAgent` is unwired scaffolding. Verified directly:
- At PR head, `spawnAgent` is defined and `harden(spawnAgent)`-ed but **never invoked** — `main.js:1466` comment: *"`spawnAgent` is no longer invoked on boot."* No live caller (grep-confirmed).
- The feature mechanism: `E(hostAgent).storeValue(subAgentSlice, sliceName)` (pet-store pin, `has`-guarded) → `introducedNames = harden({ [sliceName]: 'sandbox', ...introducedExtras })` → `provideGuest(agentName, { introducedNames })`, with the `has(agentName) ? lookup : provideGuest` idempotency guard. Design captured in `TADA/52_endo_genie_subagent_provide_guest.md` (all boxes checked) and `TADA/23…phase3_5b_genie_subagent.md` Decisions 2/3.

### Comparison against current `origin/llm`
`origin/llm` carries its **own, materially different and fully-wired** `spawnAgent` (`packages/genie/main.js:1039`, invoked live at `main.js:1610` from the config-form handler). The two branches are parallel evolutions with entirely disjoint TADA numbering (PR: linear 22/23/50-52 + open TODO 53-61; `origin/llm`: a separate `24_genie_sandbox_spawner_simplify` / `41_genie_sandbox_provide_host_path` / `42_genie_sandbox_factory_powers` / `43_genie_sandbox_spawner_power` arc). Splitting the scoped feature into its four sub-parts:

| Sub-part | Status in `origin/llm` |
|---|---|
| **Idempotent guest provisioning** (`has(agentName) ? lookup : provideGuest`) | **Already honored** — `main.js:1069-1077`, and *wired live* (PR's is dormant). |
| **Parent-directory locator recording** (`storeLocator([dir, name], childLocator)`, `has`-guarded `makeDirectory`) | **Already honored** — `main.js:1085-1093`, wired live. |
| **Bridge live slice through host pet store** (`storeValue(slice, '<name>-sandbox')`) | **Not present — deliberately superseded.** `origin/llm` mints the slice via `mintGenieSlice(...)` and routes the child's `bash`/`exec`/`git` through a `spawner` (`src/tools/sandbox-spawner.js`) **in-process**; the slice never enters the pet store. |
| **Introduce slice to child as `sandbox`** (`introducedNames[sliceName]='sandbox'`) | **Not present — deliberately superseded.** `origin/llm`'s `introducedNames` grants only `workspace-mount→workspace` and `sandbox-factory→sandboxes`; the slice is used in-process, not handed to the child as a named cap. |

Grep confirms `origin/llm`'s genie never does `storeValue`-a-slice or introduces `'sandbox'`. The child-provisioning machinery lives in `packages/genie` (+ `packages/daemon`); `packages/fae`, `packages/lal`, `packages/agentry` all exist on `origin/llm` but contain **no** `provideGuest`/`spawnAgent`/`introducedNames` at all.

### Disposition: **(4) Explicitly omit the code — with (5) migrate its durable design decision to the garden journal**

Rationale:
- The two **generic** sub-parts (idempotent guest provisioning; parent-directory locator recording) are **already honored** and *live-wired* in `origin/llm`'s `spawnAgent`, whereas the PR's copies sit in an unwired, hardened-but-never-called helper. Nothing to port.
- The two **distinctive** sub-parts that give the feature its name (host-pet-store slice bridge + introduce-slice-as-`sandbox`) were **deliberately superseded** by `origin/llm`'s already-landed design choice: keep the slice in-process (parent mints via `mintGenieSlice`, child tools route through the slice-backed `spawner`) rather than pin it in the host pet store and hand it into the child guest's namespace as a cap. Re-introducing the pet-store bridge would *regress against* the chosen architecture, not advance it.
- This is why I **diverge from the sandbox-subagents discovery report's "destination: fae" hypothesis** (option 3). fae/lal/agentry hold none of this machinery today, and the capability's mature home is genie's wired `spawnAgent`, which already made the opposite wiring choice. Integrating the genie-daemon-specific pet-store-introduction mechanism into fae would be inventing new surface, not honoring the PR — so integration is not recommended.
- The one durable artifact worth keeping is the **ocap design decision**, not the code: TADA/52 + TADA/23 Decision 2/3 — *"the sub-slice's mount view is the authoritative `/workspace`, so drop the legacy `workspace-mount→workspace` introduction; hand the child its slice, in scoped-within-parent mode optionally re-introducing the parent workspace mount purely as defence-in-depth."* That named-agent guest-provisioning tension (named-cap introduction vs. in-process slice) is a real design note worth a short garden-journal entry for whenever fae grows named-agent lifecycle management, precisely because `origin/llm` resolved it the other way and a future fae author should know both options and why in-process won here.

### TODO/TADA/PLAN history worth leaving behind
- **Landed on the PR only (omit):** `TADA/52_endo_genie_subagent_provide_guest.md`, `TADA/51_endo_genie_subagent_fork_slice.md`, `TADA/50_endo_genie_sandbox_subagents.md`, `TADA/23_endo_posix_sandbox_phase3_5b_genie_subagent.md` — none exist on `origin/llm`.
- **Open, unimplemented (omit — the wider arc this feature was scaffolding for):** `TODO/53`–`TODO/61` (`subagent_worker_boot`, `subagent_directory`, `subagent_remove`, `subagent_list`, `subagent_specials`, `subagent_dispose_cascade`, `subagent_tests`, `subagent_docs`, `root_provide_guest_option`). `TODO/61` (operator-selectable guest-attenuated root boot) carries the only broadly-relevant security note and is already flagged in the deployment-prompts discovery.
- **Migrate (journal):** the one-paragraph "authoritative `/workspace` slice mount ⇒ drop `workspace-mount` introduction; named-cap vs in-process slice hand-off" decision from TADA/52 + TADA/23.

No project files, branches, or GitHub state were modified; no push; nothing posted. All git ran in the isolated project worktree (`ensure-project-worktree.sh`, keyed by this job base) and read-only `git show`/`git fetch` in my per-job gardener worktree. Inbox drained at start (empty).

**Follow-up for the coordinator:** if the journal migration is wanted, post a small journalist/librarian job to encode the one-paragraph ocap decision above; no builder/fixer job against `endojs/endo-but-for-bots` is warranted for this feature.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-subagent-introductions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1025113 cached reads)
- Output: 14575 tokens
- Cost: $1.6209155000000002
- Wall-clock: 233s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
