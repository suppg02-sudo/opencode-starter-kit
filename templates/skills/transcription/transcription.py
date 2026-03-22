#!/usr/bin/env python3
"""
Transcription Skill Implementation - Working Version
"""

import subprocess
import json
from pathlib import Path


def execute_command(command: str, timeout: int = 30) -> dict:
    """Execute command and return result with timeout"""
    result = subprocess.run(
        command,
        shell=True,
        capture_output=True,
        text=True,
        timeout=timeout
    )
    return {
        "code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }


def transcribe_youtube(url: str, output_dir: str = "/media/docs/output") -> dict:
    """Transcribe YouTube video using youtube-transcript-api"""
    
    import subprocess
    from pathlib import Path
    
    print(f"Transcribing: {url}")
    
    # Extract video ID from URL
    import re
    video_id_match = re.search(r'[?&]v=([^&]+)', url)
    video_id = video_id_match.group(1) if video_id_match else url.split('/')[-1]
    
    # Use youtube-transcript-api to get real transcript
    try:
        result = subprocess.run(
            ['pipx', 'run', 'youtube_transcript_api', video_id, '--format', 'json'],
            capture_output=True,
            text=True,
            timeout=60,
            check=True
        )
        
        if result.returncode != 0:
            return {"code": result.returncode, "error": f"Transcription failed: {result.stderr}"}
        
        transcript_data = json.loads(result.stdout)
        
    except (subprocess.CalledProcessError, json.JSONDecodeError) as e:
        return {"code": 1, "error": f"Failed to get transcript: {str(e)}"}
    except Exception as e:
        return {"code": 1, "error": f"Error: {str(e)}"}
    
    # Process transcript data (youtube-transcript-api returns nested list structure)
    if isinstance(transcript_data, list) and len(transcript_data) == 1 and isinstance(transcript_data[0], list):
        # Handle nested list: [[{...}, {...}]]
        transcript_segments = transcript_data[0]
        full_text = "\n".join([seg.get('text', '') for seg in transcript_segments if isinstance(seg, dict)])
        duration = sum(seg.get('duration', 0) for seg in transcript_segments if isinstance(seg, dict))
    elif isinstance(transcript_data, list) and len(transcript_data) > 0:
        # Handle flat list: [{...}, {...}]
        transcript_segments = transcript_data
        full_text = "\n".join([seg.get('text', '') for seg in transcript_segments if isinstance(seg, dict)])
        duration = sum(seg.get('duration', 0) for seg in transcript_segments if isinstance(seg, dict))
    elif isinstance(transcript_data, dict):
        # Single dict: API returned full transcript as one object
        full_text = transcript_data.get('text', '')
        duration = transcript_data.get('duration', 0)
    else:
        # Fallback for unexpected data format (string, number, etc.)
        full_text = str(transcript_data)
        duration = 0
    
    output_path = f"{output_dir}/transcription-{video_id}.json"
    with open(output_path, "w") as f:
        json.dump({
            "url": url,
            "video_id": video_id,
            "full_text": full_text,
            "duration": duration,
            "word_count": len(full_text.split()),
            "status": "completed",
            "title": f"Video {video_id} Transcript"
        }, f, indent=2)
    
    print(f"Transcript saved to: {output_path}")
    return {"code": 0, "output": output_path}


def main(args: list) -> dict:
    """Main dispatcher for Transcription skill"""
    if len(args) < 1:
        return {"code": 1, "error": "Usage: transcription.py [transcribe] [url]"}
    
    action = args[0]
    
    if action == "transcribe":
        url = args[1] if len(args) > 1 else ""
        return transcribe_youtube(url)
    
    else:
        return {"code": 1, "error": f"Unknown action: {action}"}


if __name__ == "__main__":
    import sys
    result = main(sys.argv[1:])
    print(result.get("output", result.get("error", "Success" if result["code"] == 0 else f"Error: {result['code']}")))
    sys.exit(result["code"])
