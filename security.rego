name: Terraform with OPA (DENY)

on:
  push:
    branches: [ "main" ]

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_DEFAULT_REGION }}

    - name: Install Terraform
      uses: hashicorp/setup-terraform@v3

    - name: Install OPA
      run: |
        curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
        chmod +x opa
        sudo mv opa /usr/local/bin/opa

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan -out=tfplan

    - name: Convert Plan to JSON
      run: terraform show -json tfplan > tf.json

    - name: Run OPA DENY Policies
      run: |
        echo "🔍 Running OPA DENY checks..."

        DENY=$(opa eval --format=raw --data security.rego --input tf.json "data.terraform.security.deny")

        echo "$DENY"

        if echo "$DENY" | grep -q "❌"; then
          echo "🚫 OPA policy violations detected. Blocking Terraform."
          exit 1
        else
          echo "✅ OPA checks passed. No blocking violations."
        fi

    - name: Terrafo

