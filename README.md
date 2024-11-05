# Peon Media Hosting

## Overview

This Terraform script provisions an S3 bucket and a CloudFront distribution in your AWS account for media hosting. The
solution supports two access methods: **Public** and **Signed URLs**. You can store and access media files based on your
access requirements, ensuring secure and efficient media delivery.

### Short videos to get familiar with the technologies used in this project
- [Terraform](https://www.youtube.com/watch?v=tomUWcQ0P3k)
- [AWS](https://www.youtube.com/watch?v=JIbIYCM48to)
- [S3](https://youtu.be/JIbIYCM48to?si=6KdJaJTJHaLf-3Rp&t=281)
- [CloudFront](https://www.youtube.com/watch?v=AT-nHW3_SVIhttps://www.youtube.com/watch?v=AT-nHW3_SVI)
- [Signed URLs with Node.js](https://www.youtube.com/watch?v=EIYrhbBk7do)

### Disclaimer

- This script effectively creates two AWS resources: an __S3 bucket__ and a __CloudFront distribution__.
  - __Both may incur costs__
    - [CloudFront Pricing](https://aws.amazon.com/cloudfront/pricing/)
    - [S3 Pricing](https://aws.amazon.com/s3/pricing/)
  - __The cost is same as if you would create these resources manually__
- This solution does not handle media optimization.

---

## Project Setup

### Prerequisites

- [Setup Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  - A/ Use Terraform Cloud to store the infrastructure state
    - Create [Terraform Account](https://app.terraform.io/public/signup/account)
    - Create [Terraform Organization](https://app.terraform.io/app/organizations)
      - Name of the organization must match the name specified in `backend.tf` - feel free to rename it
      - Workspace will be automatically created based on `backend.tf`
  - B/ Use local backend to store the infrastructure state
    - Setup [local backend](https://developer.hashicorp.com/terraform/language/backend/local)
- [Setup AWS CLI](https://www.youtube.com/watch?v=_DIRSI07kxY)
- [Create and upload SSH key to sign urls](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-trusted-signers.html#create-key-pair-and-key-group)
- Add Key Group vars
  - Go to AWS CloudFront [key groups](https://console.aws.amazon.com/cloudfront/v4/home#/keygrouplist)
  - Copy id of the key group you previously created
  - Paste it into variables.tf `cloudfront_key_group_id.default`
- (optional) Feel free to change project_name in variables.tf, "pmh-origin" in main.tf and "pmh" prefix use for service naming

### Setup

1. Clone the repository to your local environment
2. Navigate to the project directory
3. Initialize the project by running the following command `terraform init`
4. Provision the infrastructure by running `terraform apply`

### Terraform Commands

Use the following commands to manage your Terraform infrastructure:

- **Initialize the project:**
  ```bash
  terraform init
  ```

- **Apply the configuration to create resources:**
  ```bash
  terraform apply
  ```

- **Destroy the infrastructure:**
  ```bash
  terraform destroy
  ```

---

## Usage

The media hosting solution can be utilized in two distinct ways:

### Public Access

Public files are stored in the `assets` folder within the S3 bucket, accessible via a direct URL generated from the
CloudFront distribution.

**Steps to Access Public Files:**

1. Upload the media file to the `assets` folder in the S3 bucket.
2. Access the file by combining the CloudFront distribution URL with the media file path in S3: `https://<cloudfront_distribution_domain>/assets/<path_to_file>`
   - Replace `<cloudfront_distribution_domain>` with the actual CloudFront distribution domain, and `<path_to_file>` with
   the path of the media file in the `assets` folder.

### Signed URL Access

Files outside the `assets` folder require a signed URL for access, providing an extra layer of security. Signed URLs can
be generated programmatically using the AWS SDK.

**Example Signed URL Format:**

```
https://<s3_bucket_name>.s3.<region>.amazonaws.com/<path_to_file>?X-Amz-Algorithm=<algorithm>&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=<credential>&X-Amz-Date=<date>&X-Amz-Expires=<expires>&X-Amz-Signature=<signature>&X-Amz-SignedHeaders=host&x-id=GetObject
```

**Steps to Access Files Using Signed URLs:**

1. Generate a signed URL using the [AWS SDK](https://www.npmjs.com/package/aws-sdk).
2. (Optional) Store the signed URL in a database for future access.
3. Use the signed URL to securely load the media file.

---

## Notes

- Only files in the `assets` folder are publicly accessible; all other files require signed URLs.
- Ensure that sensitive information, like AWS credentials, is handled securely.
- Look up tf documentation for more information about S3 and ClodFront modules configuration (especially expiration times).
- CloudFront cache invalidation:
  - Go to `AWS -> CloudFront -> Distributions -> Invalidations`
  - Click `Create invalidation` button
  - Enter object path (wildcards can be used)