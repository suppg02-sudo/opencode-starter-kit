#!/usr/bin/env python3
"""
validate.py - Menu compliance checker for menu-factory skill.

Usage:
    python3 validate.py --menu '<json>' [--fix] [--json]
    python3 validate.py --skill <name> [--fix] [--json]
    python3 validate.py --all [--json]

Exit Codes:
    0 - Valid, no issues
    1 - Issues found (errors)
    2 - Issues found (warnings only)
    3 - Skill not found
"""

import argparse
import json
import re
import sys
from pathlib import Path

SKILLS_DIR = Path.home() / ".config" / "opencode" / "skills"
MENU_FACTORY_DIR = SKILLS_DIR / "menu-factory"


def load_rules() -> dict:
    """Load validation rules from rules directory."""
    rules = {}
    rules_dir = MENU_FACTORY_DIR / "rules"

    with open(rules_dir / "required-suffix.json") as f:
        rules["required_suffix"] = json.load(f)["required_suffix"]

    with open(rules_dir / "format-rules.json") as f:
        rules["format"] = json.load(f)["rules"]

    return rules


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


def validate_menu(menu: dict, rules: dict) -> list[dict]:
    """Validate a menu against rules. Returns list of issues."""
    issues = []
    format_rules = rules["format"]
    required_suffix = rules["required_suffix"]

    if "questions" not in menu or not menu["questions"]:
        issues.append({"type": "no_questions", "severity": "error", "message": "Menu has no questions"})
        return issues

    options = menu["questions"][0].get("options", [])
    option_labels = [opt.get("label", "") for opt in options]

    # Check required suffix
    for req in required_suffix:
        if req["label"] not in option_labels:
            issues.append({
                "type": "missing_suffix",
                "severity": "error",
                "message": f"Missing required option: {req['label']}"
            })

    # Check max options
    if len(options) > format_rules["max_options_per_menu"]:
        issues.append({
            "type": "too_many_options",
            "severity": "warning",
            "message": f"Menu has {len(options)} options, max is {format_rules['max_options_per_menu']}"
        })

    # Check label lengths
    for opt in options:
        label = opt.get("label", "")
        if len(label) > format_rules["label_max_length"]:
            issues.append({
                "type": "label_too_long",
                "severity": "warning",
                "option": label[:30] + "..." if len(label) > 30 else label,
                "length": len(label),
                "message": f"Label exceeds {format_rules['label_max_length']} chars"
            })

        desc = opt.get("description", "")
        if desc and len(desc) > format_rules["description_max_length"]:
            issues.append({
                "type": "description_too_long",
                "severity": "warning",
                "option": label[:30],
                "length": len(desc),
                "message": f"Description exceeds {format_rules['description_max_length']} chars"
            })

    # Check for emojis in non-discovery options
    emoji_pattern = re.compile(r'[^\x00-\x7F]+')
    for opt in options:
        label = opt.get("label", "")
        if emoji_pattern.search(label) and "Skill Discovery" not in label:
            issues.append({
                "type": "emoji_in_label",
                "severity": "warning",
                "option": label,
                "message": "Emoji in non-discovery option label"
            })

    return issues


def fix_menu(menu: dict, rules: dict) -> tuple[dict, list[str]]:
    """Auto-fix menu issues where possible. Returns (fixed_menu, fixes_applied)."""
    fixes = []
    required_suffix = rules["required_suffix"]
    options = menu["questions"][0].get("options", [])

    # Add missing required suffix
    option_labels = [opt.get("label", "") for opt in options]
    for req in required_suffix[::-1]:  # Reverse to add in correct order
        if req["label"] not in option_labels:
            options.append(req)
            fixes.append(f"Added required option: {req['label']}")

    menu["questions"][0]["options"] = options
    return menu, fixes


def validate_skill(skill_name: str, rules: dict) -> dict | None:
    """Validate a single skill's menu. Returns result dict or None if not found."""
    menu = extract_menu_from_skill(skill_name)
    if menu is None:
        return None

    issues = validate_menu(menu, rules)
    return {
        "skill": skill_name,
        "valid": len(issues) == 0 or not any(i["severity"] == "error" for i in issues),
        "issues": issues
    }


def validate_all_skills(rules: dict) -> list[dict]:
    """Validate all skills' menus."""
    results = []
    skills_dir = Path.home() / ".config" / "opencode" / "skills"

    for skill_dir in sorted(skills_dir.iterdir()):
        if not skill_dir.is_dir():
            continue
        skill_name = skill_dir.name
        if skill_name == "menu-factory":
            continue

        result = validate_skill(skill_name, rules)
        if result is not None:
            results.append(result)

    return results


def main():
    parser = argparse.ArgumentParser(description="Validate skill menus")
    parser.add_argument("--menu", help="Menu JSON string to validate")
    parser.add_argument("--skill", help="Skill name to validate")
    parser.add_argument("--all", action="store_true", help="Validate all skills")
    parser.add_argument("--fix", action="store_true", help="Auto-fix issues")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    rules = load_rules()

    if args.all:
        results = validate_all_skills(rules)
        if args.json:
            print(json.dumps(results, indent=2))
        else:
            errors = 0
            warnings = 0
            for r in results:
                if r["issues"]:
                    print(f"\n{'='*50}")
                    print(f"Skill: {r['skill']}")
                    print(f"{'='*50}")
                    for issue in r["issues"]:
                        icon = "❌" if issue["severity"] == "error" else "⚠️"
                        print(f"  {icon} [{issue['type']}] {issue['message']}")
                        if issue["severity"] == "error":
                            errors += 1
                        else:
                            warnings += 1
            print(f"\n{'='*50}")
            print(f"Summary: {len(results)} skills checked, {errors} errors, {warnings} warnings")
        sys.exit(0)

    if args.menu:
        try:
            menu = json.loads(args.menu)
        except json.JSONDecodeError as e:
            print(json.dumps({"valid": False, "error": f"Invalid JSON: {e}"}))
            sys.exit(1)
    elif args.skill:
        menu = extract_menu_from_skill(args.skill)
        if menu is None:
            if args.json:
                print(json.dumps({"valid": False, "error": f"Skill not found or no menu: {args.skill}"}))
            else:
                print(f"Error: Skill not found or no menu: {args.skill}")
            sys.exit(3)
    else:
        parser.print_help()
        sys.exit(1)

    issues = validate_menu(menu, rules)
    fixes_applied = []

    if args.fix:
        menu, fixes_applied = fix_menu(menu, rules)
        issues = validate_menu(menu, rules)  # Re-validate after fixes

    has_errors = any(i["severity"] == "error" for i in issues)
    has_warnings = any(i["severity"] == "warning" for i in issues)

    if args.json:
        result = {
            "valid": len(issues) == 0 or not has_errors,
            "issues": issues,
            "fixes_applied": fixes_applied
        }
        print(json.dumps(result, indent=2))
    else:
        for issue in issues:
            icon = "❌" if issue["severity"] == "error" else "⚠️"
            print(f"{icon} [{issue['type']}] {issue['message']}")
        for fix in fixes_applied:
            print(f"✅ [FIXED] {fix}")

    if has_errors:
        sys.exit(1)
    elif has_warnings:
        sys.exit(2)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()
