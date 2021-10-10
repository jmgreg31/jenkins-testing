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
  }
}

def Checkout() {
    checkout scm
    }
}

def Agent() {
    stage("Agent"){
        print "running on ${$NODE_NAME}"
    }
}

def Params() {
    stage("Input Parameters"){
        print TEST1
        print TEST2
    }
}