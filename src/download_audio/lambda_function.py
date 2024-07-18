import os
import boto3
from pytube import YouTube
import subprocess
import json

s3 = boto3.client('s3')

def lambda_handler(event, context):
    body = json.loads(event['body'])
    url = body['url']
    video = YouTube(url)
    video_name = video.title
    audio_stream = video.streams.filter(only_audio=True).first()
    audio_stream.download('/tmp', f'{video_name}.mp4')

    # Convert to audio file if necessary
    ffmpeg_path = '/var/task/bin/ffmpeg'
    input_file = f'/tmp/{video_name}.mp4'
    output_file = f'/tmp/{video_name}.mp3'
    subprocess.run([ffmpeg_path, '-i', input_file, output_file])

    # Upload to S3
    bucket_name = 'audio-bucket-cheng'
    s3_key = f'audio/{video_name}.mp3'
    s3.upload_file(output_file, bucket_name, s3_key)
    
    return {
        'statusCode': 200,
        'body': f'Audio file uploaded to S3://{bucket_name}/{s3_key}'
    }
