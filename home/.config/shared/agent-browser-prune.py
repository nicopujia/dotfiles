#!/usr/bin/env python3

from pathlib import Path
import shutil


def parse_browser_dir(path: Path):
    name, sep, version = path.name.rpartition("-")
    if not sep or not name or not version:
        return None

    try:
        version_parts = tuple(int(part) for part in version.split("."))
    except ValueError:
        return None

    return name, version_parts


def main() -> int:
    browsers_dir = Path.home() / ".agent-browser" / "browsers"
    if not browsers_dir.is_dir():
        return 0

    browser_dirs = [path for path in browsers_dir.iterdir() if path.is_dir()]
    if not browser_dirs:
        return 0

    latest_by_name: dict[str, tuple[tuple[int, ...], Path]] = {}
    for path in browser_dirs:
        parsed = parse_browser_dir(path)
        if parsed is None:
            continue

        name, version_parts = parsed
        current = latest_by_name.get(name)
        if current is None or version_parts > current[0]:
            latest_by_name[name] = (version_parts, path)

    print("Pruning old agent-browser browser binaries...")

    removed_any = False
    for path in browser_dirs:
        parsed = parse_browser_dir(path)
        if parsed is None:
            continue

        name, _ = parsed
        if latest_by_name[name][1] == path:
            continue

        shutil.rmtree(path)
        removed_any = True
        print(f"  Removed {path.name}")

    if not removed_any:
        print("  No old browser binaries to prune")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
