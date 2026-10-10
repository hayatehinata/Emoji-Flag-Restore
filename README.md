# Emoji Flag Restore

Restores flag emoji that a ROM renders as missing or transparent, including the Taiwan flag (TW, U+1F1F9 U+1F1FC). The motivating issue is reported on ColorOS 16 and OxygenOS 16: a separate NotoColorEmojiFlags.ttf can contain a transparent Taiwan flag image.

This module overlays existing, recognized separate Noto flag fonts with the unmodified AOSP Noto Color Emoji flags font. All flags in those files use the AOSP artwork; other system emoji fonts are left untouched. It does not change locale, region properties, font XML, SELinux policy, or the physical system partition.

## Requirements and installation

- Android 8.0 or newer with an existing NotoColorEmojiFlags.ttf or NotoColorEmoji-flagsonly.ttf in /system/fonts, /product/fonts, /system_ext/fonts, or /vendor/fonts. Separate flag fonts are most common on newer Android releases. The installer aborts on unsupported layouts.
- Magisk with module mounting enabled, or KernelSU with working system file mounting. Current metamodule-based KernelSU releases require a mounting metamodule such as meta-overlayfs. KernelSU forks and older releases may provide their own mounting mechanism.
- Disable other modules that replace the same flag fonts before installation.

Install the ZIP using Modules > Install from storage in the root manager, then reboot. Installation is offline. This is a manager-installable module ZIP, not a recovery or fastboot image.

The installer records overlay targets in targets.txt inside the installed module directory. After a ROM update that changes font locations, reinstall the module to detect the new layout.

## Verification and limitations

After reboot, paste the text from TEST.txt into an app using Android system fonts, such as a browser text field. Taiwan should appear as a visible flag alongside the comparison flags. Restart apps if needed.

This is a font-level repair. It cannot restore an entry deliberately hidden by a keyboard's picker, override app-bundled emoji fonts or images, or bypass application/framework filtering of the underlying text. A downloaded system font override or another module can take precedence. Selecting the default system font may help. No app data or font caches are deleted.

The bundled font's Taiwan sequence and nontransparent bitmap were checked during packaging. Installer paths and abort behavior were tested in a host-side mock environment. Real-device installation and rendering have not been verified; compatibility is based on the detected font layout, not a promise for every ROM.

## Removal

Disable or uninstall Emoji Flag Restore in the root manager and reboot. The original partition files remain intact. If Android cannot start after a module change, use your root manager's documented module recovery/safe mode, or create /data/adb/modules/emoji_flag_restore/disable from an available root/recovery shell, then reboot.

## Source and redistribution

See SOURCES.md for the pinned AOSP source, hashes, and references. The font is redistributed unmodified under the SIL Open Font License 1.1; its original notice is in licenses/OFL.txt. The source package's Unicode license is included in licenses/UNICODE.txt. Module scripts and documentation are under the MIT license in LICENSE. Preserve the font license and notices when publishing or repackaging. This project is not affiliated with Google, OPPO, Magisk, or KernelSU.
