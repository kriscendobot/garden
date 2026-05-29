---
ts: 2026-05-29T14:28:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/designer--9c7d88
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - entries/2026/05/29/140800Z-dispatch-steward-f8a9b0.md
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# result: designer — kriskowal CHANGES_REQUESTED on #358 addressed

Re-fetched all 12 inline comments on `designs/daemon-worker-import-from-mount.md` from kriskowal's 14:06:26Z CHANGES_REQUESTED review (the dispatch table named 5; the review actually carried 9 distinct top-level threads plus 3 in-thread replies, all from today). Treated each substantively.

## Push

New head: `e72b355ffe85c7f063420ee47397ed3689041201` (pushed to `endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`).

Rebased over `193846c93` (origin had moved forward with the solicitor round-1 panel commit that landed shortly before the dispatch fired). Five conflict regions resolved by keeping the kriskowal-directive edits and folding in the upstream's helpful prose where it did not conflict (terminology glosses for CAS / compartment-mapper / ReadPowers, the multi-major coexistence test, the snapshot lifetime test, the EndoRegistry naming / resolver-store split / two-scheme open questions). One follow-up cleanup amended into the tip removed lingering lockfile references from the failure-surface error catalog.

## Edited sections mapped to comment IDs

| Comment | Line | Section(s) edited |
|---------|------|-------------------|
| 3324621577 | 19 | Summary (Node.js-as-separate-lane framing); Goals #2, #6 |
| 3324631991 | 101 | Goals #2; Non-Goals (dropped "Reimplementing in JavaScript", added "Sharing internal data structures between lanes"); Phase 1 (JS reference impl ships first); Phase 5 (Rust-backed drop-in deferred); Dependencies table |
| 3324768129 | 115 | Goals #7 (composes with unconfined lane); dropped from Non-Goals |
| 3324769162 | 121 | acknowledgment; non-goal text expanded to "endo install / endo run / endo make" |
| 3324772952 | 124 | Read together with the 3324778604 reply as a continuation of the line-101 lane-separation thread; Live-filesystem-watch non-goal rewritten ("each implementation lane manages its own watch loop") |
| 3324779885 | 127 | Phase 3 expanded to include endo make alongside endo run |
| 3324782663 | 133 | acknowledgment (sibling framing stands) |
| 3324796922 | 409 | RegistryResolution.packagesByKey keyed by canonical <name>@<version>; synthesized endo-mount: URL carries version segment; multi-major coexistence test added in Phase 2 |
| 3324802404 | 409 | makeMountReadPowers({ entryMount, registry, resolution }) closes over both; late-bind via E(registry).fetch with memoize-into-packagesByKey |
| 3324812556 | 571 | Removed MVS+lockfile section (replaced with "Lockfile interaction: out of scope" pointer); dropped Phase 5 (Lockfile honoring); dropped MVS-then-lockfile design decision; dropped Re-resolution-on-lockfile-change open question; scrubbed lockfile from failure-surface error catalog |
| 3324843748 | 728 | New § "mapSnapshot lane in compartment-mapper" (daemon-specific lane consuming EndoRegistry + EndoMount; produces { compartmentMap, resolution, readPowers } for use by importLocation today and importSnapshot in a follow-up; lives in packages/daemon/src/map-snapshot.js; compartment-mapper gains one extension point); Phase 2 expanded to cover both; architecture diagram routes through mapSnapshot before importLocation |

Knock-on edits in `designs/README.md` (Updated date 2026-05-29; summary and size-estimate rows refreshed to mention the JS reference impl, the mapSnapshot lane, and the MVS-only first-cut scope).

## Inline reply IDs

- 3324956439 (on 3324621577)
- 3324957459 (on 3324631991)
- 3324958456 (on 3324768129)
- 3324958965 (on 3324769162)
- 3324959869 (on 3324772952)
- 3324960570 (on 3324779885)
- 3324961134 (on 3324782663)
- 3324962137 (on 3324796922)
- 3324963217 (on 3324802404)
- 3324964002 (on 3324812556)
- 3324965245 (on 3324843748)

All 11 top-level threads received a reply citing SHA e72b355ff and the section addressed.

## Top-level summary comment

ID: 4576271365 (https://github.com/endojs/endo-but-for-bots/pull/358#issuecomment-4576271365)

Maps each comment ID to disposition + section, lists knock-on README edits, and flags two items for the maintainer: (a) whether the compartment-mapper extension point should land in this design's implementation PR or a separate compartment-mapper PR, and (b) whether the "Also untrue" thread on line 124 should be revisited if it was really a separate ask specific to the live-filesystem-watch wording.

## Re-request review

POST `repos/endojs/endo-but-for-bots/pulls/358/requested_reviewers` with `{"reviewers":["kriskowal"]}` via `--input -` returned HTTP 201; kriskowal is now in `requested_reviewers`. Used the working JSON-body shape per the dispatch reminder and `roles/fixer/AGENT.md` line 54.

## Notes

- The dispatch table mentioned 5 comments but the actual review carried 12 inline comments (9 top-level + 3 in-thread). I treated all 9 top-level threads substantively per the designer role's "verify the brief's line-to-section mapping against actual comment line numbers" norm. The brief did flag this would need to happen.
- The "Also untrue" comment on line 124 was ambiguous: the comment text reverses something about a non-goal, but its in-thread reply spoke to lane-separation rather than file-watching. I treated them as the same substantive thread (lane separation) and flagged in the top-level summary that I'm open to revisiting if it was actually a separate ask.
- The design now describes a substantial scope addition (mapSnapshot lane in compartment-mapper) which may want a structural split in the implementation phase. Surfaced in the top-level summary for the maintainer to steer.

Self-improvement: nothing this time.
