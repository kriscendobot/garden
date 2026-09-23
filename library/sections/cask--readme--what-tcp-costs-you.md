---
title: What TCP costs you
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: CASK's critique of TCP, the set of well-known limitations it reacts against. **Head-of-line blocking** (TCP is FIFO; a lost segment stalls everything behind it — HTTP/1.1 worked around it with parallel connections, HTTP/3/QUIC moved to UDP). **Congestion-loss confusion** (TCP Reno reads all loss as congestion, punishing lossy long-fat paths; the BBR response). **Bufferbloat at the radio edge** (cellular base stations hold huge buffers and effectively take over congestion control). **No priority or expiry in flight** (a queued segment cannot be reordered, expired, or preempted). **Sliding-window coupling** (acknowledging large byte ranges couples unrelated streams). CASK abandons the sliding window and acknowledges every block individually, trading per-block overhead for fine-grained priority control; it borrows CoDel for its send buffers.

CASK began as a reaction to several well-known limitations of TCP:

- **Head-of-line blocking.** TCP is FIFO: a lost segment stalls every segment behind it, even when later segments are independent. HTTP/1.1 compensated by opening many parallel connections per origin; HTTP/3 (QUIC) moved to a UDP substrate to eliminate the problem entirely (RFC 9000).
- **Congestion-loss confusion.** TCP Reno and its descendants interpret all packet loss as congestion, reducing throughput even when loss is due to link errors. This is particularly punishing on long-range, high-bandwidth paths, where companies like Cloudflare and Netflix respond by replicating databases to every metro area rather than relying on cross-continent TCP streams (Cardwell et al., "BBR," ACM Queue 2016).
- **Bufferbloat at the radio edge.** Cellular base stations compensate for the lossy over-the-air link by holding enormous buffers — large enough to absorb an entire web page — and metering segments out over the radio channel. This effectively takes over TCP's congestion-avoidance and flow-control responsibilities, since the base station, not the sender, decides the transmission rate (Jiang et al., "Understanding Bufferbloat in Cellular Networks," IMC 2012).
- **No priority or expiry in flight.** Once a segment enters the TCP send buffer it cannot be reordered, expired, or dropped in favor of higher-priority traffic. An RPC framework built on TCP accepts this rigidity in exchange for reliable delivery.
- **Sliding-window coupling.** TCP's sliding window acknowledges large byte ranges efficiently, but it couples the acknowledgement of unrelated data streams. CASK deliberately abandons this conceit: every block is acknowledged individually, which costs per-block overhead but permits fine-grained priority control.

CoDel ("Controlled Delay") and algorithms like FastTCP have addressed parts of this picture, especially bufferbloat (Nichols & Jacobson, "Controlling Queue Delay," ACM Queue 2012). CASK borrows CoDel for its own send buffers (`sendbuffer`) and uses standard RTT estimation for retransmission timing.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
