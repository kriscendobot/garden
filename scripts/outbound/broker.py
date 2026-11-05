#!/usr/bin/env python3
"""Fixed-protocol secret broker. It never returns credentials to callers."""

import base64
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import socket
import subprocess
import tempfile

ROOT = Path(os.environ.get("GARDEN_ROOT", Path(__file__).resolve().parents[2]))
STATE = Path(os.environ.get("GARDEN_STATE", ROOT / ".garden-state"))
SECRETS = Path(os.environ.get("GARDEN_SECRETS_DIR", ROOT / ".garden-state/secrets"))
SOCKET = Path(os.environ.get("GARDEN_SECRET_BROKER_SOCKET", STATE / "secret-broker.sock"))
RECORD = ROOT / "scripts/outbound/record.sh"
CURL = os.environ.get("GARDEN_OUTBOUND_CURL", "curl")
MAX_REQUEST = 2 * 1024 * 1024
SECRET_ENVIRONMENT = {
    "ANTHROPIC_API_KEY", "MOONSHOT_API_KEY", "FIREWORKS_API_KEY",
    "OPENROUTER_API_KEY", "OLLAMA_CLOUD_API_KEY", "TYPESAFE_API_KEY",
}

SERVICE = {
    "typesafe": {
        "kind": "typesafe", "env": "TYPESAFE_API_KEY", "file": "typesafe.key",
        "operations": {"classify": ("POST", "https://api.typesafe.ai/v1/systemone"),
                       "muster": ("POST", "https://api.typesafe.ai/v1/systemone")},
    },
    "fireworks": {
        "kind": "fireworks", "env": "FIREWORKS_API_KEY", "file": "fireworks.key",
        "operations": {"models": ("GET", "https://api.fireworks.ai/inference/v1/models")},
    },
    "openrouter": {
        "kind": "openrouter", "env": "OPENROUTER_API_KEY", "file": "openrouter.key",
        "operations": {"models": ("GET", "https://openrouter.ai/api/v1/models"),
                       "canary": ("POST", "https://openrouter.ai/api/v1/chat/completions")},
    },
}


def read_key(spec):
    """Read a whole file under a shared placement lock, then legacy-env fallback."""
    path = SECRETS / spec["file"]
    if path.is_file() and not path.is_symlink():
        lock = os.open(SECRETS, os.O_RDONLY | os.O_DIRECTORY)
        try:
            fcntl.flock(lock, fcntl.LOCK_SH)
            value = path.read_bytes()
            metadata = path.stat()
        finally:
            os.close(lock)
        if (metadata.st_mode & 0o777) != 0o600 or metadata.st_uid != os.getuid():
            raise ValueError("secret file metadata invalid")
    else:
        value = os.environ.get(spec["env"], "").encode("ascii", "strict")
    if not 16 <= len(value) <= 512 or re.fullmatch(rb"[A-Za-z0-9._:/+=-]+", value) is None:
        raise ValueError("secret file shape invalid")
    prefixes = {"anthropic": b"sk-ant-", "moonshot": b"sk-", "openrouter": b"sk-or-v1-"}
    if spec["kind"] in prefixes and not value.startswith(prefixes[spec["kind"]]):
        raise ValueError("secret file prefix invalid")
    if not value:
        raise ValueError("secret absent")
    return value.decode("ascii")


def projection(service, operation, body):
    digest = hashlib.sha256(body).hexdigest()
    result = {"operation": operation, "bytes": len(body), "sha256": digest}
    if body:
        try:
            obj = json.loads(body)
        except json.JSONDecodeError:
            obj = None
        if service == "typesafe" and isinstance(obj, dict):
            questions = obj.get("questions", {})
            result["questions"] = sorted(questions) if isinstance(questions, dict) else []
        if service == "openrouter" and isinstance(obj, dict):
            result["model"] = str(obj.get("model", "unspecified"))[:200]
    return result


def land_record(service, authorized_by, method, path, body, kind, operation):
    environment = {key: value for key, value in os.environ.items() if key not in SECRET_ENVIRONMENT}
    subprocess.run(
        [str(RECORD), service, authorized_by, method, path,
         json.dumps(projection(service, operation, body), separators=(",", ":")), kind, operation],
        check=True, env=environment,
    )


def perform(request):
    service = request.get("service", "")
    operation = request.get("operation", "")
    authorized_by = request.get("authorized_by", "")
    if service not in SERVICE or operation not in SERVICE[service]["operations"]:
        raise ValueError("unregistered service operation")
    if re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._:/@+\-]{0,127}", authorized_by) is None:
        raise ValueError("invalid authorization label")
    if set(request) - {"service", "operation", "authorized_by", "body_b64", "timeout"}:
        raise ValueError("unsupported request field")
    body = base64.b64decode(request.get("body_b64", ""), validate=True)
    if len(body) > MAX_REQUEST:
        raise ValueError("request body too large")
    spec = SERVICE[service]
    method, url = spec["operations"][operation]
    path = "/" + url.split("/", 3)[3]
    key = read_key(spec)

    # Fail closed: the public journal accepts the request before any network send.
    land_record(service, authorized_by, method, path, body, spec["kind"], operation)

    timeout = int(request.get("timeout", 60))
    timeout = min(max(timeout, 1), 120)
    with tempfile.NamedTemporaryFile(prefix="garden-secret-request-", mode="wb") as body_file, \
         tempfile.NamedTemporaryFile(prefix="garden-secret-response-", mode="w+b") as response_file:
        body_file.write(body)
        body_file.flush()
        config = f'url = "{url}"\nheader = "Authorization: Bearer {key}"\n'
        args = [CURL, "--silent", "--show-error", "--output", response_file.name,
                "--write-out", "%{http_code}", "--connect-timeout", "10", "--max-time", str(timeout),
                "--request", method, "--config", "-"]
        if method == "POST":
            args += ["--header", "Content-Type: application/json", "--data-binary", "@" + body_file.name]
        environment = {key: value for key, value in os.environ.items() if key not in SECRET_ENVIRONMENT}
        completed = subprocess.run(args, input=config.encode(), stdout=subprocess.PIPE,
                                   stderr=subprocess.DEVNULL, env=environment)
        response_file.seek(0)
        response = response_file.read()
    status_text = completed.stdout.decode("ascii", "replace")
    status = int(status_text) if status_text.isdigit() else 0
    return {"ok": completed.returncode == 0 and 200 <= status < 300,
            "curl_rc": completed.returncode, "status": status,
            "body_b64": base64.b64encode(response).decode("ascii")}


def serve():
    SOCKET.parent.mkdir(parents=True, exist_ok=True)
    SOCKET.parent.chmod(0o700)
    try:
        SOCKET.unlink()
    except FileNotFoundError:
        pass
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as server:
        server.bind(str(SOCKET))
        SOCKET.chmod(0o600)
        server.listen(32)
        while True:
            connection, _ = server.accept()
            with connection:
                try:
                    chunks = []
                    size = 0
                    while True:
                        chunk = connection.recv(65536)
                        if not chunk:
                            break
                        size += len(chunk)
                        if size > MAX_REQUEST * 2:
                            raise ValueError("request too large")
                        chunks.append(chunk)
                    request = json.loads(b"".join(chunks))
                    response = perform(request)
                except Exception as error:  # value-free class only
                    response = {"ok": False, "status": 0, "curl_rc": 1,
                                "error": type(error).__name__}
                connection.sendall(json.dumps(response, separators=(",", ":")).encode())


if __name__ == "__main__":
    serve()
