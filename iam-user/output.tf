locals {
  has_encrypted_password = length(compact(aws_iam_user_login_profile.user_login[*].encrypted_password)) > 0
  has_encrypted_secret   = length(compact(aws_iam_access_key.access_key[*].encrypted_secret)) > 0
}

output "iam_user_name" {
  description = "The user's name"
  value       = try(aws_iam_user.user[0].name, "")
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = try(aws_iam_user.user[0].arn, "")
}

output "iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = try(aws_iam_user.user[0].unique_id, "")
}

output "iam_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = try(aws_iam_user_login_profile.user_login[0].encrypted_password, "")
}

output "iam_user_login_profile_password" {
  description = "The user password"
  value       = lookup(try(aws_iam_user_login_profile.user_login[0], {}), "password", sensitive(""))
  sensitive   = true
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = try(aws_iam_access_key.access_key[0].id, "")
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = try(aws_iam_access_key.access_key[0].secret, "")
  sensitive   = true
}

output "iam_access_key_encrypted_secret" {
  description = "The encrypted secret, base64 encoded"
  value       = try(aws_iam_access_key.access_key[0].encrypted_secret, "")
}

output "iam_access_key_status" {
  description = "Active or Inactive. Keys are initially active, but can be made inactive by other means."
  value       = try(aws_iam_access_key.access_key[0].status, "")
}

output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = !local.has_encrypted_password ? null : <<EOF
echo "${try(aws_iam_user_login_profile.user_login[0].encrypted_password, "")}" | base64 --decode | keybase pgp decrypt
EOF

}

output "keybase_secret_key_decrypt_command" {
  description = "Decrypt access secret key command"
  value       = !local.has_encrypted_secret ? null : <<EOF
echo "${try(aws_iam_access_key.access_key[0].encrypted_secret, "")}" | base64 --decode | keybase pgp decrypt
EOF

}
