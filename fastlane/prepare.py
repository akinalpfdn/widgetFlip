#!/usr/bin/env python3
"""Builds fastlane/metadata and fastlane/screenshots from the listing docs and rendered screenshots.

Sources of truth stay where they are:
  store_listing.md              en-US and tr text
  store_listing_localized.md    the other 20 localizations
  marketing/app-store/          screenshots (English sets + localized/<lang>)

Run from the repo root:  python3 fastlane/prepare.py
"""
import os
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
META = ROOT / "fastlane" / "metadata"
SHOTS = ROOT / "fastlane" / "screenshots"

FIELDS = {
    "Name": "name.txt",
    "Subtitle": "subtitle.txt",
    "Keywords": "keywords.txt",
    "Promotional Text": "promotional_text.txt",
    "Description": "description.txt",
    "What's New (1.1)": "release_notes.txt",
}

# store_listing_localized.md section code -> App Store Connect locale
LOCALIZED = {
    "es-MX": "es-MX", "pt-BR": "pt-BR", "de": "de-DE", "fr": "fr-FR", "ja": "ja", "zh-Hant": "zh-Hant",
    "ko": "ko", "ru": "ru", "it": "it", "es-ES": "es-ES", "zh-Hans": "zh-Hans", "nl": "nl-NL", "ar": "ar-SA",
    "pl": "pl", "en-GB": "en-GB", "sv": "sv", "en-AU": "en-AU", "vi": "vi", "en-CA": "en-CA", "fr-CA": "fr-CA",
}

# Required for every localization; values match the ones already live for en-US and tr.
SUPPORT_URL = "https://akinalpfdn.com/"
PRIVACY_URL = "https://github.com/akinalpfdn/widgetFlip/blob/main/privacy_policy.md"
PRIVACY_URL_TR = "https://github.com/akinalpfdn/widgetFlip/blob/main/privacy_policy_tr.md"

# App Store Connect locale -> rendered screenshot folders (iPhone 6.5", iPad 13")
APP_STORE = ROOT / "marketing" / "app-store"
ENGLISH_SHOTS = (APP_STORE / "en-US-6.5" / "screenshots", APP_STORE / "en-US-ipad-13" / "screenshots")
SHOT_LANG = {"de-DE": "de", "fr-FR": "fr", "fr-CA": "fr", "nl-NL": "nl", "ar-SA": "ar"}


def fields_in(section: str, header: str) -> dict:
    """Returns {field file: text} for every '<header>Field... ```text```' block in a section."""
    found = {}
    for label, filename in FIELDS.items():
        m = re.search(re.escape(header + label) + r"[^\n]*\n+```\n(.*?)\n```", section, flags=re.S)
        if m:
            found[filename] = m.group(1)
    return found


def write_locale(locale: str, fields: dict) -> None:
    folder = META / locale
    folder.mkdir(parents=True, exist_ok=True)
    urls = {
        "support_url.txt": SUPPORT_URL,
        "marketing_url.txt": SUPPORT_URL,
        "privacy_url.txt": PRIVACY_URL_TR if locale == "tr" else PRIVACY_URL,
    }
    for filename, text in {**fields, **urls}.items():
        (folder / filename).write_text(text + "\n", encoding="utf-8")


def main() -> None:
    main_doc = (ROOT / "store_listing.md").read_text(encoding="utf-8")
    en = main_doc[main_doc.index("## English (U.S.)"):main_doc.index("## Türkçe (tr)")]
    tr = main_doc[main_doc.index("## Türkçe (tr)"):]
    write_locale("en-US", fields_in(en, "### "))
    write_locale("tr", fields_in(tr, "### "))

    localized = (ROOT / "store_listing_localized.md").read_text(encoding="utf-8")
    heads = list(re.finditer(r"^## \d+\. .*\(`([^`]+)`\)$", localized, flags=re.M))
    for i, m in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(localized)
        fields = fields_in(localized[m.start():end], "**")
        assert len(fields) == len(FIELDS), (m.group(1), sorted(fields))
        write_locale(LOCALIZED[m.group(1)], fields)

    (META / "primary_category.txt").write_text("UTILITIES\n", encoding="utf-8")
    (META / "secondary_category.txt").write_text("ENTERTAINMENT\n", encoding="utf-8")

    # Screenshots are hard links to the rendered files: no extra disk space, and the folder is git-ignored.
    shutil.rmtree(SHOTS, ignore_errors=True)
    for locale in ["en-US", "tr", *LOCALIZED.values()]:
        if locale.startswith("en-"):
            phone, pad = ENGLISH_SHOTS
        else:
            lang = SHOT_LANG.get(locale, locale)
            phone, pad = APP_STORE / "localized" / lang / "6.5", APP_STORE / "localized" / lang / "ipad-13"
        target = SHOTS / locale
        target.mkdir(parents=True)
        for prefix, source in (("iphone65", phone), ("ipad13", pad)):
            files = sorted(source.glob("0*.png"))
            assert len(files) == 3, (locale, source)
            for f in files:
                os.link(f, target / f"{prefix}_{f.name}")

    locales = sorted(p.name for p in META.iterdir() if p.is_dir())
    print(f"metadata: {len(locales)} locales -> {', '.join(locales)}")
    print(f"screenshots: {sum(1 for _ in SHOTS.rglob('*.png'))} files in {len(list(SHOTS.iterdir()))} locales")


if __name__ == "__main__":
    main()
