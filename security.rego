package terraform.security

deny contains msg if {
    rc := input.resource_changes[_]
    rc.type == "aws_security_group"

    rule := rc.change.after.ingress[_]
    "0.0.0.0/0" in rule.cidr_blocks

    msg := "❌ Security Group allows traffic from 0.0.0.0/0"
}
