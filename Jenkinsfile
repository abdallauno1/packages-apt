pipeline {
	agent {label 'workstation'}
stages{
    stage ('Update machine'){
	 steps {
		sh 'sudo apt-get update'
	    }
	  }
	stage('Install ChefDK'){
	  steps{
			script{
				def chefDKexists  = fileExists '/usr/bin/chef-client'
				if (chefDKexists) {
					echo 'Skipping Chef install...already installed'
				}else{
					sh '''#!/bin/bash

				    		  wget wget https://packages.chef.io/files/stable/chefdk/4.13.3/ubuntu/18.04/chefdk_4.13.3-1_amd64.deb
				   		  sudo dpkg -i chefdk_4.13.3-1_amd64.deb
               				    '''
					/* sh 'wget wget https://packages.chef.io/files/stable/chefdk/4.13.3/ubuntu/18.04/chefdk_4.13.3-1_amd64.deb'
					   sh 'sudo dpkg -i chefdk_4.13.3-1_amd64.deb' */
				}
			}
		}
	}

		
	stage ('Creating directory for the configuration...'){
		steps{
			script{
		       	  def dirExists  = fileExists '/home/vagrant/chef-repo'
				  if (dirExists) {
					echo 'Skipping creating directory ...directory present'
				}else{
				    sh 'mkdir ~/chef-repo/ &&  mkdir ~/chef-repo/.chef'
				}			
			}
    	      }
    	}
	
	stage('Copy server credentials'){
		steps{
		withCredentials([file(credentialsId: 'chef-user-key', variable: 'USER'),
				 file(credentialsId: 'chef-org-key',  variable: 'ORG'),
				 file(credentialsId: 'chef-config-key', variable: 'CONFIG')]) {
			      sh '''
				    set +x
				    sudo cp --recursive "$USER"  ~/chef-repo/.chef/
				    sudo cp --recursive "$ORG"  ~/chef-repo/.chef/
				    sudo cp --recursive "$CONFIG"  ~/chef-repo/.chef/

				 '''
		   }
	    }
	 }
	 
	 stage('knife SSL certificates from the server'){
		steps{

		      sh '''
			    set +x
			    cd ~/chef-repo
			    cd ~/chef-repo/.chef
			    sudo chmod -R 777 .
			    sudo knife ssl fetch

			 '''
		}
	 }
	 stage('Bootstrap a Node'){
		steps{
		/* add all nodes you need */
	      sh '''
	    
	   	 cd ~/chef-repo/.chef
		 sudo chmod -R 777 .
	   	 knife bootstrap 192.168.1.70 -x vagrant -P vagrant --node-name test  --sudo -y chef-client --chef-license accept

		 '''
		}
	 }
	 
 	 stage('Creating cookbooks directory...'){
	    steps{
		script{
		  def dirExists  = fileExists '/home/vagrant/chef-repo/cookbooks'
		  	if (dirExists) {
				echo 'Skipping creating directory ...directory present'
		        }else{
		        	sh 'mkdir -p ~/chef-repo/cookbooks'
		    }			
		}
	     }
	 }
	stage('removing directory'){
		steps{
		    script{
		      def dirExists  = fileExists '$WORKSPACE/packages-apt/'
			   if (dirExists){
				 sh 'rm -rf $WORKSPACE/packages-apt/'	    
			   }
	   	     }
		 }		
	  }
	
	 stage('Clone github repo & download Cookbook'){
		steps{
			script{
				def repoCloned  = fileExists '$WORKSPACE/packages-apt'
				    if (repoCloned){
					  sh 'rm -rf $WORKSPACE/packages-apt'
				    }else{
					 					 
					 echo "$JOB_NAME"     
				}
				sh 'rm -rf $WORKSPACE/packages-apt'
				sh 'git clone https://github.com/abdallauno1/packages-apt.git' 
		   	  }
		      }
	  	}
	
	 stage('Moving file to cookbooks dir'){
		 steps{
			 script{
				def getRepo  = fileExists '~/chef-repo/cookbooks/packages-apt'
				    if (getRepo){
					  sh 'rm -rf ~/chef-repo/cookbooks/packages-apt'
				    } 
				   sh 'rm -rf ~/chef-repo/cookbooks/packages-apt'
				   sh 'mv $WORKSPACE/app-test ~/chef-repo/cookbooks/'
				}
		   	    }
	            }
	
	 stage('Upload the cookbook and add to the Node'){
		steps{
				/* add the cookbook in the node you can add all nodes */
			      sh '''
				    set +x
				    cd ~/chef-repo/cookbooks				  
				    knife cookbook upload app-test 
				    knife node run_list add test recipe[packages-apt::default]

				 '''
		}
	   }

	  stage(' Run the cookbook'){
		steps{
				/* add the cookbook in the node you can add all nodes */
			      sh '''
					ssh vagrant@test sudo chef-client
				 '''
		}
	     }


   }
  }
