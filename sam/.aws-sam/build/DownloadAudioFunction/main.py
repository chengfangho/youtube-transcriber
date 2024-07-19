import os
import boto3
import subprocess
import json
from pytubefix import YouTube
from pytubefix.cli import on_progress

s3 = boto3.client("s3")

def lambda_handler(event, context):
    body = json.loads(event["body"])
    url = body["url"]
    video = YouTube(url, on_progress_callback = on_progress)

    video_name = video.title

    audio_stream = video.streams.get_audio_only()
    audio_stream.download('/tmp/',video_name, mp3=True)

    # Upload to S3
    bucket_name = "audio-bucket-715"
    s3_key = f"{video_name}.mp3"
    s3.upload_file(f'/tmp/{video_name}.mp3', bucket_name, s3_key)

    return {
        "statusCode": 200,
        "body": f"Audio file uploaded to S3://{bucket_name}/{s3_key}",
    }
