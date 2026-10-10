#!/system/bin/sh
# Installed through the Magisk or KernelSU manager, never through recovery.
[ "$BOOTMODE" = true ] || abort "Install this ZIP from the Magisk or KernelSU manager."
[ "$API" -ge 26 ] || abort "Android 8.0 or newer is required."

ui_print "- Emoji Flag Restore 1.0.0"
ui_print "- AOSP Noto flags font 2.047 (unmodified)"
if [ "$KSU" = true ]; then
  ui_print "- KernelSU: enable a working system mount implementation."
  ui_print "  On metamodule-based releases, install a mounting metamodule."
fi

FONT="$MODPATH/payload/NotoColorEmojiFlags.ttf"
[ -s "$FONT" ] || abort "The bundled font is missing. Download the complete ZIP again."
EXPECTED="bccb829e97ca446771231993cf5bff3449974851201c497be6d6d52e906aae7b"
ACTUAL=$(sha256sum "$FONT")
ACTUAL=${ACTUAL%% *}
[ "$ACTUAL" = "$EXPECTED" ] || abort "Font integrity check failed."

COUNT=0
# Limit replacement to known separate flag font names and existing files.
# Product/vendor/system_ext are mapped using the standard module layout.
for BASE in /system /product /system_ext /vendor; do
  for NAME in NotoColorEmojiFlags.ttf NotoColorEmoji-flagsonly.ttf; do
    TARGET="$BASE/fonts/$NAME"
    [ -f "$TARGET" ] || continue
    case "$BASE" in
      /system) REL="system/fonts/$NAME" ;;
      *) REL="system${BASE}/fonts/$NAME" ;;
    esac
    DEST="$MODPATH/$REL"
    mkdir -p "${DEST%/*}" || abort "Cannot create overlay directory."
    cp -f "$FONT" "$DEST" || abort "Cannot copy the replacement font."
    ui_print "- Overlay: $TARGET"
    echo "$TARGET" >> "$MODPATH/targets.txt"
    COUNT=$((COUNT + 1))
  done
done

[ "$COUNT" -gt 0 ] || abort "No supported separate Noto flag font found. No system font was changed."
set_perm_recursive "$MODPATH/system" 0 0 0755 0644
ui_print "- Reboot to apply. Disable/uninstall and reboot to restore stock."
ui_print "- Apps with bundled emoji and keyboard filtering may be unaffected."
