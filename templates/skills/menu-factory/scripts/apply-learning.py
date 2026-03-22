#!/usr/bin/env python3
"""
apply-learning.py - Reorder menu options based on menu-learning usage stats.

Usage:
    python3 apply-learning.py --skill <name> --menu '<json>' [--json]
    python3 apply-learning.py --skill <name> (extract menu from SKILL.md)

Exit Codes:
    0 - Success
    1 - No usage data found (returns original menu)
    2 - Invalid menu JSON
    3 - Skill not found
"""

import argparse
import json
import re
import sys
from collections import Counter
from pathlib import Path

SKILLS_DIR = Path.home() / ".config" / "opencode" / "skills"
MENU_LEARNING_DATA = SKILLS_DIR / "menu-learning" / "data" / "selections.json"


def load_usage_stats(skill_name: str) -> Counter:
    """Load usage statistics for a skill from menu-learning data."""
    if not MENU_LEARNING_DATA.exists():
        return Counter()

    try:
        with open(MENU_LEARNING_DATA) as f:
            data = json.load(f)
    except (json.JSONDecodeError, IOError):
        return Counter()

    selections = data.get("selections", [])
    counter = Counter()

    for sel in selections:
        if sel.get("menu_id") == skill_name:
            counter[sel.get("option_id", "")] += 1

    return counter


def extract_menu_from_skill(skill_name: str) -> dict | None:
    """Extract menu JSON from SKILL.md file."""
    skill_path = SKILLS_DIR / skill_name / "SKILL.md"
    if not skill_path.exists():
        return None

    content = skill_path.read_text()

    # Find ALL json blocks and look for one with "questions" (menu)
    json_blocks = re.findall(r'```json\s*\n(\{[\s\S]*?\n\})\s*```', content)
    for block in json_blocks:
        try:
            parsed = json.loads(block)
            if "questions" in parsed:
                return parsed
        except json.JSONDecodeError:
            continue
    return None


def reorder_menu(menu: dict, usage: Counter) -> dict:
    """Reorder menu options by usage frequency, preserving suffix."""
    options = menu["questions"][0]["options"]

    # Identify suffix options (skill_discovery and exit) - keep them at end
    suffix_labels = {"🔍 Skill Discovery", "Exit"}
    suffix_options = [opt for opt in options if opt.get("label") in suffix_labels]
    main_options = [opt for opt in options if opt.get("label") not in suffix_labels]

    # Sort main options by usage (most used first)
    main_options.sort(key=lambda opt: usage.get(opt.get("label", ""), 0), reverse=True)

    # Reconstruct menu
    menu["questions"][0]["options"] = main_options + suffix_options
    return menu


def main():
    parser = argparse.ArgumentParser(description="Apply menu-learning to reorder options")
    parser.add_argument("--skill", required=True, help="Skill name to lookup usage")
    parser.add_argument("--menu", help="Menu JSON to reorder (extracts from SKILL.md if not provided)")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    if args.menu:
        try:
            menu = json.loads(args.menu)
        except json.JSONDecodeError as e:
            if args.json:
                print(json.dumps({"error": f"Invalid JSON: {e}"}))
            else:
                print(f"Error: Invalid JSON: {e}")
            sys.exit(2)
    else:
        menu = extract_menu_from_skill(args.skill)
        if menu is None:
            if args.json:
                print(json.dumps({"error": f"Skill not found or no menu: {args.skill}"}))
            else:
                print(f"Error: Skill not found or no menu: {args.skill}")
            sys.exit(3)

    usage = load_usage_stats(args.skill)

    if not usage:
        # No data, return original menu
        output = {"skill": args.skill, "reordered": False, "menu": menu}
        if args.json:
            print(json.dumps(output, indent=2))
        else:
            print(f"No usage data found for {args.skill}. Menu unchanged.")
        sys.exit(0)

    reordered = reorder_menu(menu, usage)

    output = {
        "skill": args.skill,
        "reordered": True,
        "usage_stats": dict(usage.most_common()),
        "menu": reordered
    }

    if args.json:
        print(json.dumps(output, indent=2))
    else:
        print(f"✅ Reordered menu for {args.skill}")
        print(f"   Top options: {', '.join(opt for opt, _ in usage.most_common(3))}")
        print()
        print(json.dumps(reordered, indent=2))

    sys.exit(0)


if __name__ == "__main__":
    main()
