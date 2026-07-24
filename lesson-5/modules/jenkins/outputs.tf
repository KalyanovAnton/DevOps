output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

output "jenkins_role_arn" {
 value = aws_iam_role.jenkins_kaniko_role.arn
}