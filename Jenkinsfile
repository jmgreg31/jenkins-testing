#!groovy

ansiColor('xterm') { // enable color output for everything in the pipeline
  agent='agent1'
  properties([
    buildDiscarder(logRotator(numToKeepStr: '10')),
    parameters([
       choiceParam(
         name: 'TEST1',
         choices: ['testa','testb','testc'].join('\n'),
         description: 'test1'
       ),
       choiceParam(
         name: 'TEST2',
         choices: ['test1','test2','test3'].join('\n'),
         description: 'test2'
       )
    ])
  ])

  node(agent){
      Checkout()
      Agent()
      Params()
      Terraform()
  }
}

def Checkout() {
    stage("Checkout"){
        checkout scm
    }
}

def Agent() {
    stage("Agent"){
        print "running on ${NODE_NAME}"
    }
}

def Params() {
    stage("Input Parameters"){
        print TEST1
        print TEST2
    }
}

def Terraform(){
    stage ('Terraform') {
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
                        terraform plan
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
