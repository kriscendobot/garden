---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Update the PR #1391 description (handoff from endojs-endo-but-for-bots-pr1391-gauntlet-fix-3)

The PR body of https://github.com/endojs/endo-but-for-bots/pull/1391 still describes the retired SturdyRef design. Host oros-studio's bot PAT cannot edit endojs PRs, so replace the body from this host with exactly the text between the markers below, using `gh pr edit 1391 --repo endojs/endo-but-for-bots --body-file <file>`. Do not touch code. Report done.

----- BODY -----
<!-- garden-job: ebfb-sturdyref-layer2-ses-20260930 -->
Refs: #695, #774, https://github.com/kriscendobot/garden/issues/47

## Description

Layer 2 of the stack requested in https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512, stacked on layer 1 (#774) via a frozen base.

When the `@endo/parcel` shim installs `Parcel` before lockdown, the start compartment keeps that constructor (`%InitialParcel%`), including the privileged `Parcel.locate`. Child compartments receive `%SharedParcel%`, which creates and opens the same parcels but has no `locate`. Without a shim, no `Parcel` global appears.

This is the `URL` taming pattern (`%InitialURL%`/`%SharedURL%`, `tameUrlConstructor`) applied to a shim-installed constructor; it cannot be moved wholly into `@endo/parcel`, because only SES populates child-compartment globals, so SES must derive the shared form from the constructor it finds.

### Security Considerations

`lockdown` validates the pre-lockdown `globalThis.Parcel` by shape (data property; constructible; locked `prototype`; distinct own `open`, `locate`, `isParcel` functions), snapshotting the delegated members by descriptor so a Proxy cannot substitute `locate` later. The check guards against an unrelated `Parcel` global; it does not establish provenance, and like any pre-lockdown code the installed `Parcel` is trusted. If code re-points or deletes the global during sampling, lockdown restores the validated value with the first-wins lock.

### Scaling Considerations

None: one descriptor check on a single global.

### Documentation Considerations

`packages/ses/README.md` describes the lockdown contract; `.changeset/ses-permit-parcel.md` is the release note.

### Testing Considerations

Node and XS tests cover shimmed, absent, rejected, Proxy, and reentrant shapes, plus child compartments.

### Compatibility Considerations

`ses` bumps `major`: earlier versions left an arbitrary own `globalThis.Parcel` alone, and `lockdown` now throws a `TypeError` for any binding other than a compatible shim, which breaks such callers at startup.

### Upgrade Considerations

Remove or rename any other `globalThis.Parcel` before `lockdown`, or install `@endo/parcel/shim.js` in its place.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
