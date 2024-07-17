import json
import urllib.parse
import boto3
from botocore.exceptions import ClientError
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

print("Loading function")

s3_client = boto3.client("s3")
ses_client = boto3.client("ses")


def lambda_handler(event, context):
    # print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )
    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        file_content = response["Body"].read()
        send_email_with_attachment(key, file_content)
    except Exception as e:
        print(e)
        print(
            "Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.".format(
                key, bucket
            )
        )
        raise e


def send_email_with_attachment(object_key, file_content):
    sender = "ho0564611@gmail.com"
    recipient = "ho0564611@gmail.com"
    subject = "New video transcript available"
    body_text = f"Transcript for {object_key} has been processed."
    charset = "utf-8"

    # Create the email body
    body_html = f"""
    <html>
    <head></head>
    <body>
      <h1>New video transcript available</h1>
      <p>Transcript for {object_key} has been processed..</p>
    </body>
    </html>
    """

    # Attachment details
    attachment = {
        "Name": object_key,
        "Data": file_content,
    }

    # Create the email
    msg = MIMEMultipart("mixed")
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = recipient

    # Add the body to the email
    msg_body = MIMEMultipart("alternative")
    textpart = MIMEText(body_text, "plain", charset)
    htmlpart = MIMEText(body_html, "html", charset)
    msg_body.attach(textpart)
    msg_body.attach(htmlpart)

    # Attach the body to the email
    msg.attach(msg_body)

    # Add the attachment
    attachment_part = MIMEApplication(file_content)
    attachment_part.add_header("Content-Disposition", "attachment", filename=object_key)
    msg.attach(attachment_part)

    try:
        # Provide the contents of the email
        response = ses_client.send_raw_email(
            Source=sender,
            Destinations=[recipient],
            RawMessage={
                "Data": msg.as_string(),
            },
        )
    except ClientError as e:
        print(f"Error: {e}")
        raise e
