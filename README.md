# Ackee Vault unsealer

## Purpose
This code is meant to be running inside the Kubernetes pod as a CronJob. This
solution is exclusively using [Google Cloud Platform](https://cloud.google.com/),
porting to different platforms would most likely require a great slaughter.

Please note that *ackee-vault-unsealer* is not trying to separate you from the
all the hassle with Vault. This tool does only one thing - it unseals the Vault based
on the schedule specified in the CronJob manifest file. The rest is up to you.

## Used GCP products:
- Google Kubernetes Engine
- Google Cloud Storage
- Google Cloud Key Management Service

## Configuration
Configuration is done via environment variables.

| **Variable name**              | **Example**                                    |
| ------------------------------ |----------------------------------------------- |
| VAULT_ADDR                     | `https://vault.yourdomain.co.uk`               |
| GCP_PROJECT_NAME               | `test-cloud-01-123456`                         |
| GCP_KEY_RING_LOCATION          | `europe-west3`                                 |
| GCP_KEY_RING_NAME              | `key-ring`                                     |
| GCP_KEY_NAME                   | `key01`                                        |
| GCP_STORAGE_BUCKET_NAME        | `my-gcs-bucket-name01`                         |
| GOOGLE_APPLICATION_CREDENTIALS | `/etc/secrets/gcp/key.json`                    |
| VAULT_KEYS_FILE_NAMES          | `vault-unseal-0,vault-unseal-1,vault-unseal-2` |

## Prepare your environment for using ackee-vault-unsealer

1. Enable Google Cloud Key Management Service
2. Create keyring and key in the KMS section
2. In the GCP IAM section crate a new Service Account
3. Generare a new key for the previously created Service Account
4. Set propper IAM binding for the previously created SA ([source](https://codelabs.developers.google.com/codelabs/vault-on-gke/index.html?index=..%2F..%2Fcloud#5))

  ```bash
  gcloud kms keys add-iam-policy-binding ${GCP_KEY_NAME} \
    --location ${GCP_KEY_RING_LOCATION} \
    --keyring ${GCP_KEY_RING_NAME} \
    --member "serviceAccount:${SERVICE_ACCOUNT}" \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter
  ```

4. Create a new GCS bucket, set correct permissions for the previously created SA
5. Initialize Vault, download JSON file with unseal keys
6. Put each unseal key into separate file
7. Encrypt these files

  ```bash
  gcloud kms encrypt \
    --key ${GCP_KEY_NAME} \
    --keyring ${GCP_KEY_RING_NAME} \
    --location ${GCP_KEY_RING_LOCATION} \
    --plaintext-file /tmp/plaintext-key.01.txt \
    --ciphertext-file /tmp/encrypted-key.01.bin
  ```

8. Upload **encrypted** files to the previously created GCS bucket
9. Deploy ackee-vault-unsealer

## Sample output when everything works fine

```
E  /usr/local/bin/ruby lib/unsealer.rb
I  I, [2018-10-16T06:20:03.853547 #6]  INFO -- : Vault http://vault:8200 is already unsealed
```
