#!groovy

ansiColor('xterm') { // enable color output for everything in the pipeline
  agent='agent1'
  properties([
    buildDiscarder(logRotator(numToKeepStr: '10')),
    parameters([
       choiceParam(
         name: 'ACTION',
         choices: ['plan','apply','destroy'].join('\n'),
         description: 'Terraform action to perform'
       )
    ])
  ])

  node(agent){
      Checkout()
      Zip()
      BuildBot()
  }
}

def Checkout() {
    stage("Checkout"){
        checkout scm
    }
}

def Zip() {
    stage('Zip Lambda Function') {
        returnStatus = sh(
            returnStatus: true,
            script: '''
                zip -r lambdaFunction.zip .
                zip -d lambdaFunction.zip '.terraform/*' || true
                zip -d lambdaFunction.zip 'terraform*' || true
                zip -d lambdaFunction.zip '.git/*' || true
            '''
        )
    }
}

def BuildBot(){
    stage ('Build Discord Bot Lambda') {
        withCredentials(
          [
              [$class: 'UsernamePasswordMultiBinding', 
              credentialsId: 'aws-secrets', 
              usernameVariable: 'AWS_KEY_ID', 
              passwordVariable: 'AWS_KEY_ACCESS']
          ]
          ) {
                returnStatus = sh(
                    returnStatus: true,
                    script: '''
                        export AWS_ACCESS_KEY_ID=$AWS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_KEY_ACCESS
                        export AWS_DEFAULT_REGION=us-east-1
                        terraform init
                        if [ $ACTION == "plan" ]; then
                            terraform $ACTION
                        else
                            terraform $ACTION -auto-approve
                        fi
                    '''
                )
                if (returnStatus != 0) {
                    currentBuild.result = 'FAILURE'
                    error_msg = 'Terraform Failed'
                    print(error_msg)
                    error(error_msg)
                } else {
                    currentBuild.result = 'SUCCESS'
                    print("SUCCESS")
                }
            }
    }
}
