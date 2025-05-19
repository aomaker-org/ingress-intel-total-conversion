#!/usr/bin/env python3
import os
import sys
import subprocess
from pathlib import Path

# Define a threshold for "small" files (e.g., in bytes).
# 2KB = 2048 bytes. Files smaller than this will be printed to console.
SMALL_FILE_THRESHOLD_BYTES = 2048

def copy_to_clipboard(text_content):
    """Copies the given text content to the system clipboard using clip.exe."""
    try:
        # clip.exe is a Windows command, accessible in WSL
        process = subprocess.Popen(
            ["clip.exe"],
            stdin=subprocess.PIPE,
            text=True, # Work with text, ensure proper encoding handling
            encoding='utf-8', # Specify encoding for the pipe
            errors='replace'  # Replace characters that can't be encoded
        )
        process.communicate(input=text_content)
        if process.returncode == 0:
            return True
        else:
            print(f"Error: clip.exe failed with code {process.returncode}")
            return False
    except FileNotFoundError:
        print("Error: clip.exe not found. Make sure it's accessible in your WSL PATH.")
        return False
    except Exception as e:
        print(f"An error occurred while copying to clipboard: {e}")
        return False

def process_file(file_path_str):
    """Processes a single file: displays if small, prompts, and copies to clipboard."""
    file_path = Path(file_path_str)
    if not file_path.is_file(): # also checks existence
        print(f"Error: File not found or is not a regular file: {file_path}")
        return

    print(f"\n--- Processing: {file_path.name} (Full path: {file_path.resolve()}) ---")

    try:
        content = file_path.read_text(encoding='utf-8', errors='replace')
        file_size_bytes = file_path.stat().st_size

        is_small = file_size_bytes < SMALL_FILE_THRESHOLD_BYTES

        if is_small:
            print("Content (small file):")
            print("--------------------------------------------------")
            print(content.strip())
            print("--------------------------------------------------")
        else:
            print(f"Content is large ({file_size_bytes} bytes). Preview not shown.")

        while True:
            try:
                # Prompt user
                user_input = input(f"Copy content of '{file_path.name}' to clipboard? (y/N): ").strip().lower()
                if user_input in ['y', 'yes']:
                    if copy_to_clipboard(content):
                        print(f"'{file_path.name}' content COPIED to clipboard. You can now paste it.")
                    else:
                        print(f"Failed to copy '{file_path.name}' to clipboard.")
                    break
                elif user_input in ['n', 'no', '']: # Default to No if Enter is pressed
                    print(f"Skipped copying '{file_path.name}'.")
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            except EOFError: # Handle Ctrl+D or piped input
                print(f"\nSkipped '{file_path.name}' due to EOF.")
                break
            except KeyboardInterrupt:
                print(f"\nSkipped '{file_path.name}' due to user interrupt (Ctrl+C).")
                # Optionally, re-raise or exit if you want the whole script to stop
                # raise
                return # Stop processing this file, move to next if any

    except Exception as e:
        print(f"Error processing file {file_path}: {e}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 fek_wip/catclip.py <file1> [file2 ...]")
        print("Example: python3 fek_wip/catclip.py build.py mobile/app/build.gradle")
        return

    files_to_process = sys.argv[1:]
    print(f"Script 'catclip.py' started. Files to process: {files_to_process}")

    for f_path_str in files_to_process:
        process_file(f_path_str)
        # Add a small visual separator between files if processing many
        if len(files_to_process) > 1:
            print("==================================================")


    print("\nScript 'catclip.py' finished.")

if __name__ == "__main__":
    main()
