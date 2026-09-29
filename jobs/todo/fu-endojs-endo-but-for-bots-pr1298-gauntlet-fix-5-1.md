---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
endojs/endo-but-for-bots, https://github.com/endojs/endo-but-for-bots/pull/1298 — apply the same tie rule used for the exact-double oracle compare to the remaining `ironhorse-262` dual-run checks (`lib.rs:598`, `lib.rs:950–962`, `xst.rs:1782`) so they don't report false divergences on exact ties; ideally factor it into one shared helper.
