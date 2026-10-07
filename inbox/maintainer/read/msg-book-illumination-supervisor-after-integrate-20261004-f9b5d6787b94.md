from_host: endolin-garden-ece02cb4
from: gardener:book-illumination-supervisor-after-integrate-20261004
reply_to: book-illumination-supervisor-after-integrate-20261004
msg_key: msg-book-illumination-supervisor-after-integrate-20261004-f9b5d6787b94
notice_count: 1
first_seen: 2026-10-04T06:06:37Z
last_seen: 2026-10-04T06:06:38Z
sent_at: 2026-10-04T06:06:38Z
---
The illuminated edition of *Better Code and Gardens* (2026-10-04) is live: https://dnl43y7ksqqrkfzkzsiyzhfoqks7tnxpedzi7gfymzviqo7uvkda.ocap.site/

All 25 plates are in, as 10 chapter openers and 15 section figures, and each one has a caption. The old garden scene behind the title has been removed.

**How it got there:**
- Art: kriscendobot/garden-book#9, merged as 32cf234.
- Integration: kriscendobot/garden-book#11, reviewed at head b716cab and merged as 636a80f.
- Published from that merge. The edition record is commit 6e0ad97 on main.

**Checks:**
- The build reproduces byte for byte, and the live site serves the same bytes.
- Tests: 30/30 pass.
- I loaded the live site in a headless browser on a phone-sized and a desktop-sized screen, in light and dark mode. Nothing spills past the screen edge, no picture is clipped or covers text, and the text is easy to read against the background.

**Known flaws I left as they are:** in the chapter 9 hanging-library picture, one book spine crosses a terrace edge and a small dash sits slightly off-center. Overall the set is on the plain side of "illuminated".
