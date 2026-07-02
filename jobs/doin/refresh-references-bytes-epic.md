# Refresh references/bytes-epic.md (the Bytes epic maintainer reference)
Refresh **`references/bytes-epic.md`** on journal2 — the "Bytes epic" maintainer reference (frozen
Uint8Array / immutable ArrayBuffer / byteArray / hex work). Last updated 2026-06-25; it's **stale**.
Reconcile it with the CURRENT state of the bytes-related work (enumerate authoritatively via `gh`,
read-only):
1. **Re-check every listed PR's status** (merged / open / closed) and move each to the correct section —
   `In-flight (open)`, `Landed (merged)`, or `Closed / superseded`. (Current list references #473, #468,
   #449, #435, #451, #140, #417, #56, #27.)
2. **Add the bytes-related work since the last refresh**, at least:
   - the **byteArray view design #572** and its disposition (withdraw #429, #57, upstream endojs/endo#3226;
     the fresh view-based implementation PR),
   - the **@endo/hex** thread: the codec-comparison benchmark **#580** (platform/size/speed/approach table),
     and note the agoric-sdk fork hex work (#7) as a related downstream item,
   - any newer immutable-arraybuffer / byteArray / marshal-codec PRs.
3. **Update the "Stack order (to confirm)"** section to the current dependency/stacking.
Keep the existing maintainer-reference format (sections + PR links with one-line descriptions); append/
correct, don't rewrite the intent. **Land on journal2** via `land-journal-edit.sh`. Report what changed
(PRs moved/added, stack updated). Read-only PR enumeration; no upstream contact for the bot's own artifacts.

---
claim:
  host: endolinbot2
  gardener: 99
  claimed_at: 2026-07-02T03:43:50Z
