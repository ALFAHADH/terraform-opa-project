package terraform.security

############################
# 🔵 INFO – Just visibility
############################
info[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    msg := sprintf(
        "ℹ️ INFO: EC2 instance %s will be created",
        [r.name]
    )
}

############################
# 🟡 WARN – Risky but allowed
############################
warn[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_security_group"

    ingress := r.values.ingress[_]
    cidr := ingress.cidr_blocks[_]
    cidr == "0.0.0.0/0"

    msg := sprintf(
        "⚠️ WARNING: Security Group %s allows public access from 0.0.0.0/0",
        [r.name]
    )
}

############################
# 🔴 DENY – Block deployment
############################
deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_security_group"

    ingress := r.values.ingress[_]
    ingress.from_port == 22
    cidr := ingress.cidr_blocks[_]
    cidr == "0.0.0.0/0"

    msg := sprintf(
        "❌ BLOCKED: Security Group %s exposes SSH (22) to the internet",
        [r.name]
    )
}

