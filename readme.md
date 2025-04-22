# 🎵 N-Music Tool

A bash script utility for managing your music collection with features for downloading music from Spotify, creating playlists, and embedding lyrics.

![License](https://img.shields.io/badge/license-MIT-green)
![Bash Version](https://img.shields.io/badge/bash-4.0%2B-blue)

## 📋 Features

- **Spotify Playlist Downloads**: Download entire playlists from Spotify in 320kbps MP3 format
- **Automatic Lyrics Generation**: Generate synchronized .lrc lyric files during download
- **Playlist Management**: Easily create .m3u playlists from your music collection
- **Lyrics Embedding**: Embed lyrics directly into MP3 files for better compatibility with music players

## 🔧 Requirements

- [spotdl](https://github.com/spotDL/spotify-downloader) - For downloading music from Spotify
- [eyeD3](https://eyed3.readthedocs.io/en/latest/) - For manipulating MP3 file metadata
- Bash 4.0 or higher

## 🚀 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/username/n-music-tool.git
   cd n-music-tool
   ```

2. Make the script executable:
   ```bash
   chmod +x n-music.sh
   ```

3. Install dependencies:
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install python3-pip
   pip3 install spotdl eyeD3
   
   # On macOS
   brew install python3
   pip3 install spotdl eyeD3
   ```

## 📖 Usage

Run the script by executing:

```bash
./n-music.sh
```

### Interactive Menu Options

The script provides an interactive menu with the following options:

1. **Run ALL** - Download music, generate playlist, and embed lyrics in one go
2. **Only download music** - Download tracks from a Spotify playlist URL
3. **Only generate .m3u playlist** - Create a playlist from existing MP3 files
4. **Only embed lyrics into MP3s** - Embed .lrc lyrics into your MP3 files
5. **Exit** - Exit the script

For each operation, you'll be prompted to select or enter a directory where the files are stored or where you want them to be saved.

### Directory Selection

When prompted, you can either:
- Select an existing directory from the numbered list
- Choose "Enter a custom directory" to input a custom path

If the directory doesn't exist, it will be created automatically.

## 📝 Examples

### Downloading a Spotify Playlist

1. Choose option 2 from the main menu
2. Select or enter a directory for the downloads
3. Paste your Spotify playlist URL when prompted
4. The script will download all tracks and generate lyric files

### Creating a Playlist

1. Choose option 3 from the main menu
2. Select the directory containing your MP3 files
3. Enter a name for your playlist
4. A .m3u file will be created with all MP3 files in the directory

### Embedding Lyrics

1. Choose option 4 from the main menu
2. Select the directory containing your MP3 files and corresponding .lrc files
3. The script will embed lyrics from each .lrc file into its corresponding MP3 file

## ⚠️ Notes

- This tool requires a working internet connection for downloading music
- Make sure spotdl is properly configured with your Spotify credentials
- The script assumes MP3 and LRC files have matching filenames (excluding extensions)

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/username/n-music-tool/issues).

## 👏 Acknowledgments

- [spotDL](https://github.com/spotDL/spotify-downloader) for the Spotify downloading functionality
- [eyeD3](https://eyed3.readthedocs.io/en/latest/) for MP3 metadata manipulation capabilities