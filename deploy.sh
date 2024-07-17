cd sam
sam build || \
    { echo "ERROR: building with sam failed"; exit 1; }
mkdir -p ../build
rm -f ../build/lambda.zip

cd ../src
zip -r ../build/lambda.zip .

cd ..
aws s3 cp build/lambda.zip s3://transcriber-deployment-package-bucket-715/lambda.zip

cd terraform
terraform apply
cd ..
