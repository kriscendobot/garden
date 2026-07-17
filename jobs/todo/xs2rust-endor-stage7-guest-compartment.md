---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T04:31:05Z -->

---
model: opus
---
# Stage 7 child 5/7: guest `Compartment`

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). Children 1–4 precede you serially — sync to the real remote tip and
READ what they actually shipped (child 1's live `globalThis`, child 4's guest
harden/lockdown).

## The work

Make `Compartment` a **guest-visible global** (design § Hardened JavaScript and Compartment,
requirement 5). The primordial `Compartment.evaluate` seam (fresh globals, shared intrinsics)
has existed since stage 1 — this child exposes it to guest code:
1. `new Compartment(globals?)` from guest code: a child compartment with its own global object
   (riding the live-globalThis machinery), shared frozen intrinsics per the design's seam, and
   `compartment.evaluate(src)` running in that global scope. `globalThis` inside the child
   resolves to the child's global.
2. Endowments: own properties of the `globals` argument copied onto the child global (the SES
   constructor shape the boot bundles use — read the SES docs/shim in `packages/ses` for the
   consumed constructor surface and prioritize exactly that; `Compartment.prototype.globalThis`
   getter included).
3. The **module machinery half of the design row (ModuleSource, module maps) is explicitly OUT
   of scope** — the runtime module linking/evaluation seam belongs to the test262-convergence
   work (review ledger). Say so in the crate docs where a reader would look for it. Guest
   `Compartment` here is the evaluate/endowments/globalThis surface the daemon boot bundles
   need.
4. Flip the `feature:Compartment` named skips your work makes real (ses-xs-parity axis), and
   only those.

## Verification

- Behavioral tests: child-compartment isolation (a child global write does not leak to the
  parent; shared intrinsics ARE shared and frozen post-lockdown), evaluate results, endowment
  visibility. Dual-run vs the oracle where its build exposes Compartment; endor-only otherwise,
  honestly labeled.
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 + SYMB 1711/1711.
- Targeted endor-xst incl. `--features-include ses-xs-parity`: 0 failed, coverage may only
  grow, remaining skips named.
- `#![forbid(unsafe_code)]` intact.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1); NEVER `git add`
  c/moddable. Prebuilt binaries run directly WITHOUT `--`.
- Capture test runs to files, check `$?`; `/tmp` is noexec; use `$HOME/tmp` for TMPDIR.
- Budget: ONE 2400s invocation. Land green increments; honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.
