#!/bin/bash

# --- Reusable function for selecting or entering a directory ---
select_directory() {
    echo "Available folders in the current directory:"
    echo "-------------------------------------------"

    folder_count=$(find . -maxdepth 1 -type d ! -name "." | wc -l)

    select dir in */ "Enter a custom directory"; do
        if [[ "$REPLY" == "$((folder_count + 1))" ]]; then
            read -p "Enter your custom directory: " SELECTED_DIR
            if [ -d "$SELECTED_DIR" ]; then
                echo "Using existing directory: '$SELECTED_DIR'"
            else
                echo "Creating new directory: '$SELECTED_DIR'"
                mkdir -p "$SELECTED_DIR"
            fi
            break
        elif [ -n "$dir" ]; then
            SELECTED_DIR="$dir"
            echo "Using existing directory: '$SELECTED_DIR'"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

# --- Download music using spotdl ---
download_music() {
    select_directory
    read -p "Enter Spotify playlist URL: " SPOTIFY_URL
    mkdir -p "$SELECTED_DIR"
    echo ""
    echo "🎧 Downloading tracks and generating lyrics..."
    spotdl --bitrate 320k --generate-lrc --output "$SELECTED_DIR" "$SPOTIFY_URL"
    echo "✅ Download and lyrics generation complete in '$SELECTED_DIR'!"
}

# --- Generate .m3u playlist ---
generate_playlist() {
    select_directory
    read -p "Enter the playlist name (without .m3u extension): " playlist_name
    cd "$SELECTED_DIR" || exit
    if ls *.mp3 1> /dev/null 2>&1; then
        ls *.mp3 | sed 's|^|./|' > "$playlist_name.m3u"
        echo "🎼 Playlist created: $playlist_name.m3u"
    else
        echo "⚠️ No MP3 files found. Cannot create playlist."
    fi
}

# --- Embed lyrics using eyeD3 ---
embed_lyrics() {
    select_directory
    echo ""
    echo "📥 Embedding lyrics into MP3 files in '$SELECTED_DIR'..."
    shopt -s nullglob
    mp3_files=("$SELECTED_DIR"/*.mp3)

    if [ ${#mp3_files[@]} -eq 0 ]; then
        echo "⚠️ No MP3 files found. Skipping lyrics embedding."
        return
    fi

    for file in "${mp3_files[@]}"; do
        lrc_file="${file%.mp3}.lrc"
        if [ -f "$lrc_file" ]; then
            echo "✅ Embedding lyrics into: $file"
            eyeD3 --add-lyrics "$lrc_file" "$file"
        else
            echo "⛔ No matching lyrics file for: $file"
        fi
    done

    echo "✨ Lyrics embedding complete!"
}

# --- Main menu ---
while true; do
    echo ""
    echo "🎛️  N-Music Script Menu"
    echo "-----------------------------"
    echo "1) Run ALL (download + playlist + lyrics)"
    echo "2) Only download music"
    echo "3) Only generate .m3u playlist"
    echo "4) Only embed lyrics into MP3s"
    echo "5) Exit"
    echo "-----------------------------"
    read -p "Choose an option: " choice

    case "$choice" in
        1)
            download_music
            generate_playlist
            embed_lyrics
            ;;
        2)
            download_music
            ;;
        3)
            generate_playlist
            ;;
        4)
            embed_lyrics
            ;;
        5)
            echo "👋 Exiting. Have a good session!"
            break
            ;;
        *)
            echo "❌ Invalid option. Please try again."
            ;;
    esac
done
