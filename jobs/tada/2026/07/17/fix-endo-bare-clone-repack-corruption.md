Repaired shared bare clone maintenance state: removed the corrupt derived commit graph, expired stale reflogs, and ran `git gc` successfully.

Verified:
- `git fsck --connectivity-only --no-dangling`: exit 0
- `git commit-graph verify`: exit 0
- No loose-object garbage remains; 2 packs total.

No garden-repository changes or commit required. Follow-ups: none.
