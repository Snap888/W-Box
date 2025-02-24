#!/bin/bash
mkdir -p "$PREFIX/bin/widget/"  
CONFIG="/$HOME/.shortcuts/,/Mobox box86"
LOCALDIR="/$PREFIX/bin/widget/local"
LOCALE_WIDGET="Р СѓСЃСЃРєРёР№"
echo "$LOCALE_WIDGET" > "$PREFIX/bin/widget/local"
show_progress() {
     title="$1"
     message="$2"
     duration="$3"
    ( 
        for ((i=0; i<=100; i+=1)); do
            sleep $((duration / 300)) 
            echo $i 
        done
    ) | dialog --no-shadow \
    --title "$title" --gauge "$message" 6 40 0
}
if [ ! -d "$HOME/storage" ]; then
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі Android Activity Manager..." 2
pkg install termux-am -y &>/dev/null
wait
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі Р—Р°РїСЂРѕСЃ РґРѕСЃС‚СѓРїР°..." 2
termux-setup-storage &>/dev/null  
wait
    clear
fi
BASE_DIR=$(<"$PREFIX/bin/widget/directory")
if [ "$BASE_DIR" = "" ]; then
    BASE_DIR="/storage/emulated/0/Download/weg"
    mkdir -p "$PREFIX/bin/widget/"  
echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
fi
show_message() {
    dialog --no-shadow \
    --no-shadow \
    --msgbox "$1" 6 30
}
archive_install() {
    clear
VERSION="/$PREFIX/bin/widget/version"
versioo_mob=$(cat "$VERSION")
if [ $? -eq 0 ]; then
DIALOG_PID=$! 
sleep 1
mkdir -p "$HOME/Desktop"
show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ Р±РёР±Р»РёРѕС‚РµРє..." 2
tar -xzf "$BASE_DIR/Mobox86_64/prefix.tar.gz" -C $PREFIX
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РљРѕРїРёСЂРѕРІР°РЅРёРµ WEG Widget..." 2
cp -r "$BASE_DIR/backup/"* /data/data/com.termux/files/
temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
[ -d "$temp_dir" ] && rm -rf "$temp_dir"
mkdir -p "$temp_dir"
if [ "$versioo_mob" = "86_WOW" ]; then
show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ wow64.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$temp_dir"
show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ x86.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir"
x86_dir="$temp_dir/x86"
if [ -d "$x86_dir" ]; then
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЎРѕР·РґР°РЅРёРµ Р±РёР±Р»РёРѕС‚РµРє Mobox box86..." 2
    for archive in "$x86_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    dialog --no-shadow \
    --msgbox "рџљ« \n
   Р¤Р°Р№Р» x86.tar.gz РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚." 6 41
fi
if [ -d "$PREFIX/glibc" ]; then
    mv "$PREFIX/glibc" "$PREFIX/glibc-x86"
else
    dialog --no-shadow \
    --msgbox "рџљ« \n
Р¤Р°Р№Р» Р°СЂС…РёРІР° glibc-x86/С…64 РѕС‚СЃСѓС‚СЃС‚РІСѓРµС‚." 6 42
fi
wow64_dir="$temp_dir/wow64"
if [ -d "$wow64_dir" ]; then
    show_progress "РЈСЃС‚РїРЅРѕРІРєР°" "вЏі РЎРѕР·РґР°РЅРёРµ Р±РёР±Р»РёРѕС‚РµРє Mobox WoW64..." 2
    for archive in "$wow64_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    dialog --no-shadow \
    --msgbox "рџљ« \n
 Р¤Р°Р№Р» wow64.tar.gz РЅРµ РЅР°Р№РґРµРЅ." 6 39
fi
cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc-x86/
elif [ "$versioo_mob" = "86" ]; then
show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ x86.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir"
x86_dir="$temp_dir/x86"
if [ -d "$x86_dir" ]; then
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЎРѕР·РґР°РЅРёРµ Р±РёР±Р»РёРѕС‚РµРє Mobox box86..." 2
    for archive in "$x86_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    dialog --no-shadow \
    --msgbox "рџљ« \n
   Р¤Р°Р№Р» x86.tar.gz РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚." 6 41
fi
cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc/

elif [ "$versioo_mob" = "WOW" ]; then
show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ wow64.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$PREFIX/"
cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
fi
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЈРґР°Р»РµРЅРёРµ РІСЂРµРјРµРЅРЅС‹С… С„Р°Р№Р»РѕРІ..." 2
rm -rf "$temp_dir"
link_target="$PREFIX/glibc/opt/scripts/mobox"
chmod +x /data/data/com.termux/files/usr/bin/magick
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° СЃРѕР·РґР°РЅР°" 2
else
    dialog --no-shadow \
    --msgbox "рџљ«     Р¦РµР»РµРІРѕР№ С„Р°Р№Р» РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚.\n
    РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° РЅРµ СЃРѕР·РґР°РЅР°.\n
Р’С‹Р±РµСЂРёС‚Рµ РґСЂСѓРіСѓСЋ РґРёСЂРµРєС‚РѕСЂРёСЋ РґР»СЏ СѓСЃС‚Р°РЅРѕРІРєРё." 7 45
DIR_DEFLF="/storage/emulated/0/Download/weg/backup/home/.shortcuts/,/Mobox box86"
WEG_TXT="/storage/emulated/0/Download/weg"
if [ -f "$DIR_DEFLF" ]; then
sed -i "5s|.*|DIR=$WEG_TXT|" "$DIR_DEFLF"
fi
    BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" рџ“‚"|  DIR  | $dir_date")
                fi
                done
                
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Р’С‹Р±СЂР°РЅР° РљРѕСЂРЅРµРІР°СЏ "
                    name="РљРѕСЂРЅРµРІР°СЏ РїР°РїРєР°/.."
                else
                    item="Р’С‹Р±СЂР°РЅР° рџ“‚ $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Р’РѕР№РґРёС‚Рµ РІ РїР°РїРєСѓ СЃ С„Р°Р№Р»Р°РјРё Mobox Menu Рё Widget. РќР°Р¶РјРёС‚Рµ < Ok >\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
$name\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
fi
else
    exit 0
fi
}
permissio_install(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "вќ—пёЏ РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "
  РџСЂРё СѓСЃС‚Р°РЅРѕРІРєРµ Mobox,РІСЃРµ РёРјРµСЋС‰РёРµСЃСЏ\n
   РґР°РЅРЅС‹Рµ Р±СѓРґСѓС‚ СѓС‚РµСЂСЏРЅС‹ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ.\n
 РџРµСЂРµРґ С‚РµРј РєР°Рє РїСЂРѕРґРѕР»Р¶РёС‚СЊ, СЂРµРєРѕРјРµРЅРґСѓРµРј\n
СЃРѕС…СЂР°РЅРёС‚СЊ РґР°РЅРЅС‹Рµ РІРѕ РёР·Р±РµР¶Р°РЅРёРµ РёС… РїРѕС‚РµСЂРё.\n
              РџСЂРѕРґРѕР»Р¶РёС‚СЊ?" 9 44); then
rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
        setup_mobox
    fi
fi
}
permissio_install_86(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "вќ—пёЏ РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "
  РџСЂРё СѓСЃС‚Р°РЅРѕРІРєРµ Mobox,РІСЃРµ РёРјРµСЋС‰РёРµСЃСЏ\n
   РґР°РЅРЅС‹Рµ Р±СѓРґСѓС‚ СѓС‚РµСЂСЏРЅС‹ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ.\n
 РџРµСЂРµРґ С‚РµРј РєР°Рє РїСЂРѕРґРѕР»Р¶РёС‚СЊ, СЂРµРєРѕРјРµРЅРґСѓРµРј\n
СЃРѕС…СЂР°РЅРёС‚СЊ РґР°РЅРЅС‹Рµ РІРѕ РёР·Р±РµР¶Р°РЅРёРµ РёС… РїРѕС‚РµСЂРё.\n
              РџСЂРѕРґРѕР»Р¶РёС‚СЊ?" 9 44); then

rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
setup_mobox
    fi
fi
}
permissio_install_64(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "вќ—пёЏ РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "
  РџСЂРё СѓСЃС‚Р°РЅРѕРІРєРµ Mobox,РІСЃРµ РёРјРµСЋС‰РёРµСЃСЏ\n
   РґР°РЅРЅС‹Рµ Р±СѓРґСѓС‚ СѓС‚РµСЂСЏРЅС‹ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ.\n
 РџРµСЂРµРґ С‚РµРј РєР°Рє РїСЂРѕРґРѕР»Р¶РёС‚СЊ, СЂРµРєРѕРјРµРЅРґСѓРµРј\n
СЃРѕС…СЂР°РЅРёС‚СЊ РґР°РЅРЅС‹Рµ РІРѕ РёР·Р±РµР¶Р°РЅРёРµ РёС… РїРѕС‚РµСЂРё.\n
              РџСЂРѕРґРѕР»Р¶РёС‚СЊ?" 9 44); then
rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
setup_mobox
    fi
fi
}
setup_mobox(){
    while true; do
DIR_DEFLF="/storage/emulated/0/Download/weg/backup/home/.shortcuts/,/Mobox box86"
WEG_TXT="/storage/emulated/0/Download/weg"
if [ -f "$DIR_DEFLF" ]; then
sed -i "5s|.*|DIR=$WEG_TXT|" "$DIR_DEFLF"
fi
    if [ -d "$PREFIX/glibc-wow64" ] || [ -d "$PREFIX/glibc-x86" ] || [ -d "$PREFIX/glibc" ]; then
        choice=$(dialog --no-shadow \
        --title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "Р’С‹Р±РµСЂРёС‚Рµ РґРµР№СЃС‚РІРёРµ:" 13 38 3 \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86 Рё WoW64" "" \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86" "" \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox WoW64" "" \
" РџРµСЂРµР№С‚Рё РІ Р“Р»Р°РІРЅРѕРµ РјРµРЅСЋ" "" \
" Р’С‹Р±СЂР°С‚СЊ РґРёСЂРµРєС‚РѕСЂРёСЋ СЃ С„Р°Р№Р»Р°РјРё" "" \
" Midnight Commander (mc)" "" \
            3>&1 1>&2 2>&3)
    else
        choice=$(dialog --no-shadow \
        --title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "Р’С‹Р±РµСЂРёС‚Рµ РґРµР№СЃС‚РІРёРµ:" 12 38 3 \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86 Рё WoW64" "" \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86" "" \
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox WoW64" "" \
" Р’С‹Р±СЂР°С‚СЊ РґРёСЂРµРєС‚РѕСЂРёСЋ СЃ С„Р°Р№Р»Р°РјРё" "" \
" РРЅС„РѕСЂРјР°С†РёСЏ"  "" \
            3>&1 1>&2 2>&3)
    fi
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
            case $choice in
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86")
    mobox_vers="86"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install_86
                archive_install
                weg_menu_install
                exit
                ;;
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox WoW64") 
    mobox_vers="WOW"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install_64
                archive_install
               weg_menu_install
                exit
                ;;
" РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Mobox box86 Рё WoW64")
    mobox_vers="86_WOW"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install
                archive_install
                weg_menu_install
                exit
                ;;
" РџРµСЂРµР№С‚Рё РІ Р“Р»Р°РІРЅРѕРµ РјРµРЅСЋ")
                if [ -d "$PREFIX/glibc-wow64" ] || [ -d "$PREFIX/glibc-x86" ] || [ -d "$PREFIX/glibc" ]; then
                    weg_menu_install
                    exit 0
                else
                    exit 0
                fi
                ;;
" Р’С‹Р±СЂР°С‚СЊ РґРёСЂРµРєС‚РѕСЂРёСЋ СЃ С„Р°Р№Р»Р°РјРё")
            BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" рџ“‚"|  DIR  | $dir_date")
                fi
                done
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Р’С‹Р±СЂР°РЅР° РљРѕСЂРЅРµРІР°СЏ "
                    name="РљРѕСЂРЅРµРІР°СЏ РїР°РїРєР°/.."
                else
                    item="Р’С‹Р±СЂР°РЅР° рџ“‚ $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Р’РѕР№РґРёС‚Рµ РІ РїР°РїРєСѓ СЃ С„Р°Р№Р»Р°РјРё Mobox Menu Рё Widget. РќР°Р¶РјРёС‚Рµ < Ok >\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
$name\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
            ;;
" Midnight Commander (mc)")
                mc
            ;;
" РРЅС„РѕСЂРјР°С†РёСЏ")
dialog --no-shadow \
--msgbox "рџ’Ў РРЅС„РѕСЂРјР°С†РёСЏ \n\n
рџ§ї Р•СЃР»Рё РІСЃРµ С„Р°Р№Р»С‹ РЅР°С…РѕРґСЏС‚СЃСЏ РІ РїР°РїРєРµ\n
   Download/weg/ РїСЂРѕРіСЂР°РјРјР° РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ\n
   Р±СѓРґРµС‚ Р·Р°РіСЂСѓР¶Р°С‚СЊ С„Р°Р№Р»С‹ РѕС‚С‚СѓРґР°.\n
рџ§ї Р•СЃР»Рё С„Р°Р№Р»С‹ РЅР°С…РѕРґСЏС‚СЃСЏ РІ Р»СЋР±РѕР№ РґСЂСѓРіРѕР№\n
   РїР°РїРєРµ, РІР°Рј РЅРµРѕР±С…РѕРґРёРјРѕ РµРµ РІС‹Р±СЂР°С‚СЊ РґР»СЏ\n
   СѓСЃС‚Р°РЅРѕРІРєРё WEGв„ўвљЎпёЏMobox" 13 45
   other_menu
;;
            *)
               exit
                ;;
        esac
    else
        exit 0
    fi
done
}
weg_menu_install() {
if [ -e $PREFIX/glibc ]; then

rm -rf $PREFIX/bin/weg
cat << 'EOF' > "$PREFIX/bin/weg"


BRAND=$(getprop ro.product.brand)
MODEL=$(getprop ro.product.model)
MARKETING_NAME=$(getprop ro.product.marketname)
MANUFACTURER=$(getprop ro.product.manufacturer)
if [ -n "$MARKETING_NAME" ]; then
    MODEL="$MARKETING_NAME"
fi
if [[ "$MODEL" == *"$BRAND"* ]]; then
    OUTPUT="$MODEL"
else
    OUTPUT="$BRAND $MODEL"
fi
SOC_MODEL=$(getprop ro.soc.model)
PLATFORM=$(getprop ro.board.platform)
VENDOR=$(getprop ro.hardware.vendor)
case "$SOC_MODEL" in
    "SM8150") CHIPSET="Snapdragon 855+; 860" ;;
    "SM8250") CHIPSET="Snapdragon 865; 865+" ;;
    "SM8350") CHIPSET="Snapdragon 888" ;;
    "SM8450") CHIPSET="Snapdragon 8 Gen 1" ;;
    "SM8550") CHIPSET="Snapdragon 8 Gen 2" ;;
    "SM8650") CHIPSET="Snapdragon 8 Gen 3" ;;
    "SM7150") CHIPSET="Snapdragon 730: 730G" ;;
    "SM7125") CHIPSET="Snapdragon 720G" ;;
    "SM6375") CHIPSET="Snapdragon 695; 690" ;;
    "SM6225") CHIPSET="Snapdragon 680" ;;
    "SM6115") CHIPSET="Snapdragon 662; 460" ;;
    "SM4250") CHIPSET="Snapdragon 460" ;;
    *) CHIPSET="$SOC_MODEL" ;;
esac
if [[ "$VENDOR" == "mediatek" || "$PLATFORM" =~ ^(mt6|mt8|mt67|mt68|mt69)$ ]]; then
    CHIPSET="MediaTek $PLATFORM"
fi
if [[ "$VENDOR" == "samsung" && "$PLATFORM" =~ ^exynos.*$ ]]; then
    CHIPSET="Samsung Exynos $PLATFORM"
fi
if [[ "$VENDOR" == "hisilicon" || "$PLATFORM" =~ ^kirin.*$ ]]; then
    CHIPSET="HiSilicon Kirin $PLATFORM"
fi
if [[ "$VENDOR" == "unisoc" || "$PLATFORM" =~ ^sc.*$ ]]; then
    CHIPSET="Unisoc $PLATFORM"
fi
if [ -z "$CHIPSET" ] || [ "$CHIPSET" = " " ]; then
    CHIPSET="РќРµРѕРїСЂРµРґРµР»РµРЅРЅС‹Р№ С‡РёРїСЃРµС‚ ($PLATFORM)"
fi
cores=$(grep -c ^processor /proc/cpuinfo)
ANDROID_VERSION=$(getprop ro.build.version.release)
total_memory_gb=$(cat /proc/meminfo | grep MemTotal | awk '{print $2 / 1024 / 1024}')
formatted_memory=$(printf "%.2f" $total_memory_gb)
available_memory=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2 / 1024 / 1024}')
ost_memory=$(printf "%.2f" $available_memory)
disk_info=$(df -h /data | awk 'NR==2 {print $2, $3, $4}')
used_space=$(echo $disk_info | cut -d ' ' -f 2 | sed 's/[A-Za-z]*//g')
available_space=$(echo $disk_info | cut -d ' ' -f 3 | sed 's/[A-Za-z]*//g')
if [ -f "/sys/class/kgsl/kgsl-3d0/gpu_model" ]; then
    GPU_MODEL=$(cat /sys/class/kgsl/kgsl-3d0/gpu_model)
fi
if [ -z "$GPU_MODEL" ]; then
    GPU_MODEL=$(getprop ro.hardware.egl)
fi
if [ -z "$GPU_MODEL" ]; then
    PLATFORM=$(getprop ro.board.platform)
    case "$PLATFORM" in
        mt6*|mt8*|mt67*|mt68*|mt69*) GPU_MODEL="Mali (MediaTek)" ;;
        exynos*) GPU_MODEL="Mali (Exynos)" ;;
        kirin*) GPU_MODEL="Mali (HiSilicon Kirin)" ;;
        sc*) GPU_MODEL="PowerVR / Mali (Unisoc)" ;;
    esac
fi
if [ -z "$GPU_MODEL" ] && command -v su > /dev/null; then
    GPU_MODEL=$(su -c dumpsys SurfaceFlinger | grep "GLES:" | sed 's/.*GLES: //; s/ (.*//')
fi
if [ -z "$GPU_MODEL" ]; then
    GPU_MODEL="РќРµ СѓРґР°Р»РѕСЃСЊ РѕРїСЂРµРґРµР»РёС‚СЊ"
fi
GPU_MODEL=$(echo "$GPU_MODEL" | sed -E 's/(Adreno)([0-9]{3})/\1 \2/')
mkdir -p "$PREFIX/bin/widget/"  
CONFIG="/$HOME/.shortcuts/,/Mobox box86"
LOCALDIR="/$PREFIX/bin/widget/local"
LOCALE_WIDGET=$(cat "$LOCALDIR")
VERSION="/$PREFIX/bin/widget/version"
versioo_mob=$(cat "$VERSION")
ANDROID_VERSION="$ANDROID_VERSION"
DEVICE="$OUTPUT $MANUFACTURER"
CPU="$CHIPSET"
CORES="$cores"
GPUGPU_MODEL="$GPU_MODEL"
FULL_RAM="$formatted_memory"
ACC_RAM="$ost_memory"
USED_SSD="$used_space"
ACC_SSD="$available_space"
sed -i "217s/.*/ANDROID_VERSION=\"${ANDROID_VERSION}\"/" "$CONFIG"
sed -i "218s/.*/DEVICE=\"${DEVICE}\"/" "$CONFIG"
sed -i "219s/.*/CPU=\"${CPU}\"/" "$CONFIG"
sed -i "220s/.*/CORES=\"${CORES}\"/" "$CONFIG"
sed -i "221s/.*/GPUGPU_MODEL=\"${GPUGPU_MODEL}\"/" "$CONFIG"
sed -i "222s/.*/FULL_RAM=\"${FULL_RAM}\"/" "$CONFIG"
sed -i "223s/.*/ACC_RAM=\"${ACC_RAM}\"/" "$CONFIG"
sed -i "224s/.*/USED_SSD=\"${USED_SSD}\"/" "$CONFIG"
sed -i "225s/.*/ACC_SSD=\"${ACC_SSD}\"/" "$CONFIG"


if [ $LOCALE_WIDGET == "" ]; then
     LOCALE_WIDGET="Р СѓСЃСЃРєРёР№"
echo "$LOCALE_WIDGET" > "$PREFIX/bin/widget/local"
     fi
BASE_DIR=$(<"$PREFIX/bin/widget/directory")
if [ "$BASE_DIR" = "" ]; then
    BASE_DIR="/storage/emulated/0/Download/weg"
echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
fi
WINE_ST="$( [ -f "$PREFIX/glibc/opt/conf/wine_path.conf" ] && head -n 1 "$PREFIX/glibc/opt/conf/wine_path.conf" | cut -c32- || echo "")"
if [ -z $WINE_ST ]; then
     if [ -d "$PREFIX/glibc-x86" ]; then
          WINE_ST="wine-9.3-vanilla-wow64"
     elif [ -d "$PREFIX/glibc-wow64" ]; then
          WINE_ST="wine-ge-custom-8-25"
     fi
fi
source "$PREFIX/mobox/settings"  &>/dev/null
show_progress() {
     title="$1"
     message="$2"
     duration="$3"
    ( 
        for ((i=0; i<=100; i+=7)); do
            sleep $((duration / 200)) 
            echo $i 
        done
    ) | dialog --no-shadow \
    --title "$title" --gauge "$message" 6 40 0
}
link_target="$PREFIX/glibc/opt/scripts/mobox"
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "Р—Р°РіСЂСѓР·РєР° РјРµРЅСЋ" "вЏі РЎРєР°РЅРёСЂРѕРІР°РЅРёРµ РєРѕРјРїРѕРЅРµРЅС‚РѕРІ..." 2
else
    echo "Р¦РµР»РµРІРѕР№ С„Р°Р№Р» $link_target РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚. РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° РЅРµ СЃРѕР·РґР°РЅР°."
fi
DIALOG_PID=$! 
sleep 1
clear
file_path="$PREFIX/glibc/opt/scripts/mobox_menu"
    value=$(grep 'Mobox' "$file_path" | sed -E 's/.*Mobox([^"]*).*/\1/')
wine="$PREFIX/glibc"
install="$BASE_DIR/wine" 
path="$PREFIX/glibc/opt/conf/wine_path.conf"
show_help() {
    dialog --no-shadow \
    --title "рџ“ РЎРїСЂР°РІРєР°" --msgbox "Р­С‚Рѕ РјРµРЅСЋ РїСЂРµРґРЅР°Р·РЅР°С‡РµРЅРѕ РґР»СЏ СѓРїСЂР°РІР»РµРЅРёСЏ РїР°РєРµС‚Р°РјРё WINE.\n\n
Р’С‹ РјРѕР¶РµС‚Рµ:\n
1. Р”РѕР±Р°РІРёС‚СЊ WINE РІ СЃРїРёСЃРѕРє\n
2. Р’С‹Р±СЂР°С‚СЊ WINE Р°РєС‚РёРІРЅС‹Рј.\n
3. РЈРґР°Р»РёС‚СЊ РІС‹Р±СЂР°РЅРЅС‹Р№ WINE РёР· СЃРёСЃС‚РµРјС‹, РєСЂРѕРјРµ Р°РєС‚РёРІРЅРѕРіРѕ.\n\n
РЎР»РµРґСѓР№С‚Рµ РёРЅСЃС‚СЂСѓРєС†РёСЏРј РЅР° СЌРєСЂР°РЅРµ РґР»СЏ РІС‹РїРѕР»РЅРµРЅРёСЏ РѕРїРµСЂР°С†РёР№." 15 42
show_main_menu
}
delete_folder() {
 menu_items=()
 count=1
for folder in "$wine"/wine*/; do
    if [ -d "$folder" ]; then
        if [ "$(basename "$folder")" == "$WINE_ST" ]; then
                menu_items+=("$count" "вњ… $(basename "$folder")") 
        else
            menu_items+=("$count" "рџ”І $(basename "$folder")")
        fi
        ((count++))
    fi
done
if [ ${#menu_items[@]} -eq 0 ]; then
    dialog --no-shadow \
    --title "рџљ« РћС€РёР±РєР°" --msgbox "РЎРїРёСЃРѕРє РїСѓСЃС‚. Р”РѕР±Р°РІСЊС‚Рµ С…РѕС‚СЏ Р±С‹ РѕРґРёРЅ \n
        РёР· РґРѕСЃС‚СѓРїРЅС‹С… WINE" 6 38
    show_main_menu
    return
fi
menu_heightwinD=$((count + 7))
[ $menu_heightwinD -lt 4 ] && menu_heightwinD=10
folder_number=$(dialog --no-shadow \
--title "рџЌ· Р’С‹Р±РµСЂРёС‚Рµ WINE РґР»СЏ СѓРґР°Р»РµРЅРёСЏ" --menu "Р‘СѓРґРµС‚ СѓРґР°Р»РµРЅР° РІСЃСЏ РёРЅС„РѕСЂРјР°С†РёСЏ РЅР°С…РѕРґСЏС‰Р°СЏСЃСЏ РІ СЌС‚РѕРј WINE" $menu_heightwinD 38 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
case $? in
    1) show_main_menu
    return ;; 
    255) show_main_menu
    return ;; 
esac
folder=$(ls -d "$wine"/wine*/ | sed -n "${folder_number}p")
if [ "$WINE_ST" = "$(basename "$folder")" ]; then
    dialog --no-shadow \
    --title "рџљ« РћС€РёР±РєР°" --msgbox "
  Р­С‚РѕС‚ WINE РЅРµР»СЊР·СЏ СѓРґР°Р»РёС‚СЊ,С‚.Рє. \n
       РѕРЅ СЏРІР»СЏРµС‚СЃСЏ Р°РєС‚РёРІРЅС‹Рј \n
Р”Р»СЏ СѓРґР°Р»РµРЅРёСЏ СЌС‚РѕРіРѕ WINE Р°РєС‚РёРІРёСЂСѓР№С‚Рµ\n
    РґСЂСѓРіРѕР№ Рё РїРѕРІС‚РѕСЂРёС‚Рµ РїРѕРїС‹С‚РєСѓ." 8 39
fi
if [ "$WINE_ST" != "$(basename "$folder")" ]; then
dialog --no-shadow \
--title "вќ—пёЏРџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "
Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ \n
$(basename "$folder")?\n
Р’СЃРµ РґР°РЅРЅС‹Рµ РІ WINE Р±СѓРґСѓС‚ СѓС‚СЂР°С‡РµРЅС‹" 7 36
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf "$folder"
    dialog --no-shadow \
    --title "вќЊ РЈРґР°Р»РµРЅРёРµ" --msgbox "
Р’С‹Р±СЂР°РЅРЅС‹Р№ WINE СѓСЃРїРµС€РЅРѕ СѓРґР°Р»РµРЅ \n
         РёР· СЃРёСЃС‚РµРјС‹" 6 34
         delete_folder
         return
                fi
fi
show_main_menu
return
}
select_folder() {
    local menu_items=()
    local count=1
    local folder=$1
    for folder in "$wine"/wine*/; do
        if [ -d "$folder" ]; then
            if [ "$(basename "$folder")" == "$WINE_ST" ]; then
                menu_items+=("$count" "вњ… $(basename "$folder")") 
            else
                menu_items+=("$count" "рџ”І $(basename "$folder")")
            fi
            ((count++))
        fi
    done
    if [ ${#menu_items[@]} -eq 0 ]; then
        dialog --no-shadow \
        --title "рџљ« РћС€РёР±РєР°" --msgbox "Р’ СЃРїРёСЃРєРµ РЅРµС‚ РґРѕСЃС‚СѓРїРЅС‹С… WINE.\n
        РџРѕР¶Р°Р»СѓР№СЃС‚Р°,\n
Р”РѕР±Р°РІСЊС‚Рµ С„Р°Р№Р» WINE РІ СЃРїРёСЃРѕРє." 7 32
        show_main_menu
        return
    fi
    menu_height_winE=$((count + 5))
    [ $menu_height_winE -lt 4 ] && menu_height_winE=10
    folder_number=$(dialog --no-shadow \
    --title "рџЌ· Р’С‹Р±РµСЂРёС‚Рµ WINE РґР»СЏ Р°РєС‚РёРІР°С†РёРё" --menu "" $menu_height_winE 38 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    case $? in
        1) show_main_menu
        return ;;
        255) show_main_menu
        continue ;;
    esac
    folder=$(ls -d "$wine"/wine*/ | sed -n "${folder_number}p")
    folder_name=$(basename "$folder")
    if [ "$WINE_ST" = "$folder_name" ]; then
    
        dialog --no-shadow \
        --title "рџ”‘ РђРєС‚РёРІР°С†РёСЏ" --msgbox "Р”Р°РЅРЅС‹Р№ WINE СѓР¶Рµ Р°РєС‚РёРІРµРЅ" 6 27
    else
        if [ ! -f "$path" ]; then
            touch "$path" || exit 1
        fi
        {
            echo "export WINE_PATH=\$PREFIX/glibc/$folder_name"
            echo "export WINEPREFIX=\$PREFIX/glibc/$folder_name/.wine"
        } > "$path" || exit 1
        weg
        exit
    fi
    show_main_menu
}
install_package() {
local archives=()
local count=1
local active_folders=()
active_folders=()
for folder in "$wine"/wine*/; do
    if [ -d "$folder" ]; then
        active_folders+=("$(basename "$folder")")
    fi
done
archives=()
for archive in "$install"/wine*.tar.xz; do
    if [ -f "$archive" ]; then
        filename=$(basename "$archive" .tar.xz)
        if [[ ! " ${active_folders[@]} " =~ " ${filename} " ]]; then
            archives+=("$count" "$filename")
            ((count++))
        fi
    fi
done
for i in "${!archives[@]}"; do
    if (( i % 2 == 0 )); then
        archives[$i]=$((i / 2 + 1))
    fi
done
if [ ${#archives[@]} -eq 0 ]; then
    dialog --no-shadow \
    --title "рџљ« РћС€РёР±РєР°" --msgbox "\n
     Р’ СЃРїРёСЃРєРµ РЅРµС‚ РґРѕСЃС‚СѓРїРЅС‹С… WINE.\n
РџРѕР¶Р°Р»СѓР№СЃС‚Р°, Р”РѕР±Р°РІСЊС‚Рµ С„Р°Р№Р» WINE РІ РїР°РїРєСѓ." 7 
    show_main_menu 
    return
fi
while true; do
    menu_height_win=$((count + 6))
    [ $menu_height_win -lt 4 ] && menu_height_win=10
    archive_number=$(dialog --no-shadow \
    --title "рџЌ· РРјРїРѕСЂС‚ WINE РІ СЃРїРёСЃРѕРє" --menu "Р’С‹Р±РµСЂРёС‚Рµ WINE РґР»СЏ РёРјРїРѕСЂС‚Р°:" "$menu_height_win" 35 10 "${archives[@]}" 3>&1 1>&2 2>&3)
    case $? in
        1)  show_main_menu
        return ;;
        255) show_main_menu
        break ;;
    esac
selected_number=$archive_number
if [[ "$selected_number" -ge 1 ]] && [ "$selected_number" -le $(( ${#archives[@]} / 2 )) ]; then
    index=$(( (selected_number - 1) * 2 + 1 ))
fi
archive=$(ls "$install"/wine*.tar.xz | sed -n "${archive_number}p")
filename=$install/${archives[index]}.tar.xz
   show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі ${archives[index]}" 2
tar -xJf "$filename" -C "$wine"
    dialog --no-shadow \
    --title "вЏі Р Р°СЃРїР°РєРѕРІРєР°" \
    --yesno "${archives[index]}\n
РР·РІР»РµС‡РµРЅ. РЎРґРµР»Р°С‚СЊ РµРіРѕ Р°РєС‚РёРІРЅС‹Рј?\n
РР»Рё РІС‹ РјРѕР¶РµС‚Рµ СЃРґРµР»Р°С‚СЊ СЌС‚Рѕ РїРѕР·Р¶Рµ, РІ\n
  СЃРѕСЃРµРґРЅРµРј РїСѓРЅРєС‚Рµ РґР°РЅРЅРѕРіРѕ РјРµРЅСЋ.\n
        РђРєС‚РёРІРёСЂРѕРІР°С‚СЊ WINE?" 9 38
response=$?
    if [ $response -eq 0 ]; then
        if [ ! -f "$path" ]; then
            touch "$path" || exit 1
        fi
        {
echo "export WINE_PATH=\$PREFIX/glibc/${archives[index]}"
echo "export WINEPREFIX=\$PREFIX/glibc/${archives[index]}/.wine"
        } > "$path" || exit 1
        weg 
        exit
        else
        show_main_menu
        return
    fi
done
}
show_main_menu() {
WINE_ST="$( [ -f "$PREFIX/glibc/opt/conf/wine_path.conf" ] && head -n 1 "$PREFIX/glibc/opt/conf/wine_path.conf" | cut -c32- || echo "")"
    action=$(dialog --no-shadow \
    --title "рџЌ· РЈРїСЂР°РІР»РµРЅРёРµ WINE" --menu "РђРєС‚РёРІРЅС‹Р№ WINE:\n
$WINE_ST" 12 30 5 \
        " Р”РѕР±Р°РІС‚РёСЊ WINE РІ СЃРїРёСЃРѕРє" "" \
        " Р’С‹Р±СЂР°С‚СЊ Р°РєС‚РёРІРЅС‹Р№ WINE" "" \
        " РЈРґР°Р»РёС‚СЊ WINE РёР· СЃРїРёСЃРєР°" "" \
        " РЎРїСЂР°РІРєР°" "" 3>&1 1>&2 2>&3)
    case $? in
        " Р”РѕР±Р°РІС‚РёСЊ WINE РІ СЃРїРёСЃРѕРє") return ;; 
        255) continue ;;
    esac
    case $action in
         " Р”РѕР±Р°РІС‚РёСЊ WINE РІ СЃРїРёСЃРѕРє")
            install_package
            ;;
         " Р’С‹Р±СЂР°С‚СЊ Р°РєС‚РёРІРЅС‹Р№ WINE")
            select_folder 
            ;;
         " РЈРґР°Р»РёС‚СЊ WINE РёР· СЃРїРёСЃРєР°")
            delete_folder 
            ;;
         " РЎРїСЂР°РІРєР°")
            show_help
            ;;
    esac
}
other_menu() {
choice=$(dialog --no-shadow \
--title "рџ›  Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅРѕ" --menu "Р’С‹Р±РµСЂРёС‚Рµ РѕРїС†РёСЋ:" 13 42 3 \
" Р’РѕСЃСЃС‚Р°РЅРѕРІРёС‚СЊ Р±РёР±Р»РёРѕС‚РµРєРё" "" \
" РћР±РЅРѕРІРёС‚СЊ WEGв„ўвљЎпёЏMobox Menu & Widget" "" \
" РЇР·С‹Рє РєР»Р°СЃСЃРёС‡РµСЃРєРѕРіРѕ РјРµРЅСЋ Mobox" "" \
" РЎРјРµРЅРёС‚СЊ СЂР°СЃРїРѕР»РѕР¶РµРЅРёРµ С„Р°Р№Р»РѕРІ" "" \
" Midnight Commander (mc)" "" \
" РРЅС„РѕСЂРјР°С†РёСЏ" "" 2>&1 >/dev/tty)
                case $choice in
" Р’РѕСЃСЃС‚Р°РЅРѕРІРёС‚СЊ Р±РёР±Р»РёРѕС‚РµРєРё") dialog --no-shadow \
--yesno "Р’РѕСЃСЃС‚Р°РЅРѕРІР»РµРЅРёРµ РІСЃРµС… Р±РёР±Р»РёРѕС‚РµРє\n         РџСЂРѕРґРѕР»Р¶РёС‚СЊ?" 6 33
                    if [ $? -eq 0 ]; then
                    tar -xzf "$BASE_DIR/Mobox86_64/prefix.tar.gz" -C $PREFIX
                    fi
                    ;;
" РћР±РЅРѕРІРёС‚СЊ WEGв„ўвљЎпёЏMobox Menu & Widget") 
     show_progress "РћР±РЅРѕРІР»РµРЅРёРµ" "вЏі РљРѕРїРёСЂРѕРІР°РЅРёРµ С„Р°Р№Р»РѕРІ..." 2
        if [ $LOCALE_WIDGET == "Р СѓСЃСЃРєРёР№" ]; then
            cp -r "$BASE_DIR/backup/"* /data/data/com.termux/files/
        else 
            cp -r "$BASE_DIR/backup_eng/"* /data/data/com.termux/files/
        fi
     exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
;;
" РЇР·С‹Рє РєР»Р°СЃСЃРёС‡РµСЃРєРѕРіРѕ РјРµРЅСЋ Mobox") 
if [ "$LOCALE_WIDGET" == "Р СѓСЃСЃРєРёР№" ]; then
    chek_lokal_r="вњ…" 
    chek_lokal_a="рџ”І"
else 
    chek_lokal_r="рџ”І"
    chek_lokal_a="вњ…"
fi
choice=$(dialog --no-shadow \
--title "РЇР·С‹Рє РёРµРЅСЋ Mobox" --menu "" 8 30 2 \
" $chek_lokal_r Р СѓСЃСЃРєРёР№ РЇР·С‹Рє" "" \
" $chek_lokal_a English Language" "" 2>&1 >/dev/tty)
case $choice in
" $chek_lokal_r Р СѓСЃСЃРєРёР№ РЇР·С‹Рє")
        if [ -d "/data/data/com.termux/files/usr/glibc-x86/" ]; then
        cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
        cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc-x86/
        else
        cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc-wow64/
        cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc/
        fi
exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
        ;;
" $chek_lokal_a English Language")
        if [ -d "/data/data/com.termux/files/usr/glibc-x86/" ]; then
        cp -r "$BASE_DIR/system/glibc_64_en/"* /data/data/com.termux/files/usr/glibc/
        cp -r "$BASE_DIR/system/glibc_86_en/"* /data/data/com.termux/files/usr/glibc-x86/
        else
        cp -r "$BASE_DIR/system/glibc_64_en/"* /data/data/com.termux/files/usr/glibc-wow64/
        cp -r "$BASE_DIR/system/glibc_86_en/"* /data/data/com.termux/files/usr/glibc/
        fi
exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
        ;;
esac
other_menu
;;
" РЎРјРµРЅРёС‚СЊ СЂР°СЃРїРѕР»РѕР¶РµРЅРёРµ С„Р°Р№Р»РѕРІ")
    BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" рџ“‚"|  DIR  | $dir_date")
                fi
                done
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Р’С‹Р±СЂР°РЅР° РљРѕСЂРЅРµРІР°СЏ "
                    name="РљРѕСЂРЅРµРІР°СЏ РїР°РїРєР°/.."
                else
                    item="Р’С‹Р±СЂР°РЅР° рџ“‚ $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Р’РѕР№РґРёС‚Рµ РІ РїР°РїРєСѓ СЃ С„Р°Р№Р»Р°РјРё Mobox Menu Рё Widget. РќР°Р¶РјРёС‚Рµ < Ok >\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
$name\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
    ;;
" Midnight Commander (mc)")
         mc
            ;;
" РРЅС„РѕСЂРјР°С†РёСЏ") dialog --no-shadow \
--msgbox "рџ’Ў РРЅС„РѕСЂРјР°С†РёСЏ \n\n
WEGв„ўвљЎпёЏMobox Menu РїСЂРµРґРЅР°Р·РЅР°С‡РµРЅРѕ РґР»СЏ Р·Р°РїСѓСЃРєР°\n
Рё СѓСЃС‚Р°РЅРѕРІРєРё Mobox box86 Рё Mobox WoW64\n
Р±РµР· РЅР°Р»РёС‡РёСЏ РёРЅС‚РµСЂРЅРµС‚Р°.\n\n
рџ§ї РЈСЃС‚Р°РЅРѕРІРєР° РґРІСѓС… РІРµСЂСЃРёР№ Mobox РґРІСѓРјСЏ\n
   СЃРїРѕСЃРѕР±Р°РјРё:\n
   рџ“Ќ Р•СЃР»Рё СѓСЃС‚Р°РЅРѕРІРєР° РїСЂРѕРІРѕРґРёС‚СЃСЏ РёР· РјРѕРґР°\n 
      Weg_Menu - РџРµСЂРІС‹Р№ Р·Р°РїСѓСЃРє РЅРѕРІРѕРіРѕ WINE\n
      РїСЂРѕС…РѕРґРёС‚ РІ СЃСЂРµРґРµ WINE;\n
   рџ“Ќ Р•СЃР»Рё СѓСЃС‚Р°РЅРѕРІРєР° РїСЂРѕРІРѕРґРёС‚СЃСЏ РёР·\n
      РљР»Р°СЃСЃРёС‡РµСЃРєРѕРіРѕ РњРµРЅСЋ Mobox - РџРµСЂРІС‹Р№\n
      Р·Р°РїСѓСЃРє РЅРѕРІРѕРіРѕ WINE РїСЂРѕС…РѕРґРёС‚ РІ СЃСЂРµРґРµ\n
      Termux.\n
рџ§ї РЈСЃС‚Р°РЅРѕРІРєР° Р±РёР±Р»РёРѕС‚РµРє РґР»СЏ Wegв„ўвљЎWidget.\n
рџ§ї Р‘С‹СЃС‚СЂР°СЏ Рё СѓРґРѕР±РЅР°СЏ СЃРјРµРЅР° WINE.\n
рџ§ї РЈСЃС‚Р°РЅРѕРІРєР° С„Р°Р№Р»РѕРІ РґР»СЏ СЂР°Р±РѕС‚С‹ Wegв„ўвљЎWidget\n
рџ§ї РџСЂРѕСЃС‚РѕС‚Р° Рё СЃРєРѕСЂРѕСЃС‚СЊ СѓСЃС‚Р°РЅРѕРІРєРё.\n
рџ§ї РќР°СЃС‚СЂРѕР№РєР° РІСЃРµС… РІР°Р¶РЅС‹С… РєРѕРјРїРѕРЅРµРЅС‚РѕРІ РґР»СЏ\n
   РєР°Р¶РґРѕР№ РІРµСЂСЃРёРё Mobox РѕС‚РґРµР»СЊРЅРѕ.\n\n" 25 47
   other_menu
;;
esac
}
if [ -d "$PREFIX/glibc" ]; then
    CONFIG_MOBOX="Р’С‹Р±РѕСЂ РІРµСЂСЃРёРё Mobox"
    . "$PREFIX/glibc/opt/scripts/configs"
    load_configs
    show_message() {
        dialog --no-shadow \
        --msgbox "$1" 5 30
    }
    show_message_mobox() {
        dialog --no-shadow \
        --msgbox "$1" 6 36
    }
    handle_choice() {
        case $1 in
            1) 
            clear
            unset settings
if [ $WINE_START_86 = 0 ]; then
	dialog --no-shadow \
	--title "РЈСЃС‚Р°РЅРѕРІРєР° WINE-mono" \
       --yesno "\n
  РЈСЃС‚Р°РЅРѕРІРёС‚СЊ WINE-mono РІРѕ РІСЂРµРјСЏ РїРµСЂРІРѕРіРѕ\n
         Р·Р°РїСѓСЃРєР° Mobox box86?\n
Р”Р»СЏ СѓСЃС‚Р°РЅРѕРІРєРё РЅРµРѕР±С…РѕРґРёРј РёРЅС‚РµСЂРЅРµС‚ Рё ~500Mb\n
      РґРѕРїРѕР»РЅРёС‚РµР»СЊРЅРѕРіРѕ РїСЂРѕСЃС‚СЂР°РЅСЃС‚РІР°." 10 45
    response=$?
    if [ $response -eq 0 ]; then
        sed -i "139s/.*/WINE_86=ON/" "$wine_86"
    else
        sed -i "139s/.*/WINE_86=OFF/" "$wine_86"
    fi
        clear
fi
            . "$HOME/.shortcuts/,/Mobox box86"
            ;;
            2) termux-fix-shebang "$PREFIX/glibc/opt/scripts/mobox"
            mobox
            ;;
            3) 
            clear
            settings_game "$HOME/.shortcuts/,/Mobox box86" "weg"
;;
            4) 
			if [ -d "$wine" ]; then
    			show_main_menu
			else
    			dialog --no-shadow \
    			--title "рџљ« РћС€РёР±РєР°" --msgbox "Р”РёСЂРµРєС‚РѕСЂРёСЏ $wine РЅРµ РЅР°Р№РґРµРЅР°." 5 40
			fi
			;;
            5) 
cd "$PREFIX" || { echo "РќРµ СѓРґР°Р»РѕСЃСЊ РїРµСЂРµР№С‚Рё РІ РєР°С‚Р°Р»РѕРі $PREFIX"; exit 1; }
if [ -d "$PREFIX/glibc-wow64" ]; then
    mv $PREFIX/glibc $PREFIX/glibc-x86 || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc"; exit 1; }
    mv $PREFIX/glibc-wow64 $PREFIX/glibc || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc-wow64"; exit 1; }
    weg
    exit
else
    dialog --no-shadow \
    --title "РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" \
       --yesno "рџљ« Р¤Р°Р№Р»С‹ Mobox WoW64 РЅРµ РЅР°Р№РґРµРЅС‹,\n
   Р”РѕР±Р°РІС‚Рµ С„Р°Р№Р»С‹ Mobox WoW64." 6 36
    response=$?
    if [ $response -eq 0 ]; then
        mv glibc glibc-x86
        temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
        [ -d "$temp_dir" ] && rm -rf "$temp_dir"
        mkdir -p "$temp_dir"
        show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ wow64.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$temp_dir" wow64
        if [ -d "$PREFIX/glibc" ]; then
            mv "$PREFIX/glibc"
            mv "$PREFIX/glibc-x86"
        fi
        wow64_dir="$temp_dir/wow64"
        if [ -d "$wow64_dir" ]; then
            show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ С„Р°Р№Р»РѕРІ РёР· Р°СЂС…РёРІР°..." 2
            for archive in "$wow64_dir/"*; do
                if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                    tar -xf "$archive" -C "$PREFIX/"
                fi
            done
        else
        echo "РљР°С‚Р°Р»РѕРі $wow64_dir РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚."
        fi
            show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РћС‡РёСЃС‚РєР° РІСЂРµРјРµРЅРЅРѕРіРѕ РєР°С‚Р°Р»РѕРіР°..." 2
            rm -rf "$temp_dir"
            link_target="$PREFIX/glibc/opt/scripts/mobox"
                if [ -f "$link_target" ]; then
                    ln -sf $PREFIX/glibc/opt/scripts/mobox $PREFIX/bin/mobox
                    show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° СЃРѕР·РґР°РЅР°..." 2
                else
                    echo "Р¦РµР»РµРІРѕР№ С„Р°Р№Р» $link_target РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚. РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° РЅРµ СЃРѕР·РґР°РЅР°."
                fi
            else
            clear
        fi
        weg
        exit
    fi
;;
            1.) clear
            unset settings
if [ $WINE_START_64 = 0 ]; then
	dialog --no-shadow \
	--title "РЈСЃС‚Р°РЅРѕРІРєР° WINE-mono" \
       --yesno "\n
  РЈСЃС‚Р°РЅРѕРІРёС‚СЊ WINE-mono РІРѕ РІСЂРµРјСЏ РїРµСЂРІРѕРіРѕ\n
         Р·Р°РїСѓСЃРєР° Mobox WoW64?\n
Р”Р»СЏ СѓСЃС‚Р°РЅРѕРІРєРё РЅРµРѕР±С…РѕРґРёРј РёРЅС‚РµСЂРЅРµС‚ Рё ~500Mb\n
      РґРѕРїРѕР»РЅРёС‚РµР»СЊРЅРѕРіРѕ РїСЂРѕСЃС‚СЂР°РЅСЃС‚РІР°." 10 45
response=$?
if [ $response -eq 0 ]; then
sed -i "59s/.*/WINE_64=ON/" "$wine_64"
else
sed -i "59s/.*/WINE_64=OFF/" "$wine_64"
fi
clear
fi
            . "$HOME/.shortcuts/,/Mobox WoW64"
            ;;
            2.) termux-fix-shebang "$PREFIX/glibc/opt/scripts/mobox"
            mobox ;;
            3.) clear
            settings_game "$HOME/.shortcuts/,/Mobox WoW64" "weg";;
            4.)
			if [ -d "$wine" ]; then
				 show_main_menu
			else
    			dialog --no-shadow \
    			--title "рџљ« РћС€РёР±РєР°" --msgbox "Р”РёСЂРµРєС‚РѕСЂРёСЏ $wine РЅРµ РЅР°Р№РґРµРЅР°." 5 40
			fi
			;;
            5.) 
                cd "$PREFIX" || { echo "РќРµ СѓРґР°Р»РѕСЃСЊ РїРµСЂРµР№С‚Рё РІ РєР°С‚Р°Р»РѕРі $PREFIX"; exit 1; }
if [ -d "$PREFIX/glibc-x86" ]; then
    mv glibc glibc-wow64 || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc"; exit 1; }
    mv $PREFIX/glibc-x86 $PREFIX/glibc || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc-x86"; exit 1; }
    weg
    exit
else
    dialog --no-shadow \
    --title "РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" \
       --yesno "рџљ« Р¤Р°Р№Р»С‹ Mobox box86 РЅРµ РЅР°Р№РґРµРЅС‹,\n
   Р”РѕР±Р°РІС‚Рµ С„Р°Р№Р»С‹ Mobox box86." 6 36
    response=$?
    if [ $response -eq 0 ]; then
        mv glibc glibc-wow64
        temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
        [ -d "$temp_dir" ] && rm -rf "$temp_dir"
        mkdir -p "$temp_dir"
        show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ x86.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir" x86
        if [ -d "$PREFIX/glibc" ]; then
            mv "$PREFIX/glibc" 
            mv "$PREFIX/glibc-wow64"
        fi
        x86_dir="$temp_dir/x86"
        if [ -d "$x86_dir" ]; then
           show_progress "Р Р°СЃРїР°РєРѕРІРєР°" "вЏі РР·РІР»РµС‡РµРЅРёРµ С„Р°Р№Р»РѕРІ РёР· Р°СЂС…РёРІР°..." 2
            for archive in "$x86_dir/"*; do
                if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                    tar -xf "$archive" -C "$PREFIX/"
                fi
            done
        else
            echo "РљР°С‚Р°Р»РѕРі $x86_dir РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚."
        fi
    else
        clear
    fi
        weg
        exit
fi
                ;;
                6.)
                other_menu
                ;;
                7.)  dialog --no-shadow \
                --title "вќ—пёЏРџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ \n
         Mobox box86? \n
  Р РµРєРѕРјРµРЅРґСѓРµРј РїРµСЂРµРґ СѓРґР°Р»РµРЅРёРµРј \n
СЃРѕС…СЂР°РЅРёС‚СЊ РІСЃРµ РґР°РЅРЅС‹Рµ, С‚ Рє. РѕРЅРё \n
  Р±СѓРґСѓ СѓС‚СЂР°С‡РµРЅС‹ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ." 9 35
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf $PREFIX/glibc-x86
                elif [ $response -eq 1 ]; then
                    weg
                    exit
                fi
                ;;
                7)  
                dialog --no-shadow \
                --title "вќ—пёЏРџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ" --yesno "Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ \n
         Mobox WoW64? \n
Р РµРєРѕРјРµРЅРґСѓРµРј РїРµСЂРµРґ СѓРґР°Р»РµРЅРёРµРј \n
СЃРѕС…СЂР°РЅРёС‚СЊ РІСЃРµ РґР°РЅРЅС‹Рµ, С‚ Рє. РѕРЅРё \n
  Р±СѓРґСѓ СѓС‚СЂР°С‡РµРЅС‹ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ." 9 35
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf $PREFIX/glibc-wow64
                elif [ $response -eq 1 ]; then
                    weg
                    exit
                fi
                ;;
                рџЋ®)
show_progress "РЎРїРёСЃРѕРє РёРіСЂ" "вЏі Р—Р°РіСЂСѓР·РєР° СЃРїРёСЃРєР°" 2
bash -c "source \"$HOME/Settings\"" 
;;
        esac 
    }
wine_64="$HOME/.shortcuts/,/Mobox WoW64"
wine_86="$HOME/.shortcuts/,/Mobox box86"
    while true; do
dialog_text_86="Android:      $ANDROID_VERSION\n
РЈСЃС‚СЂРѕР№СЃС‚РІРѕ:   $DEVICE\n
РџСЂРѕС†РµСЃСЃРѕСЂ:    $CPU\n
РЇРґРµСЂ:         $CORES\n
Р’РёРґРµРѕРґСЂР°Р№РІРµСЂ: $GPU_MODEL\n
RAM РѕР±С‰РёР№ / РґРѕСЃС‚СѓРїРЅС‹Р№ (Gb): $FULL_RAM / $ACC_RAM\n
РСЃРїРѕР»СЊР·РѕРІР°РЅРЅС‹Р№ РѕР±СЉРµРј  (Gb): $USED_SSD\n
Р”РѕСЃС‚СѓРїРЅС‹Р№ РѕР±СЉРµРј       (Gb): $ACC_SSD\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
Р‘С‹СЃС‚СЂР°СЏ СѓСЃС‚Р°РЅРѕРІРєР° Mobox WoW64 Рё box86\n
   РЈРґРѕР±РЅР°СЏ РЅР°СЃС‚СЂРѕР№РєР° Рё Р·Р°РїСѓСЃРє Mobox\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
Р’С‹Р±РµСЂРёС‚Рµ РѕРїС†РёСЋ РґР»СЏ box86:"
dialog_text_64="Android:      $ANDROID_VERSION\n
РЈСЃС‚СЂРѕР№СЃС‚РІРѕ:   $DEVICE\n
РџСЂРѕС†РµСЃСЃРѕСЂ:    $CPU\n
РЇРґРµСЂ:         $CORES\n
Р’РёРґРµРѕРґСЂР°Р№РІРµСЂ: $GPU_MODEL\n
RAM РѕР±С‰РёР№ / РґРѕСЃС‚СѓРїРЅС‹Р№ (Gb): $FULL_RAM / $ACC_RAM\n
РСЃРїРѕР»СЊР·РѕРІР°РЅРЅС‹Р№ РѕР±СЉРµРј  (Gb): $USED_SSD\n
Р”РѕСЃС‚СѓРїРЅС‹Р№ РѕР±СЉРµРј       (Gb): $ACC_SSD\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
Р‘С‹СЃС‚СЂР°СЏ СѓСЃС‚Р°РЅРѕРІРєР° Mobox WoW64 Рё box86\n
   РЈРґРѕР±РЅР°СЏ РЅР°СЃС‚СЂРѕР№РєР° Рё Р·Р°РїСѓСЃРє Mobox\n
в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ\n
Р’С‹Р±РµСЂРёС‚Рµ РѕРїС†РёСЋ РґР»СЏ WoW64:"
if [ "$versioo_mob" = "86_WOW" ]; then
    if [ -n "$value" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_64="Р—Р°РїСѓСЃРє Mobox WoW64"
    WINE_START_64=1
else
    NAME_MENU_64="РЎРѕР·РґР°С‚СЊ РєРѕРЅС‚РµР№РЅРµСЂ WoW64"
    WINE_START_64=0
fi
        options64=(
    "рџЋ®" "РЎРїРёСЃРѕРє РРіСЂ СЃ РЅР°СЃС‚СЂРѕР№РєР°РјРё  рџЋ®"
    1. "$NAME_MENU_64"
    2. "РљР»Р°СЃСЃРёС‡РµСЃРєРѕРµ РјРµРЅСЋ Mobox"
    3. "РќР°СЃС‚СЂРѕР№РєРё Mobox WoW64"
    4. "РќР°СЃС‚СЂРѕР№РєРё WINE РґР»СЏ WoW64"
    5. "РџРµСЂРµР№С‚Рё РЅР° Mobox box86"
    6. "Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РїР°СЂР°РјРµС‚СЂС‹"
)
        if [ -d "$PREFIX/glibc-x86" ]; then
    options64+=(7. "РЈРґР°Р»РёС‚СЊ Mobox box86")
        fi
      menu_height=$((19 + ${#options64[@]}/2))
choice=$(dialog --no-shadow \
--title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "$dialog_text_64" "$menu_height" 43 "${#options64[@]}" "${options64[@]}" 2>&1 >/dev/tty)
    else
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_86="Р—Р°РїСѓСЃРє Mobox box86"
    WINE_START_86=1
else
    NAME_MENU_86="РЎРѕР·РґР°С‚СЊ РєРѕРЅС‚РµР№РЅРµСЂ box86"
    WINE_START_86=0
fi
options86=(
    "рџЋ®" "РЎРїРёСЃРѕРє РРіСЂ СЃ РЅР°СЃС‚СЂРѕР№РєР°РјРё  рџЋ®"
    1 "$NAME_MENU_86"
    2 "РљР»Р°СЃСЃРёС‡РµСЃРєРѕРµ РјРµРЅСЋ Mobox"
    3 "РќР°СЃС‚СЂРѕР№РєРё Mobox box86"
    4 "РќР°СЃС‚СЂРѕР№РєРё WINE РґР»СЏ box86"
    5 "РџРµСЂРµР№С‚Рё РЅР° Mobox WoW64"
    6. "Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РїР°СЂР°РјРµС‚СЂС‹"
)
    if [ -d "$PREFIX/glibc-wow64" ]; then
    options86+=(7 "РЈРґР°Р»РёС‚СЊ Mobox WoW64")
    fi
    menu_height=$((19 + ${#options86[@]}/2))
choice=$(dialog --no-shadow \
--title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "$dialog_text_86" "$menu_height" 43 "${#options86[@]}" "${options86[@]}" 2>&1 >/dev/tty)
fi
elif [ "$versioo_mob" = "WOW" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_64="Р—Р°РїСѓСЃРє Mobox WoW64"
    WINE_START_64=1
        else
    NAME_MENU_64="РЎРѕР·РґР°С‚СЊ РєРѕРЅС‚РµР№РЅРµСЂ WoW64"
    WINE_START_64=0
        fi
options_64=(
    "рџЋ®" "РЎРїРёСЃРѕРє РРіСЂ СЃ РЅР°СЃС‚СЂРѕР№РєР°РјРё  рџЋ®"
    1. "$NAME_MENU_64"
    2. "РљР»Р°СЃСЃРёС‡РµСЃРєРѕРµ РјРµРЅСЋ Mobox"
    3. "РќР°СЃС‚СЂРѕР№РєРё Mobox WoW64"
    4. "РќР°СЃС‚СЂРѕР№РєРё WINE РґР»СЏ WoW64"
    6. "Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РїР°СЂР°РјРµС‚СЂС‹"
)
choice=$(dialog --no-shadow \
--title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "$dialog_text_64" 17 41 "${#options_64[@]}" "${options_64[@]}" 2>&1 >/dev/tty)
elif [ "$versioo_mob" = "86" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_86="Р—Р°РїСѓСЃРє Mobox box86"
    WINE_START_86=1
        else
    NAME_MENU_86="РЎРѕР·РґР°С‚СЊ РєРѕРЅС‚РµР№РЅРµСЂ box86"
    WINE_START_86=0
        fi
options_86=(
    "рџЋ®" "РЎРїРёСЃРѕРє РРіСЂ СЃ РЅР°СЃС‚СЂРѕР№РєР°РјРё  рџЋ®"
    1 "$NAME_MENU_86"
    2 "РљР»Р°СЃСЃРёС‡РµСЃРєРѕРµ РјРµРЅСЋ Mobox"
    3 "РќР°СЃС‚СЂРѕР№РєРё Mobox box86"
    4 "РќР°СЃС‚СЂРѕР№РєРё WINE РґР»СЏ box86"
    6. "Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РїР°СЂР°РјРµС‚СЂС‹"
)
choice=$(dialog --no-shadow \
--title "WEGв„ўвљЎпёЏMobox Menu v5.3" --menu "$dialog_text_86" 17 41 "${#options_86[@]}" "${options_86[@]}" 2>&1 >/dev/tty)
fi
        case $? in
            1) break ;;
            255) continue ;;
        esac
        handle_choice "$choice"
    done
    clear
    exit
else
    if [ -d "$PREFIX/glibc-x86" ]; then
    mv "$PREFIX/glibc-x86" "$PREFIX/glibc" || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc-x86"; exit 1; }
    weg
    exit
fi
if [ -d "$PREFIX/glibc-wow64" ]; then
    mv "$PREFIX/glibc-wow64" "$PREFIX/glibc" || { echo "РћС€РёР±РєР° РїСЂРё РїРµСЂРµРёРјРµРЅРѕРІР°РЅРёРё glibc-wow64"; exit 1; }
    weg
    exit
fi
if [ -e "$PREFIX/glibc" ]; then
    echo -n "РЈРґР°Р»РµРЅРёРµ РїСЂРµРґС‹РґСѓС‰РµРіРѕ glibc. РџСЂРѕРґРѕР»Р¶РёС‚СЊ? (Y/n) "
    read i
    if [ "$i" != "Y" ] && [ "$i" != "y" ]; then
        exit 1
    fi
    rm -rf "$PREFIX/glibc" "$PREFIX/glibc-x86" "$PREFIX/glibc-wow64"
fi
temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
[ -d "$temp_dir" ] && rm -rf "$temp_dir"
mkdir -p "$temp_dir"
show_progress "Р Р°СЃРїР°РєРѕРІРєР° С„Р°Р№Р»Р°" "вЏі Mobox.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/mobox.tar.gz" -C "$temp_dir"
x86_dir="$temp_dir/mobox/x86"
if [ -d "$x86_dir" ]; then
    show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі Mobox box86..." 2
    for archive in "$x86_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    echo "РљР°С‚Р°Р»РѕРі $x86_dir РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚."
fi
if [ -d "$PREFIX/glibc" ]; then
    mv "$PREFIX/glibc" "$PREFIX/glibc-x86"
fi
wow64_dir="$temp_dir/mobox/wow64"
if [ -d "$wow64_dir" ]; then
    show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі Mobox WoW64..." 2
    for archive in "$wow64_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    echo "РљР°С‚Р°Р»РѕРі $wow64_dir РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚."
fi
show_progress "РЈСЃС‚Р°РЅРѕРІРєР°" "вЏі РЈРґР°Р»РµРЅРёРµ РІСЂРµРјРµРЅРЅС‹С… С„Р°Р№Р»РѕРІ..." 2
rm -rf "$temp_dir"
link_target="$PREFIX/glibc/opt/scripts/mobox"
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "Р—Р°РіСЂСѓР·РєР° РјРµРЅСЋ" "вЏі РЎРєР°РЅРёСЂРѕРІР°РЅРёРµ РєРѕРјРїРѕРЅРµРЅС‚РѕРІ..." 2
else
    echo "Р¦РµР»РµРІРѕР№ С„Р°Р№Р» $link_target РЅРµ СЃСѓС‰РµСЃС‚РІСѓРµС‚. РЎРёРјРІРѕР»РёС‡РµСЃРєР°СЏ СЃСЃС‹Р»РєР° РЅРµ СЃРѕР·РґР°РЅР°."
fi
weg
exit
fi
EOF
chmod +x "$PREFIX/bin/weg"
kill -9 $DIALOG_PID 2>/dev/null
weg
exit
else
        archive_install
        weg_menu_install
        exit
    fi
}
setup_mobox
