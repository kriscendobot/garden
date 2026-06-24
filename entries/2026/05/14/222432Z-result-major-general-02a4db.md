---
ts: 2026-05-14T22:24:32Z
kind: result
role: major-general
project: agoric-sdk
to: liaison
refs:
  - entries/2026/05/14/221910Z-dispatch-liaison-02a4db.md
  - https://github.com/kriskowal/garden/issues/1
---

# Result: agoric-sdk dependabot PR survey + dispatch plan

## Inventory

`gh pr list -R Agoric/agoric-sdk --author "app/dependabot" --state open --limit 100` returns **98** PRs (dispatch estimated ~30; true is ~3x). Oldest `#7540` (2023-04-27 yargs); newest `#12661` (2026-05-12). Dirs: a3p-integration proposals **55**, root **24**, golang/cosmos **11**, multichain-testing **4**, a3p-integration root **4**.

## Cluster table

| Cluster | Count | Recommended shape | Priority |
|---|---|---|---|
| A. CVE/GHSA explicit in PR body | 26 | mirror + shepherd + botanist (MERGE-NOW) | P0 |
| B. Dependabot security-advisory URL, no explicit CVE text | ~40 | mirror + shepherd + botanist | P1 |
| C. Non-security routine bump | ~10 | botanist EMBARGO check; likely SKIP | P3 |
| D. Go-module bumps (`/golang/cosmos`, non-security) | 9 | maintainer triage; Cosmos compat outside bot scope | maintainer |
| E. Stale 2023-2024 PRs (#7540, #8017, #8023, #10190) | 4 | close-with-note | P4 |
| F. Superseded-within-directory | 4 | close-without-merge | P4 |

## CVE / GHSA list (P0; mirror+shepherd+botanist)

- **#12660** patches group (17 deps; CVE-2025-7339 + 2 GHSAs) — broadest single landing.
- **#12584** path-to-regexp 8.4.0 (CVE-2026-4923/4926).
- **#12580** handlebars 4.7.9 (8 GHSAs).
- **#12603, #12630, #12636, #12637** axios →1.15.x (header-injection follow-up); 4 dirs.
- **#12571–#12576, #12585** picomatch (CVE-2026-33671/2); 7 PRs.
- **#12590, #12591, #12592** lodash →4.18.1 (CVE-2021-23337, CVE-2026-4800).
- **#12581, #12582, #12583** brace-expansion →1.1.13 (GHSA-f886-m6hf-6m8v).
- **#12264** express →5.2.0 (CVE-2024-51999); **#12272** jws →4.0.1; **#12237** glob →11.1.0; **#11738** tmp →0.2.4.
- **#11107, #11108** @babel/runtime + @babel/helpers (GHSA-968p-4wvh-cqc8); pair.
- **#11413** runc rc.3 (CVE-2024-45310), **#11841** xz 0.5.14 — Go; maintainer-gated.
- **#10196, #10197, #10198** stake-bld older CVEs; see Stale.

## Supersedence list (close-without-merge)

Same directory, lower target version:

- axios `/proposals/l:wallet-upgrade`: **#12220** → **#12630**.
- axios `/proposals/m:before-(upgrade-)next`: **#12218** → **#12636** (branch renamed `before-upgrade-next` → `before-next-upgrade`; verify base before closing).
- axios `/proposals/h:hook-msg-send`: **#12189** → **#12637**.
- axios `/proposals/k:param-change`: **#11388** → **#12603**.

brace-expansion 1.1.12 PRs (#11473, #11474) are NOT superseded (1.1.13 set lives in different dirs). `@isaacs/brace-expansion` is a different package. Multi-dir picomatch/glob/@protobufjs/utf8 sets supersede only within same directory.

## Recommended dispatch order (cap three concurrent trios)

1. **Batch 1 (high-confidence single-PR wins):** #12660 patches group, #12584 path-to-regexp, #12580 handlebars.
2. **Batch 2 (picomatch family):** #12576 first (root), then six proposal-dir PRs in parallel once shape confirms.
3. **Batch 3 (axios latest):** #12603, #12630, #12636, #12637 — close #11388/#12218/#12220/#12189 as superseded once successors are green.
4. **Batch 4 (lodash, brace-expansion, express, jws, glob):** #12590-12592, #12581-12583, #12264, #12272, #12237.
5. **Batch 5 (babel pair + tmp):** #11107/#11108 paired, #11738.
6. **Batch 6 (Go CVEs):** #11413, #11841 surface to maintainer for explicit auth before ferry.
7. **Batch 7 (close stale):** #7540, #8017, #8023, #10190 close-with-note; also #10196/10197/10198 once stake-bld proposal status is confirmed (dir may be retired).
8. **Batch 8 (remaining non-CVE bumps):** botanist EMBARGO-gated; most likely SKIP/close.

## Out of scope

The 9 non-security `/golang/cosmos` bumps (#11264, #11290, #11625, #12242, #12554, #12595, #12600, #12639, plus go-net #11112) touch consensus-layer compatibility. Maintainer triage; do not auto-flow.

## Notes

- Major-general's three-proposals-per-cycle cap (`roles/major-general/AGENT.md` § Posture) does not apply (pre-existing dependabot PRs, not bot-initiated), but the spirit warrants honoring at the batch level.
- `journal/projects/agoric-sdk/README.md` posture is still *passive standing watch*; with two active engagements, posture-shift is overdue. Gardener after Batch 1 ships.

Self-improvement: dispatch entries that cite PR counts should include the `gh pr list` query that produced them, so subsequent surveys can distinguish volume drift from methodology drift. Routing to liaison.
