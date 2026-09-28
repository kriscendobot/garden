#!/usr/bin/env python3
"""pty-lane/run.py — enclose an interactive Claude Code session in a pseudo-terminal
and drive it headlessly to completion.

The experimental pty lane exists so Claude Code's `statusLine` command fires — it only
does in an interactive TUI, never under `claude -p` — which is the one channel carrying a
real context-window measurement (see pty-lane/statusline.sh). This driver is the pty
enclosure: it forks claude under a pty, answers the one-time workspace-trust dialog,
types in the job prompt, then waits for the worker to emit the completion marker as the
final line of its last message — read from the session TRANSCRIPT (clean JSON), not the
ANSI-laden screen — extracts that message as the completion report, and exits the session.

Invoked by pty-lane/run.sh (which resolves paths, settings, trust, and env) as:
    run.py --prompt-file F --report-out F --marker M --signal-file S
           [--transcript T ...] [--idle-exit S] [--max-seconds S] -- claude <args...>

Completion is detected from the SIGNAL FILE the worker is instructed (by run.sh's appended
lane protocol) to write its final report to — a clean, whole-file artifact whose last
non-blank line is the marker. The session transcript and the ANSI-stripped screen are
consulted only as fallbacks. This avoids parsing the wrapped/ANSI TUI for the report and
does not depend on the transcript JSONL path, which varies by CLI version and
CLAUDE_CONFIG_DIR relocation.

Exit code: 0 iff the completion marker was observed and a report was written; non-zero
otherwise (so the spine requeues, exactly like a headless run that never finished).
"""
import argparse, os, pty, select, struct, sys, termios, fcntl, time, re, json, signal

ANSI = re.compile(rb'\x1b\[[0-9;?]*[a-zA-Z]|\x1b\][^\x07]*\x07|\x1b[()][AB0]|[\x00-\x08\x0b-\x1f]')

def screen_text(buf: bytes) -> str:
    # ANSI-stripped, whitespace-collapsed, lowercased — for loose token detection on the
    # TUI (the trust dialog). NEVER used to extract the report; that comes from the
    # transcript so wrapping/ANSI cannot corrupt it.
    return re.sub(r'\s+', '', ANSI.sub(b' ', buf).decode('utf-8', 'replace')).lower()

def read_signal_report(path, marker):
    """Return the worker's report from the signal file iff it is complete — its last
    non-blank line is exactly the marker — else None. Whole-file read; the Write tool
    lands the file atomically, and the last-line==marker check rejects a partial."""
    if not path or not os.path.exists(path):
        return None
    try:
        with open(path, 'r', errors='replace') as fh:
            text = fh.read()
    except Exception:
        return None
    if marker not in text:
        return None
    lines = [l for l in text.splitlines() if l.strip()]
    if lines and lines[-1].strip() == marker:
        return text
    return None


def read_transcript_report(paths, marker):
    """Return the text of the last assistant message whose text ends with `marker`
    (marker as its final non-blank line), or None. Transcript is JSONL; be defensive
    about shape across CLI versions."""
    best = None
    for p in paths:
        if not p or not os.path.exists(p):
            continue
        try:
            with open(p, 'r', errors='replace') as fh:
                for line in fh:
                    line = line.strip()
                    if not line or marker not in line:
                        continue
                    try:
                        obj = json.loads(line)
                    except Exception:
                        continue
                    if obj.get('type') != 'assistant':
                        continue
                    msg = obj.get('message', obj)
                    content = msg.get('content', msg.get('text', ''))
                    text = ''
                    if isinstance(content, str):
                        text = content
                    elif isinstance(content, list):
                        text = ''.join(
                            b.get('text', '') for b in content
                            if isinstance(b, dict) and b.get('type') == 'text'
                        )
                    if marker in text:
                        # last non-blank line must be the marker for the spine to accept it
                        lines = [l for l in text.splitlines() if l.strip()]
                        if lines and lines[-1].strip() == marker:
                            best = text  # keep scanning; last match wins
        except Exception:
            continue
    return best

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prompt-file', required=True)
    ap.add_argument('--report-out', required=True)
    ap.add_argument('--marker', required=True)
    ap.add_argument('--signal-file', default='')
    ap.add_argument('--transcript', action='append', default=[])
    ap.add_argument('--idle-exit', type=float, default=8.0,
                    help='seconds to keep the session alive after the marker is seen '
                         '(lets a final status-line refresh persist the real figure)')
    ap.add_argument('--max-seconds', type=float, default=0.0,
                    help='hard cap; 0 = rely on the spine timeout wrapper')
    ap.add_argument('cmd', nargs=argparse.REMAINDER)
    a = ap.parse_args()
    cmd = a.cmd[1:] if a.cmd and a.cmd[0] == '--' else a.cmd
    if not cmd:
        print('run.py: no command after --', file=sys.stderr); sys.exit(64)

    with open(a.prompt_file, 'rb') as fh:
        prompt = fh.read().rstrip(b'\n')

    raw_log = os.environ.get('GARDEN_PTY_RAW_LOG')  # optional debug capture
    rawfh = open(raw_log, 'wb') if raw_log else None

    pid, fd = pty.fork()
    if pid == 0:
        os.execvp(cmd[0], cmd)
        os._exit(127)

    # generous window so the TUI renders (and the status line has room)
    fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack('HHHH', 50, 200, 0, 0))

    start = time.time()
    buf = b''
    trusted = False
    sent = False
    marker_seen_at = None
    report = None
    exiting = False
    exit_sent_at = None
    rc = 1

    def poll_report():
        # signal file first (clean, whole-file), then transcript as a fallback
        r = read_signal_report(a.signal_file, a.marker)
        if r is not None:
            return r
        return read_transcript_report(a.transcript, a.marker)

    while True:
        r, _, _ = select.select([fd], [], [], 0.3)
        if fd in r:
            try:
                data = os.read(fd, 8192)
            except OSError:
                break
            if not data:
                break
            buf += data
            if rawfh:
                rawfh.write(data); rawfh.flush()
            if len(buf) > 1_000_000:      # bound memory on a long session
                buf = buf[-500_000:]
        el = time.time() - start
        scr = screen_text(buf)

        # 1) one-time workspace-trust dialog (default option is "No, exit" → must go DOWN)
        if not trusted and 'trustthisfolder' in scr and el > 1:
            os.write(fd, b'\x1b[B'); time.sleep(0.3); os.write(fd, b'\r')
            trusted = True; time.sleep(1.2); continue

        # 2) inject the job prompt once the session is up, THEN submit with a SEPARATE
        #    Enter. The prompt is multi-line; writing its bytes raw would let each embedded
        #    newline act as a premature submit. So wrap it in BRACKETED-PASTE markers
        #    (ESC[200~ … ESC[201~) — Claude Code has bracketed paste on (ESC[?2004h) — so the
        #    whole block (newlines and all) is taken as one pasted message, and the '\r'
        #    sent afterwards, OUTSIDE the markers, is the submit.
        if not sent and el > 3:
            if prompt:
                os.write(fd, b'\x1b[200~' + prompt + b'\x1b[201~')
                time.sleep(0.8)
                os.write(fd, b'\r')
            sent = True; time.sleep(0.4); continue

        # 3) watch the transcript for the completion marker
        if sent and marker_seen_at is None:
            report = poll_report()
            if report is not None:
                marker_seen_at = time.time()

        # 4) after the marker, linger briefly (final status refresh) then /exit cleanly
        if marker_seen_at is not None and not exiting and (time.time() - marker_seen_at) > a.idle_exit:
            os.write(fd, b'\x1b'); time.sleep(0.3); os.write(fd, b'/exit\r')
            exiting = True; exit_sent_at = time.time()
        if exiting and (time.time() - exit_sent_at) > 4:
            break

        if a.max_seconds and el > a.max_seconds:
            break

    # final transcript re-read (the marker may have landed as we were exiting)
    if report is None:
        report = poll_report()

    if rawfh:
        rawfh.close()
    try: os.close(fd)
    except OSError: pass
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    try:
        _, status = os.waitpid(pid, 0)
    except ChildProcessError:
        status = 0

    if report is not None:
        # Normalize to end with exactly the marker line (spine checks the LAST non-blank
        # line). Trailing whitespace already trimmed by the extractor's final-line check.
        with open(a.report_out, 'w') as fh:
            fh.write(report if report.endswith('\n') else report + '\n')
        rc = 0
    else:
        # No marker: leave a short diagnostic report and fail so the spine requeues.
        with open(a.report_out, 'w') as fh:
            fh.write('pty-lane: session ended without emitting the completion marker; '
                     'requeueing.\n')
        rc = 1
    sys.exit(rc)

if __name__ == '__main__':
    main()
