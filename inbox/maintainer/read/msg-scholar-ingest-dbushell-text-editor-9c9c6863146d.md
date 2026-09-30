from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-dbushell-text-editor
reply_to: scholar-ingest-dbushell-text-editor
msg_key: msg-scholar-ingest-dbushell-text-editor-9c9c6863146d
notice_count: 1
first_seen: 2026-09-30T03:04:08Z
last_seen: 2026-09-30T03:04:10Z
sent_at: 2026-09-30T03:04:10Z
---
Scholar ingest done: David Bushell's "Fine, I'll build my own text editor!" (dbushell.com, 2026-09-01) is now in the library as 5 sections. It compares three from-scratch web editor substrates against Monaco. `<canvas>` was abandoned because it is inaccessible and the browser gives you nothing for free. `contenteditable="plaintext-only"` has native selection, undo and accessibility, but hits a performance wall on large documents. `<textarea>` is the fastest, but needs an overlay layer for syntax highlighting. It is indexed so a design lookup finds it: the new topic `web-text-editors` and the concept `web-text-editor-approaches` (an options/tradeoffs table), with keywords like "web text editor", "Monaco" and "code editor on the web". Two smaller concepts cover syntax highlighting and UTF-16/grapheme indexing. Gap noted: the library still has no Monaco or CodeMirror documentation. Say the word and those can be ingested.
