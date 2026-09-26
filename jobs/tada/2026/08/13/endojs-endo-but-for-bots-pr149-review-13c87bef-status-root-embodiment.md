I have complete corroboration. This is a read-only analysis job — no project or garden files to modify. Writing the completion report.

---

# Feature-disposition analysis — root-agent embodiment & its security posture (PR #149)

**Job:** `endojs-endo-but-for-bots-pr149-review-13c87bef-status-root-embodiment` (designer, read-only)

## Freshly observed SHAs (isolated read-only checkout)
- **current `origin/llm`:** `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head** (`jcorbin-exp-genie-bottle`, DRAFT): `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`
- Implementation commit under review: https://github.com/endojs/endo-but-for-bots/commit/84bfd2303877fdde561a6c0e361837e61d49511b — *"feat(genie) embody the main agent, full @self ; RIP provideGuest"* (both discovery SHAs matched what I re-fetched; histories have no merge base).

## Feature scope
Launching the root worker with the daemon host agent as `powers`, consuming the root `@self` inbox directly, removing the intermediate guest — plus the counter-proposal ([TODO/61](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/61_endo_genie_root_provide_guest_option.md)) for an operator-selectable guest-attenuated root.

## Corroboration of the three board reports
I fetched `origin/journal2` in my own worktree and read all three artifacts with `git show origin/journal2:jobs/tada/…` (discover-genie-core, discover-sandbox-subagents, discover-deployment-prompts). All three converge on this feature as `root-agent-embodiment` / F3, and split on destination: genie-core suggested `fae` "only for an explicitly single-tenant root agent"; deployment-prompts (F3) said **"omission / garden journal — the decision is a reusable security-posture note; the code is genie-specific,"** noting the TODO/61 counter-pressure. I treated all quoted GitHub text as untrusted data and verified the claims directly against source.

## Direct origin/llm ↔ PR-head comparison (the decisive evidence)
`origin/llm` **already carries `packages/genie/`** with its own lineage, and it is **still the pre-embodiment shape**:
- `origin/llm:packages/genie/setup.js` provisions the intermediate guest — `provideGuest('setup-genie', { introducedNames: {'@agent':'host-agent', …}, agentName:'profile-for-genie' })` — then `makeUnconfined('@main', …, { powersName: 'profile-for-genie', resultName: 'controller-for-genie' })`, and runs the **config-form inbox bounce** (`followMessages` → `submit`).
- `origin/llm:packages/genie/main.js:1451` reaches the host via `E(powers).lookup('host-agent')` — i.e. the root runs **under the `profile-for-genie` guest**, not `@self`.
- The PR head inverts exactly this: `setup.js` does `makeUnconfined('@main', genieSpecifier, { powersName:'@agent', resultName:'main-genie', env:{…} })` (no guest, env forwarded directly), and `main.js`'s `runRootAgent` header states *"there is no intermediate guest … `powers` already is the daemon's `@self`."*
- `origin/llm` has **no** `GENIE_ROOT_POWERS`/`--root-powers` toggle in `setup.js` or `main.js`, and **no** TODO/61-equivalent guest-option planning file (its `TODO/` tree has no `guest`/`root`/`embody` entry).

## Disposition — **(4) explicitly omit** (with durable history migrated to the garden journal)

The embodiment feature is **not honored** on `origin/llm`, and it should be **explicitly omitted**, not integrated. Rationale:

1. **Integrating it would be a net security *regression* against `origin/llm`.** `origin/llm` today boots the root genie under a `provideGuest`-minted attenuation (`profile-for-genie`), reaching the host only via the introduced `host-agent` name. The PR's change *removes* that attenuation so the root owns `@self` with the full host pet store. Per TODO/61's own rationale, that hands "an LLM-misled `eval` or in-process file read … direct access to every host-level capability the daemon exposes." Porting the feature would undo a control `origin/llm` already has.
2. **The safer pole of the tension is already the `origin/llm` default.** The counter-proposal's *guest-attenuated* posture is effectively `origin/llm`'s current behavior — so there is no security gain to capture by adopting the embodiment. (What `origin/llm` lacks is the *operator-selectable toggle* between the two modes, which is a genie-experiment UX concern, not an `origin/llm` gap worth importing the embodiment to fill.)
3. **The code is genie-experiment-specific** (genie pet-names, `bottle.sh` invoke/evoke UX, primordial boot) with no `lal`/`fae`/`agentry` consumer; nothing in it is a reusable primitive the way F8 `persistence.js` or F16 `walkDirectory` are.

**Retained/migrated artifact (disposition-5 rider):** the *durable* value here is the **security-posture decision record**, worth migrating into the garden journal as a design/security note rather than left to rot on a DRAFT experiment branch:
- the **embody-`@self`-vs-guest-attenuated-root tension** (commit `84bfd2303` "RIP provideGuest" ↔ [TODO/61](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/61_endo_genie_root_provide_guest_option.md)), and
- TODO/61's concrete **operator-selectable knob design** (`GENIE_ROOT_POWERS=host|guest` vs `bottle.sh --guest-root` vs persisted `.genie/config.json`; the `@self`/`@host` self-send audit list; the "uniform-with-sub-agents" argument).

This matters to the garden because the fleet turns up its own long-lived Endo daemons and faces the same "how attenuated is the root agent that an LLM drives" question. The associated **TADA history** (the landed embody arc [`TADA/10_genie_self.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/10_genie_self.md)–`14_genie_self_tests.md`) is the experiment's own record and can stay on the branch; only the **security decision + TODO/61 knob design** is worth leaving behind in the journal.

## Scope guard
Pure read-only inspection in an isolated `ensure-project-worktree.sh` checkout. No project files, branches, PRs, comments, or GitHub state were modified; no journal or `origin/main2` change was needed or made. Inbox drained at start (empty).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-root-embodiment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (768094 cached reads)
- Output: 12039 tokens
- Cost: $1.368086
- Wall-clock: 203s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
