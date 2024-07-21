cd sam
sam build || \
    { echo "ERROR: building with sam failed"; exit 1; }
mkdir -p ../build
rm -f ../build/lambda.zip

cd ../sam/.aws-sam/build/DownloadAudioFunction
zip -r ../../../../build/audio_downloader_lambda.zip .

cd ../../../../src
zip -r ../build/lambda.zip .

cd ..
aws s3 cp build/audio_downloader_lambda.zip s3://transcriber-deployment-package-bucket-715/audio_downloader_lambda.zip
aws s3 cp build/lambda.zip s3://transcriber-deployment-package-bucket-715/lambda.zip

cd terraform
terraform apply -auto-approve | tee terraform_output.log

if grep -q "Apply complete!" terraform_output.log; then
    API_URL=$(terraform output -raw api_gateway_invoke_url)
    cd ../app
    sed -i.bak "s|const invoke_url = .*|const invoke_url = '$API_URL'|g" src/App.js
    npm start
    else
    echo "Please check error message or run terraform apply again."
    exit 1
fi

rm terraform_output.log