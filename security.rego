package terraform.security

# Collect all resources
all_resources[r] {
  r := input.planned_values.root_module.resources[_]
}

############################################
# 🔴 DENY — Public Security Group
############################################
deny contains msg if {
  r := all_resources[_]
  r.type == "aws_security_group"

  ingress := r.values.ingress[_]
  cidr := ingress.cidr_blocks[_]
  cidr == "0.0.0.0/0"

  msg := sprintf(
    "❌ BLOCKED: Security Group %s allows public ingress from 0.0.0.0/0",
    [r.name]
  )
}
