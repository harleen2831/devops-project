pipeline{
    agent{
        node{
            label  'maven'
        }
    }

  environment{
    PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
  }

    stages{
        stage('build'){
            steps{
               sh 'mvn clean deploy -DskipTests'
            }
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 6e814e363d3f3989986ebc0fa0ccedeabd67a173
