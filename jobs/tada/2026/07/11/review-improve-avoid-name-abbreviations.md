Both halves of the contract are delivered, verified, and the cluster is closed. Final report:

---

## Completion report — `review-improve-avoid-name-abbreviations`

Closed the `avoid-name-abbreviations` review-miss cluster (category `naming`, count=3 across PRs #650/#609) with the full two-part contract. Landed on `main2` as commit `aa2da527e5`.

### (a) Prevention — never-abbreviate norm at the doer
- **`roles/builder/AGENT.md`** — new operating norm: spell freshly-authored identifiers out in full (`directory` not `dir`, `Command` not `Cmd`, `Temporary` not `Temp`/`tmp`, `argument` not `Arg`, `subdirectory` not `subDir`, etc.) even when unambiguous; established platform names stay verbatim; names the gate + escape hatch; cites #650/#609.
- **`roles/fixer/AGENT.md`** — mirror directive (fixer-authored names; "spell out `<name>`" is a rename to satisfy, not defend).
- **`roles/jurors/stylist/AGENT.md`** — added an explicit **mechanical never-abbreviate finding** to the `missed_by` seat as a panel-layer backstop for PRs that skip the gate (maintainer-authored, promoted probes). This closes the sense-gap root cause the job named (stylist read for "crisp" names but had no never-abbreviate check).

### (b) Sensing — tier-1 deterministic gate (delivered, not the tier-2 fallback)
- **New probe** `scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh`, modeled on the sibling `typedefs-belong-in-dts.sh`. For each **added** line of a changed source file it strips string literals and comments (char scanner), extracts identifiers, splits them into camelCase/PascalCase/snake/digit **segments**, and fails when a whole segment is on a curated blocklist (`dir cmd temp tmp arg subdir cfg ctx idx msg btn impl mgr num str val resp req`). Whole-segment matching is the low-false-positive guarantee. Per-file `spell-out-exempt` escape hatch; non-auto-fixable (one line per distinct file/identifier/abbreviation). Subcommands `--scan-stdin`/`--segments` for testing.
- **`skills/pre-push-gates/SKILL.md`** — added the probe table row and a dated Notes-from-the-field entry; builder/fixer skill bullets now name `spell-out-identifiers`.

### Verification — re-litigation test (per member, on real historical lines)
Pulled the actual historical content from the `endojs-endo-but-for-bots.git` bare clone:
- **#650** (`fd593f8cc:packages/daemon/test/mount-revocation.test.js`): fires on `makeTempRoot` (`temp`) and `dir`. Same lines' `fs.mkdtempSync` / `os.tmpdir()` correctly **abstain** (platform names carry no segment boundary at the abbreviation).
- **#609** (`7249263af:packages/daemon/src/host.js`): fires on `makeIntervalSchedulerCmd` (`cmd`); `makeIntervalScheduler` abstains.
- **Controls abstain**: the spelled-out fixes (`makeTemporaryRoot`, `directory`, `makeIntervalScheduler`, `pathComponent`, `segment`); domain/platform terms (`mkdtempSync`, `tmpdir`, `WeakMap`, `Compartment`, `URL`, `interval`, `number`); and abbreviations appearing only in string literals / comments. End-to-end gate mode also verified (source-file filter, opt-out marker, staged-diff pass/fail).

### Close
`review-miss-record.sh cluster-status avoid-name-abbreviations closed --improved-by …` → journal2 now shows `status: closed`, count 3, all three members, `prs: [650, 609]`, `improved_by` set. Inbox drained (empty).

**Follow-ups / notes:** No `pre-push-gates.sh` driver exists in-repo yet (only probes, glob-discoverable) — the new probe follows that same convention, so it is picked up automatically when the driver lands. The blocklist is intentionally curated to the observed set + obvious siblings; extend it (and the SKILL table) if a new abbreviation trips a future review.
