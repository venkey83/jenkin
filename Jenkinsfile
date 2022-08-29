
pipeline {

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        string(name: 'region', defaultValue: 'ap-northeast-1', description: 'select region to deployment')
        string(name: 'env', defaultValue: 'dev', description: 'select environment to deployment')
        string(name: 'service', defaultValue: '', description: 'please provide service name')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
        options {
                timestamps ()
             ansiColor('xterm')
            }
    stages {
        stage('checkout') {
            steps {
                  git branch: "master", url: "https://github.com/venkey83/jenkin.git"
                  }
            }

        stage('Plan') {
            steps {
                sh '''
                  terraform init \
                      -upgrade=true \
                      -get=true \
                      -input=true \
                      -force-copy \
                      -backend=true \
                      -backend-config "bucket=terraform-backend-vk" \
                      -backend-config "key=terraform-${region}/${service}.tfstate" \
                      -backend-config "region=${region}" \
                      -backend-config "dynamodb_table=terraform" \
                      -lock=true
                '''
                sh """#!/bin/bash
                  terraform workspace show | grep ${environment} ; if [ "\$?" == 0 ];then echo "workspace already exists ";else terraform workspace new ${environment}; fi;
                echo "INFO: Terraform -> Working for ${environment}";
                #terraform plan -var-file=dev.tfvars -out tfplan
                terraform plan -destroy -var-file=dev.tfvars -out tfplan;
                terraform show -no-color tfplan > tfplan.txt;
                """
            }
        }
        stage('Approval') {
          when {
              not {
                  equals expected: true, actual: params.autoApprove
              }
          }

          steps {
              script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
              }
          }
      }
        
         stage('Destroy') {
            steps {
                sh "terraform destroy -input=false tfplan "
            }
        }
      
    }

  }
