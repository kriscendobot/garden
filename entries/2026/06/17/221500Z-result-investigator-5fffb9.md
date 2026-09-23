---
ts: 2026-06-17T22:15:00Z
kind: result
role: investigator
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/221500Z-result-investigator-placeholder.md
---

Investigation: iroh vs tcp reconnection semantics on PR #452 (endojs/endo-but-for-bots).

## Scope

Kumavis asked at comment 4735987527 whether destroying the peer formula on connection loss is the correct way to make subsequent remote-object use retrigger a connection. Added scope at 4736018123: compare against how the tcp network handles this.

## Files read

- packages/daemon/src/networks/iroh.js
- packages/daemon/src/networks/iroh-heartbeat.js
- packages/daemon/src/networks/tcp-netstring.js
- packages/daemon/src/daemon.js (makePeer:5119, ResilientPeerGateway:5319, evaluateFormulaForId:3393, dropLiveValue:1117, isAbandonError:5221)
- packages/daemon/src/remote-control.js (full)
- packages/daemon/src/context.js (thisDiesIfThatDies:93)

## Findings

**Iroh on connection loss:**
- Peer formula: retained. dropLiveValue(context.id) evicts from live-value cache but does NOT cancel the peer context.
- Remote presences: retained and not revoked. thisDiesIfThatDies(peerId) chains do not fire because peer context is not cancelled.
- Subsequent use: fails permanently. currentGatewayP (one-shot, set at dial time) points to the dead gateway. Re-dial via resilientDial() is only triggered when isAbandonError matches; heartbeat-timeout ("iroh keep-alive timeout:...") and stream-close ("iroh stream closed") errors do not match. Caller sees CapTP rejection with no re-dial.

**Tcp on connection loss:**
- Identical architecture: same makePeer / ResilientPeerGateway, same dropLiveValue, same isAbandonError guard.
- "TCP connection closed" error does not match isAbandonError.
- Same broken outcome: dead gateway cached in currentGatewayP, no re-dial on subsequent use.

**Comparison:** Symmetric. Neither tcp nor iroh destroys the peer formula on connection loss; neither re-dials on subsequent remote-presence use after a non-abandon error. Kumavis's concern is valid for both networks.

## Recommendation

Option A (kumavis's proposal): in the dialAttempt dispose callback (daemon.js:5137-5142), replace dropLiveValue(context.id) with context.cancel(new Error('peer connection lost')). This cancels the peer formula, cascades via thisDiesIfThatDies to dependent remote presences (revoking them), and causes next use to reincarnate the peer formula and re-dial.

Severity: bug (footgun for both networks). The ResilientPeerGateway name implies resilience that is not delivered for ordinary connection loss.

## PR comment

https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736157998

next: builder (if kumavis confirms Option A)

Self-improvement: nothing this time.
