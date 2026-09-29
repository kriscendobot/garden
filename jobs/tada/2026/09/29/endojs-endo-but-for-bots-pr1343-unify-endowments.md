The job is complete. All deliverables verified and durably pushed.

## Completion report

**Job:** Champion the arbitrary guest-endowment work in endojs/endo-but-for-bots#1343 — replace the two separate injection surfaces with one unified endowment map.

**What I did**
- Re-derived state: PR #1343 (`issue982-build-special-names` head, base `feat/daemon-provisioning-grants-5feadae`) previously implemented `endowSpecialNames` as a *separate* surface alongside `introducedNames`. The maintainer's direction (PR #1102 comment 5884356929, and the open review thread) asks to collapse both into one `@`-partitioned map keyed by guest-side name with host-pet-name values.
- **Unified the surface.** Replaced `introducedNames` (ordinary) + `endowSpecialNames` (special) on the retained-guest `provideGuest` path with a single `endowments: Record<guestName, hostPetName>` option. Guest-side name (map key) decides policy: `@`-prefixed → special/indelible; else → ordinary/mutable. Values are host pet names, resolved to formula identifiers only behind the daemon boundary (`identify()` in `makeGuestAuthorityProvider`), keeping formula identifiers out of the agent-facing map.
- Touched `host.js`, `provision/index.js`, `provision/shapes.js`, `types.d.ts`, `guest.js`/`manager.js` plumbing (internal resolved map kept as `introducedSpecialNames`, per the resolved review thread), plus `README.md`, `help.md`, `help-text-data.js`, the changeset, and the lifecycle test.
- **Invariants preserved:** retained-agent idempotence + restart persistence (whole map is part of the immutable retained policy; differing reprovision rejected), formula-graph reachability (`special:@name` edges), and clear failure behavior (ordinary → missing-source-ignored late binding; special → fail-closed `ENDO_SPECIAL_NAME_SOURCE_UNAVAILABLE`; daemon-reserved names rejected; indelible removal blocked). The old "multiple host names → one special name" collision is now structurally impossible. Non-authority guests and the released CLI keep `introducedNames` untouched.

**Verification (rebase: base is a frozen snapshot, merge-base == tip, no rebase needed)**
- `packages/daemon` `lint` (0 errors), `lint:types`, `test:types` — all clean.
- `test/provision-lifecycle.test.js` — 4 passed; the special-names test now exercises a single map carrying both an ordinary and a special endowment.

**Changed / pushed:** commit `6c49234d80` pushed to the PR head branch `kriscendobot/endo-but-for-bots issue982-build-special-names`.

**Communication**
- Replied to the open review thread (`r4135862358`) with the actual SHA and the pet-name/`@`-partition rationale.
- Posted the top-level completion summary (`#issuecomment-5894345987`).

**Follow-ups**
- Posted the maintainer-requested job `endojs-endo-but-for-bots-agent-non-extensible-directory` (agent-maker option to seal an agent's own pet-name directory).
- #1102 is the redundant design-only branch — flagged for the maintainer to close (#1343 is now the sole champion).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-unify-endowments.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 132 tokens (7868864 cached reads)
- Output: 62271 tokens
- Cost: $13.957793500000001
- Wall-clock: 955s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
