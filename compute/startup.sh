#!/bin/bash
BUCKET_ID="epam-tf-lab-xn_8e"
COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
COMPUTE_INSTANCE_ID=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
TEXT="This message was generated on instance ${COMPUTE_INSTANCE_ID} with the following UUID ${COMPUTE_MACHINE_UUID}"
touch /tmp/${COMPUTE_INSTANCE_ID}.txt
echo "$TEXT" > /tmp/${COMPUTE_INSTANCE_ID}.txt
gsutil -m cp /tmp/${COMPUTE_INSTANCE_ID}.txt gs://${BUCKET_ID}

apt update
apt install -y nginx
echo "$TEXT" | sudo tee /var/www/html/index.html
systemctl restart nginx