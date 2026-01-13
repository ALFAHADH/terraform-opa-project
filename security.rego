package terraform.security

############################################
# 🔴 DENY — Hard block (security violations)
############################################
deny contains msg if {
  r := input.planned_values.root_module.resources[_]
  r.type == "aws_security_group"

  ingress := r.values.ingress[_]
  "0.0.0.0/0" in ingress.cidr_blocks

  msg := sprintf(
    "❌ BLOCKED: Security Group %s allows public ingress from 0.0.0.0/0",
    [r.name]
  )
}

############################################
# 🟡 WARN — Soft control (visibility only)
############################################
warn contains msg if {
  r := input.planned_values.root_module.resources[_]
  r.type == "aws_security_group"

  ingress := r.values.ingress[_]
  "0.0.0.0/0" in ingress.cidr_blocks

  msg := sprintf(
    "⚠️ WARNING: Security Group %s is publicly accessible. This is risky in production.",
    [r.name]
  )
}

############################################
# 🔵 INFO — Best practice advice
############################################
info contains msg if {
  r := input.planned_values.root_module.resources[_]
  r.type == "aws_security_group"

  ingress := r.values.ingress[_]
  "0.0.0.0/0" in ingress.cidr_blocks

  msg := sprintf(
    "ℹ️ INFO: Consider restricting SG %s to private CIDR or placing it behind an ALB + WAF.",
    [r.name]
  )
}

