The deliverable is complete and CI signal is strong. Early CI on #719: `build`, `test-xs`, `test-hermes`, `test262` (22.x/24.x), `test-ocapn-python`, `check-action-pins`, `zizmor` all **pass** — notably `test-xs` green confirms the XS-degradation path (Test Plan item 9). The remaining `test`/`cover`/`lint` jobs are pending but already verified locally (532 tests, tsc, eslint clean).

The job's deliverable — a design-faithful, mergeable draft PR — exists as #719. The one open decision (which of the two implementations lands) is surfaced to the maintainer with a recommendation and is gated on their choice.

## Completion report

**Built** the `hardened-url-shim` design (endojs/endo-but-for-bots) as a **draft, MERGEABLE PR: endojs/endo-but-for-bots#719**, base `master`, branch `feat/hardened-url-vetted-shim`.

**What changed** (`packages/ses/`):
- **`src/tame-url-constructor.js`** (new) — mirrors `tame-date-constructor.js`; produces `%URL%` (start compartment, keeps `createObjectURL`/`revokeObjectURL`) and a tamed `%SharedURL%` (shared compartments, omits them), sharing one prototype so cross-compartment `instanceof URL` holds; `%URLPrototype%.constructor` → `%SharedURL%` so shared compartments can't reach the powered `%URL%`. Honors `urlBlobMethods: 'remove'` and returns nothing on hosts without `URL` (XS).
- **`src/permits.js`** — `URLSearchParams` universal; `URL`→`%URL%` on initial, `URL`→`%SharedURL%` on shared; permit rows for `%URL%`, `%SharedURL%`, `%URLPrototype%`, `URLSearchParams`, `%URLSearchParamsPrototype%`, and the hidden `%URLSearchParamsIteratorPrototype%`.
- **`src/get-anonymous-intrinsics.js`** — guarded sampler for the search-params iterator prototype.
- **`src/lockdown.js`** + **`types.d.ts`** — the `urlBlobMethods: 'keepOnInitialGlobal' | 'remove'` lockdown option.
- **3 test files** (19 tests), a **changeset**, Phase-3 audit (no `createObjectURL`/`revokeObjectURL` uses under SES).

**Verification:** full `ses` suite 532 passed; `tsc` clean; `eslint` clean; regression evidence that the iterator-prototype sampler is load-bearing (removing it fails exactly the two iterator-hardening assertions). CI on #719: `test-xs`, `test-hermes`, `test262`, `build`, `test-ocapn-python` green; long jobs pending.

**Key decision surfaced to maintainer:** a prior run of this job opened endojs/endo-but-for-bots#263 with the *universal / remove-blob-methods-everywhere* approach (panel-reviewed, now CONFLICTING) — that's only the design's opt-in `remove` variant. Rather than force-push over reviewed work, I opened the design-faithful split as the new draft #719 and left #263 intact. I recommended landing #719 and closing #263.

**Follow-ups:**
- Maintainer to choose between #719 (design-faithful split, recommended) and #263 (universal); the two are alternatives and only one should land.
- #719 is intentionally left **draft** — it does not auto-run the gauntlet while draft. Once direction is chosen, run the gauntlet on #719 (or rebase #263) to un-draft.
- Confirm the pending long CI jobs (`test`/`cover`/`lint`) land green (locally already verified).
