import boto3
import json
import urllib.parse
from datetime import datetime

transcribe = boto3.client("transcribe")
s3 = boto3.client("s3")


def lambda_handler(event, context):
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )
    job_uri = f"s3://{bucket_name}/{key}"
    job_name = datetime.now().strftime("%Y%m%d_%H%M%S")

    transcribe.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={"MediaFileUri": job_uri},
        MediaFormat="mp3",
        LanguageCode="zh-TW",
        OutputBucketName=bucket_name,
        Subtitles={"Formats": ["srt"]},
    )

    return {"statusCode": 200, "body": json.dumps({
            "message": "Transcription job started."
        })}
