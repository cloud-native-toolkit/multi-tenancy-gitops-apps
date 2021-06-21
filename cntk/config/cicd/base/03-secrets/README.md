This directory holds secrets in an encrypted way, please never store plain text or base64 encoded credentials on git.
We use open source project Sealed secrets https://github.com/bitnami-labs/sealed-secrets from bitnami, this secrets are stored in git in base64 but the data is encrypted at rest on git
